//====-- PULPHardwareLoops.cpp - Identify and generate hardware loops ----====//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This pass identifies loops where we can generate the PULP hardware
// loop instruction.  The hardware loop can perform loop branches with a
// zero-cycle overhead.
//
//  This file is based on the lib/Target/Hexagon/HexagonHardwareLoops.cpp file.
//
//===----------------------------------------------------------------------===//

#include "../RISCVInstrInfo.h"
#include "../RISCVRegisterInfo.h"
#include "../RISCVSubtarget.h"
#include "llvm/ADT/STLFunctionalExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineDominators.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineLoopInfo.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
#include <cassert>
#include <cstdint>
#include <cstdlib>
#include <iterator>
#include <map>
#include <optional>
#include <set>
#include <string>
#include <utility>
#include <vector>

using namespace llvm;

#define DEBUG_TYPE "pulp-hwloops"

// Turn it off by default. If a preheader block is not created here, the
// software pipeliner may be unable to find a block suitable to serve as
// a preheader. In that case SWP will not run.
static cl::opt<bool> SpecPreheader("pulp-hwloop-spec-preheader",
                                   cl::init(false), cl::Hidden, cl::ZeroOrMore,
                                   cl::desc("Allow speculation of preheader "
                                            "instructions"));

STATISTIC(NumHWLoops, "Number of loops converted to hardware loops");

namespace llvm {

FunctionPass *createPULPHardwareLoops();
void initializePULPHardwareLoopsPass(PassRegistry &);

} // end namespace llvm

namespace {

class CountValue;

struct PULPHardwareLoops : public MachineFunctionPass {
  MachineLoopInfo *MLI;
  MachineRegisterInfo *MRI;
  MachineDominatorTree *MDT;
  const RISCVInstrInfo *TII;
  const RISCVRegisterInfo *TRI;

  unsigned NumHWLoopsInternal = 0;

public:
  static char ID;

  PULPHardwareLoops() : MachineFunctionPass(ID) {}

  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override { return "PULP Hardware Loops"; }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<MachineDominatorTreeWrapperPass>();
    AU.addRequired<MachineLoopInfoWrapperPass>();
    MachineFunctionPass::getAnalysisUsage(AU);
  }

private:
  using LoopFeederMap = std::map<unsigned, MachineInstr *>;
  std::set<const MachineInstr *> KnownHardwareLoops;

  /// Kinds of comparisons in the compare instructions.
  struct Comparison {
    enum Kind {
      EQ = 0x01,
      NE = 0x02,
      L = 0x04,
      G = 0x08,
      U = 0x40,
      LTs = L,
      LEs = L | EQ,
      GTs = G,
      GEs = G | EQ,
      LTu = L | U,
      LEu = L | EQ | U,
      GTu = G | U,
      GEu = G | EQ | U
    };

    static Kind getSwappedComparison(Kind Cmp) {
      assert((!((Cmp & L) && (Cmp & G))) && "Malformed comparison operator");
      if ((Cmp & L) || (Cmp & G))
        return (Kind)(Cmp ^ (L | G));
      return Cmp;
    }

    static Kind getNegatedComparison(Kind Cmp) {
      if ((Cmp & L) || (Cmp & G))
        return (Kind)((Cmp ^ (L | G)) ^ EQ);
      if ((Cmp & NE) || (Cmp & EQ))
        return (Kind)(Cmp ^ (EQ | NE));
      return (Kind)0;
    }

    static bool isSigned(Kind Cmp) { return (Cmp & (L | G) && !(Cmp & U)); }

    static bool isUnsigned(Kind Cmp) { return (Cmp & U); }
  };

  /// Find the register that contains the loop controlling
  /// induction variable.
  /// If successful, it will return true and set the \p Reg, \p IVBump
  /// and \p IVOp arguments.  Otherwise it will return false.
  /// The returned induction register is the register R that follows the
  /// following induction pattern:
  /// loop:
  ///   R = phi ..., [ R.next, LatchBlock ]
  ///   R.next = R + #bump
  ///   if (R.next < #N) goto loop
  /// IVBump is the immediate value added to R, and IVOp is the instruction
  /// "R.next = R + #bump".
  bool findInductionRegister(MachineLoop *L, unsigned &Reg, int64_t &IVBump,
                             MachineInstr *&IVOp) const;

  /// Return the comparison kind for the specified opcode.
  Comparison::Kind getComparisonKind(unsigned CondOpc,
                                     MachineOperand *InitialValue,
                                     const MachineOperand *Endvalue,
                                     int64_t IVBump) const;

  // Return the internal (used internally by this pass) comparison kind for
  // the specified RISCV condition code.
  Comparison::Kind getComparisonKindFromCC(unsigned CC,
                                           MachineOperand *InitialValue,
                                           const MachineOperand *EndValue,
                                           int64_t IVBump) const;

  /// Analyze the statements in a loop to determine if the loop
  /// has a computable trip count and, if so, return a value that represents
  /// the trip count expression.
  CountValue *getLoopTripCount(MachineLoop *L,
                               SmallVectorImpl<MachineInstr *> &OldInsts);

  /// Return the expression that represents the number of times
  /// a loop iterates.  The function takes the operands that represent the
  /// loop start value, loop end value, and induction value.  Based upon
  /// these operands, the function attempts to compute the trip count.
  /// If the trip count is not directly available (as an immediate value,
  /// or a register), the function will attempt to insert computation of it
  /// to the loop's preheader.
  CountValue *computeCount(MachineLoop *Loop, const MachineOperand *Start,
                           const MachineOperand *End, unsigned IVReg,
                           int64_t IVBump, Comparison::Kind Cmp) const;

  /// Return true if the loop is only entered when Start < End (Start <= End
  /// if HasEqual), with the given signedness, so that the iteration count
  /// needs no runtime guard.
  bool isDistanceCheckedOnEntry(MachineLoop *L, const MachineOperand *Start,
                                const MachineOperand *End, bool StartIsImm,
                                int64_t StartImm, bool EndIsImm,
                                int64_t EndImm, bool IsUnsigned,
                                bool HasEqual) const;

  /// Return true if a conditional branch that dominates the loop entry
  /// establishes "A K B" for a comparison kind K accepted by \p Accept.
  bool isRelationTrueOnEntry(MachineLoop *L, const MachineOperand *A,
                             bool AIsImm, int64_t AImm, const MachineOperand *B,
                             bool BIsImm, int64_t BImm,
                             function_ref<bool(Comparison::Kind)> Accept) const;

  /// Return true if the instruction is not valid within a hardware
  /// loop.
  bool isInvalidLoopOperation(const MachineInstr *MI) const;

  /// Return true if the loop contains an instruction that inhibits
  /// using the hardware loop.
  bool containsInvalidInstruction(MachineLoop *L) const;

  /// Given a loop, check if we can convert it to a hardware loop.
  /// If so, then perform the conversion and return true.
  bool convertToHardwareLoop(MachineLoop *L, bool &L0used, bool &L1used);

  /// Return true if the instruction is now dead.
  bool isDead(const MachineInstr *MI,
              SmallVectorImpl<MachineInstr *> &DeadPhis) const;

  /// Remove the instruction if it is now dead.
  void removeIfDead(MachineInstr *MI);

  /// Return true if MO and MI pair is visited only once. If visited
  /// more than once, this indicates there is recursion. In such a case,
  /// return false.
  bool isLoopFeeder(MachineLoop *L, MachineBasicBlock *A, MachineInstr *MI,
                    const MachineOperand *MO,
                    LoopFeederMap &LoopFeederPhi) const;

  /// Return true if the Phi may generate a value that may underflow,
  /// or may wrap.
  bool phiMayWrapOrUnderflow(MachineInstr *Phi, const MachineOperand *EndVal,
                             MachineBasicBlock *MBB, MachineLoop *L,
                             LoopFeederMap &LoopFeederPhi) const;

  /// Return true if the induction variable may underflow an unsigned
  /// value in the first iteration.
  bool loopCountMayWrapOrUnderFlow(const MachineOperand *InitVal,
                                   const MachineOperand *EndVal,
                                   MachineBasicBlock *MBB, MachineLoop *L,
                                   LoopFeederMap &LoopFeederPhi) const;

  /// Check if the given operand has a compile-time known constant
  /// value. Return true if yes, and false otherwise. When returning true, set
  /// Val to the corresponding constant value.
  bool checkForImmediate(const MachineOperand &MO, int64_t &Val) const;
};

char PULPHardwareLoops::ID = 0;

/// Abstraction for a trip count of a loop. A smaller version
/// of the MachineOperand class without the concerns of changing the
/// operand representation.
class CountValue {
public:
  enum CountValueType { CV_Register, CV_Immediate };

private:
  CountValueType Kind;
  union Values {
    struct {
      unsigned Reg;
      unsigned Sub;
    } R;
    unsigned ImmVal;
  } Contents;

public:
  explicit CountValue(CountValueType t, unsigned v, unsigned u = 0) {
    Kind = t;
    if (Kind == CV_Register) {
      Contents.R.Reg = v;
      Contents.R.Sub = u;
    } else {
      Contents.ImmVal = v;
    }
  }

  bool isReg() const { return Kind == CV_Register; }
  bool isImm() const { return Kind == CV_Immediate; }

  unsigned getReg() const {
    assert(isReg() && "Wrong CountValue accessor");
    return Contents.R.Reg;
  }

  unsigned getSubReg() const {
    assert(isReg() && "Wrong CountValue accessor");
    return Contents.R.Sub;
  }

  unsigned getImm() const {
    assert(isImm() && "Wrong CountValue accessor");
    return Contents.ImmVal;
  }

  void print(raw_ostream &OS, const TargetRegisterInfo *TRI = nullptr) const {
    if (isReg()) {
      OS << printReg(Contents.R.Reg, TRI, Contents.R.Sub);
    }
    if (isImm()) {
      OS << Contents.ImmVal;
    }
  }
};

} // end anonymous namespace

INITIALIZE_PASS_BEGIN(PULPHardwareLoops, "pulp-hwloops", "PULP Hardware Loops",
                      false, false)
INITIALIZE_PASS_DEPENDENCY(MachineDominatorTreeWrapperPass)
INITIALIZE_PASS_DEPENDENCY(MachineLoopInfoWrapperPass)
INITIALIZE_PASS_END(PULPHardwareLoops, "pulp-hwloops", "PULP Hardware Loops",
                    false, false)

FunctionPass *llvm::createPULPHardwareLoops() {
  return new PULPHardwareLoops();
}

bool PULPHardwareLoops::runOnMachineFunction(MachineFunction &MF) {
  LLVM_DEBUG(dbgs() << "********* PULP Hardware Loops *********\n");

  // We can only use hardware loops if we have the PULPv2 extension enabled.
  if (!MF.getSubtarget<RISCVSubtarget>().hasPULPExtV2()) {
    LLVM_DEBUG(dbgs() << "No Xpulp extension, skipping.\n");
    return false;
  }

  if (skipFunction(MF.getFunction())) {
    LLVM_DEBUG(
        dbgs() << "Machine function marked to be skipped, bailing out.\n");
    return false;
  }

  LLVM_DEBUG(dbgs() << "Analysing: \n"; MF.dump(); dbgs() << "\n");

  bool Changed = false;
  NumHWLoopsInternal = 0;

  MLI = &getAnalysis<MachineLoopInfoWrapperPass>().getLI();
  MRI = &MF.getRegInfo();
  MDT = &getAnalysis<MachineDominatorTreeWrapperPass>().getDomTree();
  const RISCVSubtarget &HST = MF.getSubtarget<RISCVSubtarget>();
  TII = HST.getInstrInfo();
  TRI = HST.getRegisterInfo();

  for (auto &L : *MLI)
    if (L->isOutermost()) {
      bool L0Used = false;
      bool L1Used = false;
      KnownHardwareLoops.clear();
      Changed |= convertToHardwareLoop(L, L0Used, L1Used);
    }

  if (Changed) {
    LLVM_DEBUG(dbgs() << "Created " << NumHWLoopsInternal
                      << " hardware loops in " << MF.getName() << "\n";);
  }

  return Changed;
}

namespace {

struct InductionUpdateOperands {
  unsigned IndUpdate;
  unsigned IndDef;
  unsigned Bump;
};

auto getInductionUpdateParts(const MachineInstr *Update)
    -> std::optional<InductionUpdateOperands> {

  // Note: Update->getDesc().isAdd() is not usable
  // since it relies on machine instructions having the
  // isAdd predicate correctly set. This is not the case
  // for RISCV, so we need to enumerate instructions known
  // to be additions.

  InductionUpdateOperands Result;

  switch (Update->getOpcode()) {
  default:
    return std::nullopt;
  case RISCV::ADD:
  case RISCV::ADDI:
  case RISCV::ADDW:
    // %Rnext:gpr = ADDI %R:gpr, 4
    //      ^               ^    ^
    // 0: IndUpdate   1: IndDef 2: Bump
    Result.IndUpdate = 0;
    Result.IndDef = 1;
    Result.Bump = 2;
    break;
  case RISCV::P_LW_ri_PostIncrement:
  case RISCV::P_LW_rr_PostIncrement:
  case RISCV::P_LBU_ri_PostIncrement:
  case RISCV::P_LBU_rr_PostIncrement:
  case RISCV::P_LB_ri_PostIncrement:
  case RISCV::P_LB_rr_PostIncrement:
  case RISCV::P_LHU_ri_PostIncrement:
  case RISCV::P_LHU_rr_PostIncrement:
  case RISCV::P_LH_ri_PostIncrement:
  case RISCV::P_LH_rr_PostIncrement:
    // %value:gpr, %Rnext:gpr = P_LW_ri_PostIncrement %R:gpr(tied-def 1), 4
    //                ^                                   ^               ^
    //           1: IndUpdate                         2: IndDef        3: Bump
    Result.IndUpdate = 1;
    Result.IndDef = 2;
    Result.Bump = 3;
    break;
  }

  return Result;
}

} // namespace

/// Find the register that contains the loop controlling
/// induction variable.
/// If successful, it will return true and set the \p Reg, \p IVBump
/// and \p IVOp arguments.  Otherwise it will return false.
/// The returned induction register is the register R that follows the
/// following induction pattern:
/// loop:
///   R = phi ..., [ R.next, LatchBlock ]
///   R.next = R + #bump
///   if (R.next < #N) goto loop
/// IVBump is the immediate value added to R, and IVOp is the instruction
/// "R.next = R + #bump".
///
/// Let's consider a loop where a post-increment load (p.lw) is the update
/// instruction:
///
///  bb.3.for.body:
///  ; predecessors: %bb.1.for.body.preheader, %bb.3.for.body
///  %next:gpr = PHI %init:gpr, %bb.1.for.body.preheader, %cur:gpr,
///  %bb.3.for.body %value:gpr, %cur:gpr = P_LW_ri_PostIncrement
///  %next:gpr(tied-def 1), 4 BEQ %cur:gpr, %0:gpr, %bb.2 PseudoBR %bb.3
///
/// It will be analyzed as:
///
///  bb.loop:
///    %R:gpr = PHI %latch:gpr, %bb.latch, %Rnext:gpr, %bb.loop
///    %value:gpr, %Rnext:gpr = P_LW_ri_PostIncrement %R:gpr(tied-def 1), 4
///    BEQ %Rnext:gpr, %N:gpr, %bb.end
///    PseudoBR %bb.loop
bool PULPHardwareLoops::findInductionRegister(MachineLoop *L, unsigned &Reg,
                                              int64_t &IVBump,
                                              MachineInstr *&IVOp) const {
  MachineBasicBlock *Header = L->getHeader();
  MachineBasicBlock *Preheader = MLI->findLoopPreheader(L, SpecPreheader);
  MachineBasicBlock *Latch = L->getLoopLatch();
  MachineBasicBlock *ExitingBlock = L->findLoopControlBlock();
  if (!Header || !Preheader || !Latch || !ExitingBlock)
    return false;

  // This pair represents an induction register together with an immediate
  // value that will be added to it in each loop iteration.
  using RegisterBump = std::pair<Register, int64_t>;

  // Mapping:  R.next -> (R, bump), where R, R.next and bump are derived
  // from an induction operation
  //   R.next = R + bump
  // where bump is an immediate value.
  using InductionMap = std::map<Register, RegisterBump>;

  InductionMap IndMap;

  using instr_iterator = MachineBasicBlock::instr_iterator;

  for (instr_iterator I = Header->instr_begin(), E = Header->instr_end();
       I != E && I->isPHI(); ++I) {
    MachineInstr *Phi = &*I;

    // Have a PHI instruction.  Get the operand that corresponds to the
    // latch block, and see if is a result of an addition of form "reg+imm",
    // where the "reg" is defined by the PHI node we are looking at.
    for (unsigned i = 1, n = Phi->getNumOperands(); i < n; i += 2) {
      if (Phi->getOperand(i + 1).getMBB() != Latch)
        continue;

      Register PhiOpReg = Phi->getOperand(i).getReg();
      MachineInstr *DI = MRI->getVRegDef(PhiOpReg);

      LLVM_DEBUG(dbgs() << "Induction PHI candidate: "; Phi->dump();
                 dbgs() << "\n");
      LLVM_DEBUG(dbgs() << "Induction update candidate: "; DI->dump();
                 dbgs() << "\n");
      auto OperandIndices = getInductionUpdateParts(DI);
      if (!OperandIndices.has_value())
        continue;
      LLVM_DEBUG(dbgs() << "Elected induction update: "; DI->dump();
                 dbgs() << "\n");

      const MachineOperand &IndUpdate =
          DI->getOperand(OperandIndices.value().IndUpdate);
      const MachineOperand &IndDef =
          DI->getOperand(OperandIndices.value().IndDef);
      const MachineOperand &Bump = DI->getOperand(OperandIndices.value().Bump);

      // If the register operand to the add is the PHI we're looking at, this
      // meets the induction pattern.
      Register IndReg = IndDef.getReg();
      MachineInstr *IndRegDef = MRI->getVRegDef(IndReg);
      int64_t V;
      bool IsBumpImm = checkForImmediate(Bump, V);
      // If the register operand to the update is the PHI we're looking at, this
      // meets the induction pattern:
      bool IndRegDefIsPhi = IndRegDef == Phi;

      if (!IndRegDefIsPhi || !IsBumpImm)
        continue;

      Register UpdReg = IndUpdate.getReg();
      IndMap.insert(std::make_pair(UpdReg, std::make_pair(IndReg, V)));
    }
  }

  // If we couldn't find any registers used for the induction, we fail.
  if (IndMap.empty()) {
    return false;
  }

  MachineBasicBlock *TB = nullptr, *FB = nullptr;
  SmallVector<MachineOperand, 2> Cond;
  // Check that the exit branch can be analyzed.
  // AnalyzeBranch returns true if it fails to analyze branch.
  bool NotAnalyzed = TII->analyzeBranch(*ExitingBlock, TB, FB, Cond, false);
  const auto Terminators = Latch->terminators();
  assert(!Terminators.empty());
  const auto NumTerminators =
      std::distance(std::begin(Terminators), std::end(Terminators));
  if (NotAnalyzed
      // The rest of this function is based on the assumption that we have
      // at least 2x terminators, so bail out if this is not the case.
      || NumTerminators < 2 || Cond.size() < 2) {
    return false;
  }

  // We now know there are two terminators, one conditional and one
  // unconditional. If the order does not match what we expect, bail out.
  MachineInstr *condTerm = &(*std::begin(Terminators));
  MachineInstr *uncondTerm = &(*std::next(std::begin(Terminators)));
  if (!(condTerm->getDesc().isConditionalBranch() &&
        uncondTerm->getDesc().isUnconditionalBranch())) {
    return false;
  }

  // Get the register numbers
  unsigned CmpReg1 = Cond[1].isReg() ? (unsigned)Cond[1].getReg() : 0;
  unsigned CmpReg2 = Cond[2].isReg() ? (unsigned)Cond[2].getReg() : 0;

  // Exactly one of the input registers to the comparison should be among
  // the induction registers.
  InductionMap::iterator IndMapEnd = IndMap.end();
  InductionMap::iterator F = IndMapEnd;
  if (CmpReg1 != 0) {
    InductionMap::iterator F1 = IndMap.find(CmpReg1);
    if (F1 != IndMapEnd)
      F = F1;
  }
  if (CmpReg2 != 0) {
    InductionMap::iterator F2 = IndMap.find(CmpReg2);
    if (F2 != IndMapEnd) {
      if (F != IndMapEnd)
        return false;
      F = F2;
    }
  }
  if (F == IndMapEnd)
    return false;

  Reg = F->second.first;
  IVBump = F->second.second;
  IVOp = MRI->getVRegDef(F->first);
  return true;
}

// Return the comparison kind for the specified opcode.
PULPHardwareLoops::Comparison::Kind PULPHardwareLoops::getComparisonKind(
    unsigned CondOpc, MachineOperand *InitialValue,
    const MachineOperand *EndValue, int64_t IVBump) const {

  Comparison::Kind Cmp = (Comparison::Kind)0;
  switch (CondOpc) {
  case RISCV::BEQ:
    Cmp = Comparison::EQ;
    break;
  case RISCV::BNE:
    Cmp = Comparison::NE;
    break;
  case RISCV::BLT:
    Cmp = Comparison::LTs;
    break;
  case RISCV::BLTU:
    Cmp = Comparison::LTu;
    break;
  case RISCV::BGE:
    Cmp = Comparison::GEs;
    break;
  case RISCV::BGEU:
    Cmp = Comparison::GEu;
    break;
  case RISCV::P_BNEIMM:
    Cmp = Comparison::NE;
    break;
  case RISCV::P_BEQIMM:
    Cmp = Comparison::EQ;
    break;
  default:
    return (Comparison::Kind)0;
  }
  return Cmp;
}

// Return the internal (used internally by this pass) comparison kind for
// the specified RISCV condition code.
PULPHardwareLoops::Comparison::Kind PULPHardwareLoops::getComparisonKindFromCC(
    unsigned CC, MachineOperand *InitialValue, const MachineOperand *EndValue,
    int64_t IVBump) const {
  Comparison::Kind Cmp = (Comparison::Kind)0;
  switch (CC) {
  default:
    break;
  case RISCVCC::COND_EQ:
  case RISCVCC::COND_P_BEQIMM:
    Cmp = Comparison::EQ;
    break;
  case RISCVCC::COND_NE:
  case RISCVCC::COND_P_BNEIMM:
    Cmp = Comparison::NE;
    break;
  case RISCVCC::COND_LT:
    Cmp = Comparison::LTs;
    break;
  case RISCVCC::COND_LTU:
    Cmp = Comparison::LTu;
    break;
  case RISCVCC::COND_GE:
    Cmp = Comparison::GEs;
    break;
  case RISCVCC::COND_GEU:
    Cmp = Comparison::GEu;
    break;
  };
  return Cmp;
}

/// Analyze the statements in a loop to determine if the loop has
/// a computable trip count and, if so, return a value that represents
/// the trip count expression.
///
/// This function iterates over the phi nodes in the loop to check for
/// induction variable patterns that are used in the calculation for
/// the number of time the loop is executed.
CountValue *
PULPHardwareLoops::getLoopTripCount(MachineLoop *L,
                                    SmallVectorImpl<MachineInstr *> &OldInsts) {

  MachineBasicBlock *TopMBB = L->getTopBlock();
  MachineBasicBlock::pred_iterator PI = TopMBB->pred_begin();
  assert(PI != TopMBB->pred_end() &&
         "Loop must have more than one incoming edge!");
  MachineBasicBlock *Backedge = *PI++;
  if (PI == TopMBB->pred_end()) { // dead loop?
    return nullptr;
  }
  MachineBasicBlock *Incoming = *PI++;
  if (PI != TopMBB->pred_end()) { // multiple backedges?
    return nullptr;
  }

  // Make sure there is one incoming and one backedge and determine which
  // is which.
  if (L->contains(Incoming)) {
    if (L->contains(Backedge)) {
      return nullptr;
    }
    std::swap(Incoming, Backedge);
  } else if (!L->contains(Backedge)) {
    return nullptr;
  }

  // Look for the cmp instruction to determine if we can get a useful trip
  // count.  The trip count can be either a register or an immediate.  The
  // location of the value depends upon the type (reg or imm).
  MachineBasicBlock *ExitingBlock = L->findLoopControlBlock();
  if (!ExitingBlock) {
    return nullptr;
  }

  // Find the registers used to hold the induction variable.
  unsigned IVReg = 0;
  int64_t IVBump = 0;
  MachineInstr *IVOp;
  bool FoundIV = findInductionRegister(L, IVReg, IVBump, IVOp);
  if (!FoundIV) {
    return nullptr;
  }

  MachineBasicBlock *Preheader = MLI->findLoopPreheader(L, SpecPreheader);

  MachineOperand *InitialValue = nullptr;
  MachineInstr *IV_Phi = MRI->getVRegDef(IVReg);
  MachineBasicBlock *Latch = L->getLoopLatch();
  for (unsigned i = 1, n = IV_Phi->getNumOperands(); i < n; i += 2) {
    MachineBasicBlock *MBB = IV_Phi->getOperand(i + 1).getMBB();
    if (MBB == Preheader)
      InitialValue = &IV_Phi->getOperand(i);
    else if (MBB == Latch)
      IVReg = IV_Phi->getOperand(i).getReg(); // Want IV reg after bump.
  }
  if (!InitialValue) {
    return nullptr;
  }

  SmallVector<MachineOperand, 2> Cond;
  MachineBasicBlock *TB = nullptr, *FB = nullptr;
  bool NotAnalyzed = TII->analyzeBranch(*ExitingBlock, TB, FB, Cond, false);
  if (NotAnalyzed) {
    return nullptr;
  }

  MachineBasicBlock *Header = L->getHeader();
  // TB must be non-null.  If FB is also non-null, one of them must be
  // the header.  Otherwise, branch to TB could be exiting the loop, and
  // the fall through can go to the header.
  assert(TB && "Exit block without a branch?");
  if (ExitingBlock != Latch && (TB == Latch || FB == Latch)) {
    MachineBasicBlock *LTB = nullptr, *LFB = nullptr;
    SmallVector<MachineOperand, 2> LCond;
    bool NotAnalyzed = TII->analyzeBranch(*Latch, LTB, LFB, LCond, false);
    if (NotAnalyzed) {
      return nullptr;
    }
    if (TB == Latch)
      TB = (LTB == Header) ? LTB : LFB;
    else
      FB = (LTB == Header) ? LTB : LFB;
  }
  assert((!FB || TB == Header || FB == Header) && "Branches not to header?");
  if (!TB || (FB && TB != Header && FB != Header)) {
    return nullptr;
  }

  // As in HexagonHardwareLoops: if the taken target TB is not the header,
  // the loop continues on the not-taken path, i.e. while the condition is
  // false, so the comparison has to be negated. RISC-V conditional branches
  // have no negated-predicate form (Hexagon's predOpcodeHasNot), so the
  // branch direction is the only source of negation.
  bool Negated = TB != Header;

  // We now know there are two terminators, one conditional and one
  // unconditional. Double check to be sure.
  MachineBasicBlock::iterator firstTerm = Latch->getFirstTerminator();
  MachineBasicBlock::iterator secondTerm = std::next(firstTerm);
  if (!(firstTerm->getDesc().isConditionalBranch() &&
        secondTerm->getDesc().isUnconditionalBranch())) {
    return nullptr;
  }

  unsigned CondOpc = Cond[0].getImm();

  // The comparison operator type determines how we compute the loop
  // trip count.
  OldInsts.push_back(IVOp);

  // Sadly, the following code gets information based on the position
  // of the operands in the compare instruction.  This has to be done
  // this way, because the comparisons check for a specific relationship
  // between the operands (e.g. is-less-than), rather than to find out
  // what relationship the operands are in (as on PPC).
  Comparison::Kind Cmp;
  bool isSwapped = false;
  const MachineOperand &Op1 = Cond[1];
  const MachineOperand &Op2 = Cond[2];
  const MachineOperand *EndValue = nullptr;

  if (Op1.isReg()) {
    if (Op2.isImm() || Op1.getReg() == IVReg)
      EndValue = &Op2;
    else {
      EndValue = &Op1;
      isSwapped = true;
    }
  }

  if (!EndValue) {
    return nullptr;
  }

  Cmp = getComparisonKindFromCC(CondOpc, InitialValue, EndValue, IVBump);
  if (!Cmp) {
    return nullptr;
  }
  if (Negated)
    Cmp = Comparison::getNegatedComparison(Cmp);
  if (isSwapped)
    Cmp = Comparison::getSwappedComparison(Cmp);

  // Unlike Hexagon, RISC-V instruction selection compares against the
  // constant 0 by using the physical zero register directly, e.g. the latch
  // of a count-down loop is "BNE %iv.next, $x0". A physical register has no
  // virtual-register definition (getVRegDef returns null), so it cannot be
  // checked for dominance nor collected as a dead old instruction. $x0 is a
  // known constant that is available everywhere; any other physical register
  // has an unknown value at the preheader, so do not form a hardware loop.
  if (InitialValue->isReg() && InitialValue->getReg().isPhysical()) {
    int64_t V;
    if (!checkForImmediate(*InitialValue, V)) {
      return nullptr;
    }
  } else if (InitialValue->isReg()) {
    llvm::Register R = InitialValue->getReg();
    MachineBasicBlock *DefBB = MRI->getVRegDef(R)->getParent();
    if (!MDT->properlyDominates(DefBB, Header)) {
      int64_t V;
      if (!checkForImmediate(*InitialValue, V)) {
        return nullptr;
      }
    }
    OldInsts.push_back(MRI->getVRegDef(R));
  }
  if (EndValue->isReg() && EndValue->getReg().isPhysical()) {
    int64_t V;
    if (!checkForImmediate(*EndValue, V)) {
      return nullptr;
    }
  } else if (EndValue->isReg()) {
    llvm::Register R = EndValue->getReg();
    MachineBasicBlock *DefBB = MRI->getVRegDef(R)->getParent();
    if (!MDT->properlyDominates(DefBB, Header)) {
      int64_t V;
      if (!checkForImmediate(*EndValue, V)) {
        return nullptr;
      }
    }
    OldInsts.push_back(MRI->getVRegDef(R));
  }

  return computeCount(L, InitialValue, EndValue, IVReg, IVBump, Cmp);
}

/// Helper function that returns the expression that represents the
/// number of times a loop iterates.  The function takes the operands that
/// represent the loop start value, loop end value, and induction value.
/// Based upon these operands, the function attempts to compute the trip count.
///
/// The loop is a do/while loop: its body runs once before the latch compares
/// the bumped induction value with End. Cmp is the relation under which the
/// loop continues, "IV.next Cmp End" (already negated for a latch that
/// branches to the exit and swapped when the IV is the second operand).
/// Like HexagonHardwareLoops::computeCount this returns exactly that number of
/// iterations, and 1 when the first comparison already fails; for the ordered
/// comparisons the register path emits a runtime guard for the latter case.
CountValue *PULPHardwareLoops::computeCount(MachineLoop *Loop,
                                            const MachineOperand *Start,
                                            const MachineOperand *End,
                                            unsigned IVReg, int64_t IVBump,
                                            Comparison::Kind Cmp) const {
  LLVM_DEBUG(dbgs() << "Initial Value: " << *Start << "\n");
  LLVM_DEBUG(dbgs() << "End Value: " << *End << "\n");
  LLVM_DEBUG(dbgs() << "Inc/Dec Value: " << IVBump << "\n");
  LLVM_DEBUG(dbgs() << "Comparison: " << Cmp << "\n");

  // Get the preheader
  MachineBasicBlock *PH = MLI->findLoopPreheader(Loop, SpecPreheader);
  assert(PH && "Should have a preheader by now");
  MachineBasicBlock::iterator InsertPos = PH->getFirstTerminator();
  DebugLoc DL;
  if (InsertPos != PH->end())
    DL = InsertPos->getDebugLoc();
  const TargetRegisterClass *IntRC = &RISCV::GPRRegClass;

  bool startIsImm = false, endIsImm = false;
  int64_t immStart, immEnd;
  startIsImm = checkForImmediate(*Start, immStart);
  endIsImm = checkForImmediate(*End, immEnd);
  if (endIsImm && !End->isImm()) {
    if (immEnd == 0) {
      llvm::Register VGPR = MRI->createVirtualRegister(IntRC);
      MachineInstrBuilder ZeroInit =
          BuildMI(*PH, InsertPos, DL, TII->get(TargetOpcode::COPY), VGPR);
      ZeroInit.addReg(RISCV::X0);
      End = &ZeroInit->getOperand(0);
    }
  }

  // getLoopTripCount accepts a start or end register whose definition does not
  // dominate the loop header when it holds a known constant, e.g. an
  // "ADDI $x0, 256" left inside the loop because a phi after the loop uses
  // the same constant. That register is not available in the preheader, where
  // the count is computed, so use the immediate instead, as
  // HexagonHardwareLoops::computeCount does for a register assigned an
  // immediate (A2_tfrsi). A register that is available keeps being used.
  MachineOperand StartImmOp = MachineOperand::CreateImm(immStart);
  MachineOperand EndImmOp = MachineOperand::CreateImm(immEnd);
  auto isAvailableInPreheader = [&](const MachineOperand *MO) {
    if (!MO->isReg() || !MO->getReg().isVirtual())
      return true;
    const MachineInstr *Def = MRI->getVRegDef(MO->getReg());
    return Def && MDT->dominates(Def->getParent(), PH);
  };
  if (startIsImm && !isAvailableInPreheader(Start))
    Start = &StartImmOp;
  if (endIsImm && !isAvailableInPreheader(End))
    End = &EndImmOp;

  // Cannot handle comparison EQ, i.e. while (A == B): such a loop runs once
  // or twice, it is not a counting loop (same as HexagonHardwareLoops).
  if (Cmp == Comparison::EQ)
    return nullptr;

  if (!Start->isReg() && !startIsImm)
    return nullptr;
  if (!End->isReg() && !endIsImm)
    return nullptr;
  // An immediate operand is used in a single ADDI below (negated for Start).
  if ((Start->isImm() && (!isInt<12>(immStart) || !isInt<12>(-immStart))) ||
      (End->isImm() && !isInt<12>(immEnd)))
    return nullptr;

  bool CmpLess = Cmp & Comparison::L;
  bool CmpGreater = Cmp & Comparison::G;
  bool CmpHasEqual = Cmp & Comparison::EQ;

  if (IVBump == 0)
    return nullptr;

  // Avoid certain wrap-arounds.  This doesn't detect all wrap-arounds.
  if (CmpLess && IVBump < 0)
    // Loop going while iv is "less" with the iv value going down.  Must wrap.
    return nullptr;

  if (CmpGreater && IVBump > 0)
    // Loop going while iv is "greater" with the iv value going up.  Must wrap.
    return nullptr;

  // Phis that may feed into the loop.
  LoopFeederMap LoopFeederPhi;

  // Check if the initial value may be equal to the final value of a "!="
  // loop. The iteration count computed below would then be 0, while the
  // loop really wraps around the whole 32-bit range; a PULP hardware loop
  // with a count of 0 runs its body only once. The ordered comparisons do not
  // need this check: a zero or negative distance is handled by the runtime
  // guard below, which gives the one iteration that the do/while body runs.
  // A dominating branch that establishes Start != End (or a strict order
  // between them) settles it without the heuristic.
  if (Cmp == Comparison::NE &&
      !isRelationTrueOnEntry(Loop, Start, startIsImm, immStart, End, endIsImm,
                             immEnd,
                             [](Comparison::Kind K) {
                               return K == Comparison::NE ||
                                      ((K & (Comparison::L | Comparison::G)) &&
                                       !(K & Comparison::EQ));
                             }) &&
      loopCountMayWrapOrUnderFlow(Start, End, Loop->getLoopPreheader(), Loop,
                                  LoopFeederPhi))
    return nullptr;

  if (startIsImm && endIsImm) {
    // Both, start and end are immediates. Compare them with the signedness
    // of the comparison, as the 32-bit registers would.
    int64_t StartV, EndV;
    if (Comparison::isUnsigned(Cmp)) {
      StartV = static_cast<uint32_t>(immStart);
      EndV = static_cast<uint32_t>(immEnd);
    } else {
      StartV = static_cast<int32_t>(immStart);
      EndV = static_cast<int32_t>(immEnd);
    }
    int64_t Dist = EndV - StartV;
    if (Dist == 0)
      return nullptr;

    bool Exact = (Dist % IVBump) == 0;

    if (Cmp == Comparison::NE) {
      if (!Exact)
        return nullptr;
      if ((Dist < 0) ^ (IVBump < 0))
        return nullptr;
    }

    // For comparisons that include the final value (i.e. include equality
    // with the final value), we need to increase the distance by 1.
    if (CmpHasEqual)
      Dist = Dist > 0 ? Dist + 1 : Dist - 1;

    // For the loop to iterate, CmpLess should imply Dist > 0.  Similarly,
    // CmpGreater should imply Dist < 0.  These conditions could actually
    // fail, for example, in unreachable code (which may still appear to be
    // reachable in the CFG).
    if ((CmpLess && Dist < 0) || (CmpGreater && Dist > 0))
      return nullptr;

    // "Normalized" distance, i.e. with the bump set to +-1.
    int64_t Dist1 = (IVBump > 0) ? (Dist + (IVBump - 1)) / IVBump
                                 : (-Dist + (-IVBump - 1)) / (-IVBump);
    assert(Dist1 > 0 && "Fishy thing.  Both operands have the same sign.");

    uint64_t Count = Dist1;

    if (Count > 0xFFFFFFFFULL)
      return nullptr;

    return new CountValue(CountValue::CV_Immediate, Count);
  }

  // A general case: Start and End are some values, but the actual
  // iteration count may not be available.  If it is not, insert
  // a computation of it into the preheader.

  // If the induction variable bump is not a power of 2, quit.
  // Othwerise we'd need a general integer division.
  if (!isPowerOf2_64(std::abs(IVBump)))
    return nullptr;

  // If the loop IV is going downwards, i.e. if the bump is negative,
  // then the iteration count (computed as End-Start) will need to be
  // negated.  To avoid the negation, just swap Start and End.
  bool Swapped = IVBump < 0;
  if (Swapped) {
    std::swap(Start, End);
    std::swap(startIsImm, endIsImm);
    std::swap(immStart, immEnd);
    IVBump = -IVBump;
    std::swap(CmpLess, CmpGreater);
  }
  // Now the IV conceptually counts up from Start towards End: the loop is
  // either a "!=" loop, or (CmpLess) it continues while the distance
  // End - Start is positive (non-negative when CmpHasEqual). Signedness is
  // preserved in Cmp.
  assert((Cmp == Comparison::NE || CmpLess) && "Unexpected comparison");

  // Is the ordered loop's distance known to be in range at the loop entry,
  // so that no runtime guard is needed?
  bool NeedGuard =
      CmpLess && !isDistanceCheckedOnEntry(Loop, Start, End, startIsImm,
                                           immStart, endIsImm, immEnd,
                                           Comparison::isUnsigned(Cmp),
                                           CmpHasEqual);

  // The guard adds IVBump with an ADDI.
  if (NeedGuard && !isInt<12>(IVBump))
    return nullptr;

  // Emit Dst = Op1 <Opc> Op2 (register, register) or Dst = Op1 <Opc> Imm.
  auto emitRR = [&](unsigned Opc, Register A, unsigned ASub, Register B,
                    unsigned BSub) -> Register {
    Register R = MRI->createVirtualRegister(IntRC);
    BuildMI(*PH, InsertPos, DL, TII->get(Opc), R)
        .addReg(A, 0, ASub)
        .addReg(B, 0, BSub);
    return R;
  };
  auto emitRI = [&](unsigned Opc, Register A, unsigned ASub,
                    int64_t Imm) -> Register {
    Register R = MRI->createVirtualRegister(IntRC);
    BuildMI(*PH, InsertPos, DL, TII->get(Opc), R)
        .addReg(A, 0, ASub)
        .addImm(Imm);
    return R;
  };
  // The value of a start/end operand in a register.
  auto getValueReg = [&](const MachineOperand *MO, int64_t Imm,
                         unsigned &Sub) -> Register {
    if (MO->isReg()) {
      Sub = MO->getSubReg();
      return MO->getReg();
    }
    Sub = 0;
    if (Imm == 0)
      return RISCV::X0;
    return emitRI(RISCV::ADDI, RISCV::X0, 0, Imm);
  };

  // Compute DistR = End - Start (modulo 2^32).
  Register DistR;
  unsigned DistSR = 0;
  if (startIsImm && immStart == 0) {
    // Avoid special case, where the start value is zero (an immediate or a
    // register holding zero, e.g. $x0).
    DistR = getValueReg(End, immEnd, DistSR);
  } else if (Start->isImm()) {
    // End is a register (both immediates were handled above).
    // If the loop has been unrolled, we should use the original loop count
    // instead of recalculating the value. This will avoid additional
    // 'Add' instruction.
    const MachineInstr *EndValInstr = MRI->getVRegDef(End->getReg());
    if (EndValInstr && EndValInstr->getOpcode() == RISCV::ADDI &&
        EndValInstr->getOperand(1).isReg() &&
        EndValInstr->getOperand(1).getSubReg() == 0 &&
        EndValInstr->getOperand(2).isImm() &&
        EndValInstr->getOperand(2).getImm() == immStart) {
      DistR = EndValInstr->getOperand(1).getReg();
    } else {
      DistR = emitRI(RISCV::ADDI, End->getReg(), End->getSubReg(), -immStart);
    }
  } else {
    unsigned ESub;
    Register ER = getValueReg(End, immEnd, ESub);
    DistR = emitRR(RISCV::SUB, ER, ESub, Start->getReg(), Start->getSubReg());
  }

  // For "!=" the count is Dist / IVBump. For the ordered comparisons it is
  //   Count = (End - Start + (IVBump-1)) / IVBump
  // or, when CmpHasEqual:
  //   Count = (End - Start + (IVBump-1)+1) / IVBump
  // (HexagonHardwareLoops::computeCount), computed here in the equivalent
  // form ((Dist - 1) >> Shift) + 1, resp. (Dist >> Shift) + 1, which only
  // overflows for a count of 2^32 (that no 32-bit loop counter can hold).
  unsigned Shift = Log2_64(IVBump);
  Register CountR = DistR;
  unsigned CountSR = DistSR;

  if (Cmp == Comparison::NE) {
    if (Shift != 0) {
      CountR = emitRI(RISCV::SRLI, DistR, DistSR, Shift);
      CountSR = 0;
    }
    return new CountValue(CountValue::CV_Register, CountR, CountSR);
  }

  if (!NeedGuard && Shift == 0 && !CmpHasEqual)
    // ((Dist - 1) >> 0) + 1 == Dist.
    return new CountValue(CountValue::CV_Register, CountR, CountSR);

  // X = Dist - 1 (strict comparison) or Dist; Q = X >> Shift.
  Register QR = DistR;
  unsigned QSR = DistSR;
  if (!CmpHasEqual) {
    QR = emitRI(RISCV::ADDI, DistR, DistSR, -1);
    QSR = 0;
  }
  if (Shift != 0) {
    QR = emitRI(RISCV::SRLI, QR, QSR, Shift);
    QSR = 0;
  }

  if (NeedGuard) {
    // The body runs once before the first comparison, which tests the bumped
    // induction value First against the final value. If that comparison
    // fails, the loop runs exactly once. Otherwise the distance is valid and
    // gives the count above; this also covers a first bump that wraps around
    // (e.g. an unsigned initial value of 0xffffffff counting up, or 0
    // counting down). In the Start/End terms used here (counting up):
    //   Valid = Start + IVBump < End     (<= when CmpHasEqual), or, if the
    //   IV really counts down and Start/End were swapped above,
    //   Valid = Start < End - IVBump     (<= when CmpHasEqual).
    // This is HexagonHardwareLoops' "DistCheck/MUX" guard, which tests the
    // sign of End - Start instead. RISC-V has no mux, so the comparison is
    // made with SLT/SLTU (swapped and inverted with XORI 1 for <=) and
    //   Q = Q & -Valid
    // makes the final count below Q + 1 = 1 when the distance is invalid.
    unsigned SltOpc = Comparison::isUnsigned(Cmp) ? RISCV::SLTU : RISCV::SLT;
    unsigned LSub, RSub;
    Register LR = getValueReg(Start, immStart, LSub);
    Register RR = getValueReg(End, immEnd, RSub);
    if (Swapped) {
      RR = emitRI(RISCV::ADDI, RR, RSub, -IVBump);
      RSub = 0;
    } else {
      LR = emitRI(RISCV::ADDI, LR, LSub, IVBump);
      LSub = 0;
    }
    // Valid = LR < RR, or !(RR < LR) when CmpHasEqual.
    Register ValidR;
    if (CmpHasEqual) {
      Register InvR = emitRR(SltOpc, RR, RSub, LR, LSub);
      ValidR = emitRI(RISCV::XORI, InvR, 0, 1);
    } else {
      ValidR = emitRR(SltOpc, LR, LSub, RR, RSub);
    }
    Register MaskR = emitRR(RISCV::SUB, RISCV::X0, 0, ValidR, 0);
    QR = emitRR(RISCV::AND, QR, QSR, MaskR, 0);
    QSR = 0;
  }

  CountR = emitRI(RISCV::ADDI, QR, QSR, 1);
  return new CountValue(CountValue::CV_Register, CountR, 0);
}

/// Return true if "A K B" is known to hold whenever the loop is entered, for
/// some comparison kind K accepted by \p Accept. This looks for a conditional
/// branch comparing A with B in a block D that dominates the preheader, one
/// of whose outgoing edges D->S dominates the preheader (S has D as its only
/// predecessor and dominates the preheader): every path into the loop takes
/// that edge, so the edge's condition holds on entry (A and B are SSA values
/// or constants, so they cannot change in between).
bool PULPHardwareLoops::isRelationTrueOnEntry(
    MachineLoop *L, const MachineOperand *A, bool AIsImm, int64_t AImm,
    const MachineOperand *B, bool BIsImm, int64_t BImm,
    function_ref<bool(Comparison::Kind)> Accept) const {
  MachineBasicBlock *PH = MLI->findLoopPreheader(L, SpecPreheader);
  if (!PH || !MDT->getNode(PH))
    return false;

  // Does the branch operand X hold the same value as the operand Y?
  auto sameValue = [&](const MachineOperand &X, const MachineOperand *Y,
                       bool YIsImm, int64_t YImm) -> bool {
    int64_t XImm;
    if (checkForImmediate(X, XImm))
      return YIsImm && static_cast<int32_t>(XImm) == static_cast<int32_t>(YImm);
    if (YIsImm || !X.isReg() || !Y->isReg())
      return false;
    return X.getReg() == Y->getReg() && X.getSubReg() == Y->getSubReg();
  };
  auto edgeDominatesPreheader = [&](MachineBasicBlock *S) {
    return S->pred_size() == 1 && MDT->dominates(S, PH);
  };

  unsigned Depth = 0;
  for (MachineDomTreeNode *N = MDT->getNode(PH); N && Depth < 32;
       N = N->getIDom(), ++Depth) {
    MachineBasicBlock *D = N->getBlock();
    MachineBasicBlock *TBB = nullptr, *FBB = nullptr;
    SmallVector<MachineOperand, 4> Cond;
    if (TII->analyzeBranch(*D, TBB, FBB, Cond, false) || Cond.size() != 3 ||
        !Cond[0].isImm() || !TBB || D->succ_size() != 2)
      continue;
    // The not-taken successor: FBB, or the fall-through block.
    MachineBasicBlock *NTBB = FBB;
    if (!NTBB)
      for (MachineBasicBlock *S : D->successors())
        if (S != TBB)
          NTBB = S;
    if (!NTBB || NTBB == TBB)
      continue;
    bool Taken;
    if (edgeDominatesPreheader(TBB))
      Taken = true;
    else if (edgeDominatesPreheader(NTBB))
      Taken = false;
    else
      continue;
    Comparison::Kind K =
        getComparisonKindFromCC(Cond[0].getImm(), nullptr, nullptr, 0);
    if (!K)
      continue;
    if (!Taken)
      K = Comparison::getNegatedComparison(K);
    // Now "Cond[1] K Cond[2]" holds on entry.
    if (sameValue(Cond[1], A, AIsImm, AImm) &&
        sameValue(Cond[2], B, BIsImm, BImm)) {
      if (Accept(K))
        return true;
    } else if (sameValue(Cond[1], B, BIsImm, BImm) &&
               sameValue(Cond[2], A, AIsImm, AImm)) {
      if (Accept(Comparison::getSwappedComparison(K)))
        return true;
    }
  }
  return false;
}

/// Return true if the loop is entered only when its distance is in range,
/// i.e. Start < End (Start <= End if HasEqual) with the given signedness:
/// either a dominating branch establishes it (the usual guard of a rotated
/// loop), or Start is End with some low bits cleared (Start = End & Mask, the
/// remainder loop after an unrolled one), which gives Start <= End, together
/// with a dominating "Start != End" branch when the comparison is strict.
bool PULPHardwareLoops::isDistanceCheckedOnEntry(
    MachineLoop *L, const MachineOperand *Start, const MachineOperand *End,
    bool StartIsImm, int64_t StartImm, bool EndIsImm, int64_t EndImm,
    bool IsUnsigned, bool HasEqual) const {
  // Start = ANDI End, Imm: AND never increases an unsigned value, and with
  // a negative (sign-extended) mask it keeps the sign bit and only clears
  // lower bits, so it does not increase a signed value either.
  bool StartNotAboveEnd = false;
  if (!StartIsImm && !EndIsImm && Start->isReg() && End->isReg() &&
      Start->getReg().isVirtual()) {
    const MachineInstr *Def = MRI->getVRegDef(Start->getReg());
    if (Def && Def->getOpcode() == RISCV::ANDI && Def->getOperand(1).isReg() &&
        Def->getOperand(1).getReg() == End->getReg() &&
        Def->getOperand(1).getSubReg() == End->getSubReg() &&
        Def->getOperand(2).isImm() &&
        (IsUnsigned || Def->getOperand(2).getImm() < 0))
      StartNotAboveEnd = true;
  }
  if (HasEqual && StartNotAboveEnd)
    return true;

  return isRelationTrueOnEntry(
      L, Start, StartIsImm, StartImm, End, EndIsImm, EndImm,
      [&](Comparison::Kind K) {
        if (K == Comparison::NE)
          return StartNotAboveEnd;
        // Start < End implies Start <= End, but not the other way round.
        return (K & Comparison::L) && Comparison::isUnsigned(K) == IsUnsigned &&
               (HasEqual || !(K & Comparison::EQ));
      });
}

/// Return true if the operation is invalid within hardware loop.
bool PULPHardwareLoops::isInvalidLoopOperation(const MachineInstr *MI) const {
  // Call is not allowed because the callee may use a hardware loop.
  // Furthermore, calls may be inlined during LTO, and we do not yet support
  // fixups for this after LTO.
  if (MI->getDesc().isCall())
    return true;

  // If this code for some reason (e.g., inline ASM) already contains a hw loop
  // we don't currently have this represented in our book keeping. It is a
  // corner case, so for now we just don't create HW loops if this happens.
  if (MI->getOpcode() == RISCV::LOOP0setup ||
      MI->getOpcode() == RISCV::LOOP1setup ||
      MI->getOpcode() == RISCV::LOOP0setupi ||
      MI->getOpcode() == RISCV::LOOP1setupi) {
    return KnownHardwareLoops.count(MI) == 0;
  }

  // FIXME: We should probably not allow Inline ASM at all, except for the
  //        HERO 64-bit loads.

  return false;
}

/// Return true if the loop contains an instruction that inhibits
/// the use of the hardware loop instruction.
bool PULPHardwareLoops::containsInvalidInstruction(MachineLoop *L) const {
  for (MachineBasicBlock *MBB : L->getBlocks()) {
    for (MachineInstr &MI : *MBB) {
      if (isInvalidLoopOperation(&MI)) {
        LLVM_DEBUG(dbgs() << "\nCannot convert to hwloop due to:"; MI.dump(););
        return true;
      }
    }
  }
  return false;
}

/// Returns true if the instruction is dead.  This was essentially
/// copied from DeadMachineInstructionElim::isDead, but with special cases
/// for inline asm, physical registers and instructions with side effects
/// removed.
bool PULPHardwareLoops::isDead(
    const MachineInstr *MI, SmallVectorImpl<MachineInstr *> &DeadPhis) const {
  // Examine each operand.
  for (unsigned i = 0, e = MI->getNumOperands(); i != e; ++i) {
    const MachineOperand &MO = MI->getOperand(i);
    if (!MO.isReg() || !MO.isDef())
      continue;

    llvm::Register Reg = MO.getReg();
    if (MRI->use_nodbg_empty(Reg))
      continue;

    using use_nodbg_iterator = MachineRegisterInfo::use_nodbg_iterator;

    // This instruction has users, but if the only user is the phi node for the
    // parent block, and the only use of that phi node is this instruction, then
    // this instruction is dead: both it (and the phi node) can be removed.
    use_nodbg_iterator I = MRI->use_nodbg_begin(Reg);
    use_nodbg_iterator End = MRI->use_nodbg_end();
    if (std::next(I) != End || !I->getParent()->isPHI())
      return false;

    MachineInstr *OnePhi = I->getParent();
    for (unsigned j = 0, f = OnePhi->getNumOperands(); j != f; ++j) {
      const MachineOperand &OPO = OnePhi->getOperand(j);
      if (!OPO.isReg() || !OPO.isDef())
        continue;

      llvm::Register OPReg = OPO.getReg();
      use_nodbg_iterator nextJ;
      for (use_nodbg_iterator J = MRI->use_nodbg_begin(OPReg); J != End;
           J = nextJ) {
        nextJ = std::next(J);
        MachineOperand &Use = *J;
        MachineInstr *UseMI = Use.getParent();

        // If the phi node has a user that is not MI, bail.
        if (MI != UseMI)
          return false;
      }
    }
    DeadPhis.push_back(OnePhi);
  }

  // If there are no defs with uses, the instruction is dead.
  return true;
}

void PULPHardwareLoops::removeIfDead(MachineInstr *MI) {
  // This procedure was essentially copied from DeadMachineInstructionElim.

  SmallVector<MachineInstr *, 1> DeadPhis;
  if (isDead(MI, DeadPhis)) {
    LLVM_DEBUG(dbgs() << "HW looping will remove: " << *MI);

    // It is possible that some DBG_VALUE instructions refer to this
    // instruction.  Examine each def operand for such references;
    // if found, mark the DBG_VALUE as undef (but don't delete it).
    for (unsigned i = 0, e = MI->getNumOperands(); i != e; ++i) {
      const MachineOperand &MO = MI->getOperand(i);
      if (!MO.isReg() || !MO.isDef())
        continue;
      llvm::Register Reg = MO.getReg();
      MachineRegisterInfo::use_iterator nextI;
      for (MachineRegisterInfo::use_iterator I = MRI->use_begin(Reg),
                                             E = MRI->use_end();
           I != E; I = nextI) {
        nextI = std::next(I); // I is invalidated by the setReg
        MachineOperand &Use = *I;
        MachineInstr *UseMI = I->getParent();
        if (UseMI == MI)
          continue;
        if (Use.isDebug())
          UseMI->getOperand(0).setReg(0U);
      }
    }

    MI->eraseFromParent();
    for (unsigned i = 0; i < DeadPhis.size(); ++i) {
      DeadPhis[i]->eraseFromParent();
    }
  }
}

/// Check if the loop is a candidate for converting to a hardware
/// loop.  If so, then perform the transformation.
///
/// This function works on innermost loops first.  A loop can be converted
/// if it is a counting loop; either a register value or an immediate.
///
/// The code makes several assumptions about the representation of the loop
/// in llvm.
bool PULPHardwareLoops::convertToHardwareLoop(MachineLoop *L, bool &RecL0used,
                                              bool &RecL1used) {
  // This is just for sanity.
  assert(L->getHeader() && "Loop without a header?");

  bool Changed = false;
  bool L0Used = false;
  bool L1Used = false;

  // Process nested loops first.
  for (MachineLoop::iterator I = L->begin(), E = L->end(); I != E; ++I) {
    Changed |= convertToHardwareLoop(*I, RecL0used, RecL1used);
    L0Used |= RecL0used;
    L1Used |= RecL1used;
  }

  // If a nested loop has been converted, then we can't convert this loop.
  if (Changed && L0Used && L1Used) {
    return Changed;
  }

  // The instructions that are available to use at this level. If L0 is already
  // used we have to use L1.
  unsigned LOOP_i = RISCV::LOOP0setupi;
  unsigned LOOP_r = RISCV::LOOP0setup;
  if (L0Used) {
    LOOP_i = RISCV::LOOP1setupi;
    LOOP_r = RISCV::LOOP1setup;
  }

  // Does the loop contain any invalid instructions?
  if (containsInvalidInstruction(L)) {
    LLVM_DEBUG(
        dbgs()
        << "Cannot convert to hwloop: illegal instructions in loop body\n");
    return Changed;
  }

  MachineBasicBlock *LastMBB = L->findLoopControlBlock();
  // Don't generate hw loop if the loop has more than one exit.
  if (!LastMBB) {
    LLVM_DEBUG(
        dbgs() << "Cannot convert to hwloop: multiple loop exit blocks\n");
    return Changed;
  }

  MachineBasicBlock::iterator LastI = LastMBB->getFirstTerminator();
  if (LastI == LastMBB->end()) {
    LLVM_DEBUG(
        dbgs()
        << "Cannot convert to hwloop: loop exit block has no terminator\n");
    return Changed;
  }

  // Ensure the loop has a preheader: the loop instruction will be
  // placed there.
  MachineBasicBlock *Preheader = MLI->findLoopPreheader(L, SpecPreheader);
  if (!Preheader) {
    LLVM_DEBUG(dbgs() << "Cannot convert to hwloop: loop has no preheader\n");
    // FIXME: The HEXAGON pass upon which this is based tried to create a new
    //        preheader for the loop here. Instead we just return false, as I am
    //        not sure how common this is on PULP. Perhaps it is better to
    //        re-implement it based on sample code that GCC manages to make into
    //        hardware loops, but we fail.

    return Changed;
  }

  MachineBasicBlock::iterator InsertPos = Preheader->getFirstTerminator();

  SmallVector<MachineInstr *, 2> OldInsts;
  // Are we able to determine the trip count for the loop?
  CountValue *TripCount = getLoopTripCount(L, OldInsts);
  if (!TripCount) {
    LLVM_DEBUG(
        dbgs() << "Cannot convert to hwloop: cannot determine trip count\n");
    return Changed;
  }

  // Is the trip count available in the preheader?
  if (TripCount->isReg()) {
    // There will be a use of the register inserted into the preheader,
    // so make sure that the register is actually defined at that point.
    MachineInstr *TCDef = MRI->getVRegDef(TripCount->getReg());
    MachineBasicBlock *BBDef = TCDef->getParent();
    if (!MDT->dominates(BBDef, Preheader)) {
      LLVM_DEBUG(dbgs() << "Cannot convert to hwloop: induction register not "
                           "available in preheader\n");
      return Changed;
    }
  }

  // Determine the loop start.
  MachineBasicBlock *TopBlock = L->getTopBlock();
  MachineBasicBlock *ExitingBlock = L->findLoopControlBlock();
  MachineBasicBlock *ExitBlock = L->getExitBlock();
  MachineBasicBlock *LoopStart = nullptr;
  if (ExitingBlock != L->getLoopLatch()) {
    MachineBasicBlock *TB = nullptr, *FB = nullptr;
    SmallVector<MachineOperand, 2> Cond;
    if (TII->analyzeBranch(*ExitingBlock, TB, FB, Cond, false)) {
      LLVM_DEBUG(dbgs() << "Cannot convert to hwloop: cannot analyze loop\n");
      return Changed;
    }
    if (L->contains(TB))
      LoopStart = TB;
    else if (L->contains(FB))
      LoopStart = FB;
    else {
      return Changed;
    }
  } else {
    LoopStart = TopBlock;
  }
  assert(LoopStart != nullptr && "Didn't find loop start!");

  // We need a single exit block to make sure that this loop can be simplified
  // to a fixed amount of loop iterations.
  if (!ExitBlock) {
    LLVM_DEBUG(
        dbgs() << "Cannot convert to hwloop: multiple loop exit blocks\n");
    return Changed;
  }

  // Ensure the loop length can reasonably fit into 12 bits.  Assume
  // non-compressed instructions as an upper-bound for the length. The length
  // gives the offset which must fit in 12 bits.
  unsigned loopSize = 0;
  const unsigned instructionSize = 4;
  for (const MachineBasicBlock *LB : L->getBlocks()) {
    loopSize += instructionSize * LB->size();
    if (loopSize > 0xFFF) {
      LLVM_DEBUG(
          dbgs()
          << "Cannot convert to hwloop: loop body doesn't fit into 12 bits\n");
      return Changed;
    }
  }

  // Convert the loop to a hardware loop.
  LLVM_DEBUG(dbgs() << "Change to hardware loop at "; L->dump());
  DebugLoc DL;
  if (InsertPos != Preheader->end())
    DL = InsertPos->getDebugLoc();

  if (TripCount->isReg()) {
    // Create a copy of the loop count register.
    llvm::Register CountReg = MRI->createVirtualRegister(&RISCV::GPRRegClass);
    BuildMI(*Preheader, InsertPos, DL, TII->get(TargetOpcode::COPY), CountReg)
        .addReg(TripCount->getReg(), 0, TripCount->getSubReg());
    // Add the Loop instruction to the beginning of the loop.
    auto hwloop = BuildMI(*Preheader, InsertPos, DL, TII->get(LOOP_r))
                      .addMBB(ExitingBlock)
                      .addReg(CountReg);
    KnownHardwareLoops.insert(hwloop.getInstr());
  } else {
    assert(TripCount->isImm() && "Expecting immediate value for trip count");
    // Add the Loop immediate instruction to the beginning of the loop,
    // if the immediate fits in the instructions.  Otherwise, we need to
    // create a new virtual register.
    int64_t CountImm = TripCount->getImm();
    if (static_cast<uint64_t>(CountImm) >
        APInt::getMaxValue(12).getLimitedValue()) {
      llvm::Register CountReg = MRI->createVirtualRegister(&RISCV::GPRRegClass);
      BuildMI(*Preheader, InsertPos, DL, TII->get(RISCV::ADDI), CountReg)
          .addReg(RISCV::X0)
          .addImm(CountImm);
      auto hwloop = BuildMI(*Preheader, InsertPos, DL, TII->get(LOOP_r))
                        .addMBB(ExitingBlock)
                        .addReg(CountReg);
      KnownHardwareLoops.insert(hwloop.getInstr());
    } else {
      auto hwloop = BuildMI(*Preheader, InsertPos, DL, TII->get(LOOP_i))
                        .addMBB(ExitingBlock)
                        .addImm(CountImm);
      KnownHardwareLoops.insert(hwloop.getInstr());
    }
  }
  delete TripCount;

  // Make sure the loop start always has a reference in the CFG.  We need
  // to create a BlockAddress operand to get this mechanism to work both the
  // MachineBasicBlock and BasicBlock objects need the flag set.
  ExitingBlock->setMachineBlockAddressTaken();
  ExitingBlock->setLabelMustBeEmitted();
  // This line is needed to set the hasAddressTaken flag on the BasicBlock
  // object.
  BlockAddress::get(const_cast<BasicBlock *>(ExitingBlock->getBasicBlock()));

  // The induction operation and the comparison may now be
  // unneeded. If these are unneeded, then remove them.
  for (unsigned i = 0; i < OldInsts.size(); ++i) {
    removeIfDead(OldInsts[i]);
  }

  ++NumHWLoops;
  ++NumHWLoopsInternal;

  // Set RecL1used and RecL0used only after hardware loop has been
  // successfully generated. Doing it earlier can cause wrong loop instruction
  // to be used.
  if (L0Used) // Loop0 was already used. So, the correct loop must be loop1.
    RecL1used = true;
  else
    RecL0used = true;

  return true;
}

/// This function is required to break recursion. Visiting phis in a loop may
/// result in recursion during compilation. We break the recursion by making
/// sure that we visit a MachineOperand and its definition in a
/// MachineInstruction only once. If we attempt to visit more than once, then
/// there is recursion, and will return false.
bool PULPHardwareLoops::isLoopFeeder(MachineLoop *L, MachineBasicBlock *A,
                                     MachineInstr *MI, const MachineOperand *MO,
                                     LoopFeederMap &LoopFeederPhi) const {
  if (LoopFeederPhi.find(MO->getReg()) == LoopFeederPhi.end()) {
    LLVM_DEBUG(dbgs() << "\nhw_loop head, "
                      << printMBBReference(**L->block_begin()));
    // Ignore all BBs that form Loop.
    for (MachineBasicBlock *MBB : L->getBlocks()) {
      if (A == MBB)
        return false;
    }
    MachineInstr *Def = MRI->getVRegDef(MO->getReg());
    LoopFeederPhi.insert(std::make_pair(MO->getReg(), Def));
    return true;
  }
  // Already visited node.
  return false;
}

/// Return true if a Phi may generate a value that can underflow.
/// This function calls loopCountMayWrapOrUnderFlow for each Phi operand.
bool PULPHardwareLoops::phiMayWrapOrUnderflow(
    MachineInstr *Phi, const MachineOperand *EndVal, MachineBasicBlock *MBB,
    MachineLoop *L, LoopFeederMap &LoopFeederPhi) const {
  assert(Phi->isPHI() && "Expecting a Phi.");
  // Walk through each Phi, and its used operands. Make sure that
  // if there is recursion in Phi, we won't generate hardware loops.
  for (int i = 1, n = Phi->getNumOperands(); i < n; i += 2)
    if (isLoopFeeder(L, MBB, Phi, &(Phi->getOperand(i)), LoopFeederPhi))
      if (loopCountMayWrapOrUnderFlow(&(Phi->getOperand(i)), EndVal,
                                      Phi->getParent(), L, LoopFeederPhi))
        return true;
  return false;
}

/// Return true if the induction variable can underflow in the first iteration.
/// An example, is an initial unsigned value that is 0 and is decrement in the
/// first itertion of a do-while loop.  In this case, we cannot generate a
/// hardware loop because the endloop instruction does not decrement the loop
/// counter if it is <= 1. We only need to perform this analysis if the
/// initial value is a register.
///
/// This function assumes the initial value may underfow unless proven
/// otherwise. If the type is signed, then we don't care because signed
/// underflow is undefined. We attempt to prove the initial value is not
/// zero by perfoming a crude analysis of the loop counter. This function
/// checks if the initial value is used in any comparison prior to the loop
/// and, if so, assumes the comparison is a range check. This is inexact,
/// but will catch the simple cases.
bool PULPHardwareLoops::loopCountMayWrapOrUnderFlow(
    const MachineOperand *InitVal, const MachineOperand *EndVal,
    MachineBasicBlock *MBB, MachineLoop *L,
    LoopFeederMap &LoopFeederPhi) const {
  // Only check register values since they are unknown.
  if (!InitVal->isReg())
    return false;

  // On RISC-V the final value is rarely an immediate operand: a comparison
  // with 0 uses $x0 and other constants are loaded into a register. Accept
  // any known constant, as checkForImmediate does.
  int64_t EndImm;
  if (!checkForImmediate(*EndVal, EndImm))
    return false;

  // A register value that is assigned an immediate is a known value, and it
  // won't underflow in the first iteration.
  int64_t Imm;
  if (checkForImmediate(*InitVal, Imm))
    return static_cast<int32_t>(EndImm) == static_cast<int32_t>(Imm);

  Register Reg = InitVal->getReg();

  // We don't know the value of a physical register.
  if (!Reg.isVirtual())
    return true;

  MachineInstr *Def = MRI->getVRegDef(Reg);
  if (!Def)
    return true;

  // If the initial value is a Phi or copy and the operands may not underflow,
  // then the definition cannot be underflow either.
  if (Def->isPHI() &&
      !phiMayWrapOrUnderflow(Def, EndVal, Def->getParent(), L, LoopFeederPhi))
    return false;
  if (Def->isCopy() &&
      !loopCountMayWrapOrUnderFlow(&(Def->getOperand(1)), EndVal,
                                   Def->getParent(), L, LoopFeederPhi))
    return false;

  // Iterate over the uses of the initial value. If the initial value is used
  // in a compare, then we assume this is a range check that ensures the loop
  // doesn't underflow. This is not an exact test and should be improved.
  // RISC-V has no separate compare instruction (analyzeCompare is not
  // implemented): the compare is the conditional branch itself, comparing
  // its operands 0 and 1.
  for (MachineRegisterInfo::use_instr_nodbg_iterator
           I = MRI->use_instr_nodbg_begin(Reg),
           E = MRI->use_instr_nodbg_end();
       I != E; ++I) {
    MachineInstr *MI = &*I;
    if (!MI->isConditionalBranch())
      continue;

    MachineBasicBlock *TBB = nullptr, *FBB = nullptr;
    SmallVector<MachineOperand, 4> Cond;
    if (TII->analyzeBranch(*MI->getParent(), TBB, FBB, Cond, false))
      continue;

    Comparison::Kind Cmp =
        getComparisonKind(MI->getOpcode(), nullptr, nullptr, 0);
    if (Cmp == 0)
      continue;
    // As in HexagonHardwareLoops, without its predOpcodeHasNot term: RISC-V
    // branches have no negated predicates.
    if (TBB != MBB)
      Cmp = Comparison::getNegatedComparison(Cmp);
    const MachineOperand &CmpOp2 = MI->getOperand(1);
    if (CmpOp2.isReg() && CmpOp2.getReg() == Reg)
      Cmp = Comparison::getSwappedComparison(Cmp);

    // Signed underflow is undefined.
    if (Comparison::isSigned(Cmp))
      return false;

    // Check if there is a comparison of the initial value. If the initial value
    // is greater than or not equal to another value, then assume this is a
    // range check.
    if ((Cmp & Comparison::G) || Cmp == Comparison::NE)
      return false;
  }

  // OK - this is a hack that needs to be improved. We really need to analyze
  // the instructions performed on the initial value. This works on the simplest
  // cases only.
  if (!Def->isCopy() && !Def->isPHI())
    return false;

  return true;
}

bool PULPHardwareLoops::checkForImmediate(const MachineOperand &MO,
                                          int64_t &Val) const {

  if (MO.isImm()) {
    Val = MO.getImm();
    return true;
  }
  if (!MO.isReg()) {
    return false;
  }

  // MO is a register. Check whether it is defined as an immediate value,
  // and if so, get the value of it in TV. That value will then need to be
  // processed to handle potential subregisters in MO.
  int64_t TV;

  Register R = MO.getReg();
  if (!R.isVirtual()) {
    if (R == RISCV::X0) {
      // This is the zero register!
      Val = 0;
      return true;
    }
    return false;
  }
  MachineInstr *DI = MRI->getVRegDef(R);
  unsigned DOpc = DI->getOpcode();
  switch (DOpc) {
  case TargetOpcode::COPY:
    // Call recursively to avoid an extra check whether operand(1) is
    // indeed an immediate (it could be a global address, for example),
    // plus we can handle COPY at the same time.
    if (!checkForImmediate(DI->getOperand(1), TV)) {
      return false;
    } else {
      Val = TV;
    }
    break;
  case RISCV::ADDI:
    if (DI->getOperand(1).isReg() && DI->getOperand(1).getReg() == RISCV::X0) {
      // Load an immediate into a register
      if (!checkForImmediate(DI->getOperand(2), TV)) {
        return false;
      }
      Val = TV;
    } else if (DI->getOperand(2).isImm() && DI->getOperand(2).getImm() == 0) {
      // Move a value from Op1 to Op0.
      if (!checkForImmediate(DI->getOperand(1), TV)) {
        return false;
      }
      Val = TV;
    } else {
      // This ADDI is not used to LOAD IMM or to MOVE a value.
      return false;
    }
    break;
  default:
    return false;
  }

  return true;
}
