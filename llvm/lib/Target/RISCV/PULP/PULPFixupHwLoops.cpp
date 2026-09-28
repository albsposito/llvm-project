//===---- PULPFixupHwLoops.cpp - Fixup HW loops too far from LOOPn. ----===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// FIXME: Add description
//===----------------------------------------------------------------------===//

#include "../RISCVTargetMachine.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineLoopInfo.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/CodeGen/LivePhysRegs.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Pass.h"

#include <queue>
#include <set>

using namespace llvm;

#define DEBUG_TYPE "hwloopsfixup"

// The setup instructions encode the address of the last instruction of the
// loop as a forward offset from their own address, in halfwords (GVSoC:
// end = pc + (uimm << 1), pulp_v2.hpp lp_setup_exec/lp_setupi_exec; the loop
// jumps back after executing the instruction at that address). The field
// widths (RISCVInstrInfoXpulp.td, checked by RISCVAsmBackend's
// fixup_pulpv2_loop_setupi / fixup_pulpv2_loop_setup) limit that offset to:
//   lp.setupi: uimmS, Inst{19-15}, 5 bits  -> at most 62 bytes;
//   lp.setup, lp.endi: uimmL, Inst{31-20}, 12 bits -> at most 8190 bytes.
static constexpr int64_t MaxEndOffsetSetupi = 62;
static constexpr int64_t MaxEndOffsetSetup = 8190;
// Size of lp.setup/lp.setupi.
static constexpr int64_t SetupSize = 4;

// The two limits below are in bytes from the first instruction of the loop
// (after the setup) to the start of its last instruction, i.e. the end offset
// minus the size of the setup instruction. By default they are the largest
// values the encodings allow; a smaller value restricts further (0 makes every
// lp.setupi use the long form), a larger one is capped at the encoding limit.
static cl::opt<signed> MaxLoopRangeImm(
    "pulp-loop-range-immediate", cl::Hidden,
    cl::init(MaxEndOffsetSetupi - SetupSize),
    cl::desc("Restrict range of lp.setupi to N bytes (from the loop start to "
             "its last instruction)."));

static cl::opt<signed> MaxLoopRangeReg(
    "pulp-loop-range-register", cl::Hidden,
    cl::init(MaxEndOffsetSetup - SetupSize),
    cl::desc("Restrict range of lp.setup to N bytes (from the loop start to "
             "its last instruction)."));

namespace llvm {
  FunctionPass *createPULPFixupHwLoops();
  void initializePULPFixupHwLoopsPass(PassRegistry&);
}

namespace {

// TODO: This function is not needed for the latest LLVM versions, as MBB has
//       had the splitAt() method added. This version is adapted from that
//       method, from https://github.com/llvm/llvm-project/blob/
//       d7c219a506ec9aabe7c5d36c0da55656af487b73/llvm/lib/CodeGen/
//       MachineBasicBlock.cpp
//       CAVEAT: The above function will not split, as the loop instruction is
//               a terminator, in which case the above linked version would
//               chicken out.
MachineBasicBlock *splitMBBAt(MachineBasicBlock *OldMBB, MachineInstr &MI) {
  MachineBasicBlock::iterator SplitPoint(&MI);

  MachineFunction *MF = OldMBB->getParent();

  MachineBasicBlock *SplitBB =
      MF->CreateMachineBasicBlock(OldMBB->getBasicBlock());

  MF->insert(++MachineFunction::iterator(OldMBB), SplitBB);
  SplitBB->splice(SplitBB->begin(), OldMBB, SplitPoint, OldMBB->end());

  SplitBB->transferSuccessorsAndUpdatePHIs(OldMBB);
  OldMBB->addSuccessor(SplitBB);

  // The new block's live-ins are the registers live before MI (which moved
  // into it), e.g. the loop count register read by lp.setup. Compute them
  // from the successors' live-ins and the block's instructions, as upstream
  // block-splitting code does (computeAndAddLiveIns). (The earlier version
  // stepped back to just after MI, so MI's own operands were missing, and
  // added the function's pristine callee-saved registers.)
  LivePhysRegs LiveRegs;
  computeAndAddLiveIns(LiveRegs, *SplitBB);

  return SplitBB;
}


  struct PULPFixupHwLoops : public MachineFunctionPass {
  public:
    static char ID;

    PULPFixupHwLoops() : MachineFunctionPass(ID) {
      initializePULPFixupHwLoopsPass(*PassRegistry::getPassRegistry());
    }

    bool runOnMachineFunction(MachineFunction &MF) override;

    MachineFunctionProperties getRequiredProperties() const override {
      return MachineFunctionProperties().set(
          MachineFunctionProperties::Property::NoVRegs);
    }

    StringRef getPassName() const override {
      return "PULP Hardware Loop Fixup";
    }

    void getAnalysisUsage(AnalysisUsage &AU) const override {
      AU.setPreservesCFG();
      AU.addRequired<MachineLoopInfoWrapperPass>();
      MachineFunctionPass::getAnalysisUsage(AU);
    }

  private:
    bool removeUncountableLoops(MachineFunction &MF);
    bool removeTooLongLoops(MachineFunction &MF);
    bool fixupLoopLayout(MachineFunction &MF);
    bool fixupLoopPreheader(MachineFunction &MF);
    bool fixupLoopLatch(MachineFunction &MF);
    bool fixupLoopInstrs(MachineFunction &MF);
    bool fixupOneLoopLength(MachineFunction &MF);

  };

  char PULPFixupHwLoops::ID = 0;
}

INITIALIZE_PASS(PULPFixupHwLoops, "hwloopsfixup",
                "PULP Hardware Loops Fixup", false, false)

FunctionPass *llvm::createPULPFixupHwLoops() {
  return new PULPFixupHwLoops();
}

/// Returns true if the instruction is a hardware loop instruction.
static bool isHardwareLoop(const MachineInstr &MI) {
  return MI.getOpcode() == RISCV::LOOP0setup ||
         MI.getOpcode() == RISCV::LOOP1setup ||
         MI.getOpcode() == RISCV::LOOP0setupi ||
         MI.getOpcode() == RISCV::LOOP1setupi;
}

static bool isHardwareLoopZero(const MachineInstr &MI) {
  return MI.getOpcode() == RISCV::LOOP0setup ||
         MI.getOpcode() == RISCV::LOOP0setupi;
}

static bool isHardwareLoopOne(const MachineInstr &MI) {
  return MI.getOpcode() == RISCV::LOOP1setup ||
         MI.getOpcode() == RISCV::LOOP1setupi;
}

static bool isHardwareLoopReg(const MachineInstr &MI) {
  return MI.getOpcode() == RISCV::LOOP0setup ||
         MI.getOpcode() == RISCV::LOOP1setup;
}

static bool isHardwareLoopImm(const MachineInstr &MI) {
  return MI.getOpcode() == RISCV::LOOP0setupi ||
         MI.getOpcode() == RISCV::LOOP1setupi;
}

bool PULPFixupHwLoops::runOnMachineFunction(MachineFunction &MF) {


  // FIXME: Cannot add xpulpv2 to march. Problem in Koen's implementation?
  // We can only use hardware loops if we have the PULPv2 extension enabled.
  //if (!MF.getSubtarget<RISCVSubtarget>().hasPULPExtV2()) {
  //  return false;
  //}

  if (skipFunction(MF.getFunction())) {
    return false;
  }
  bool removedLoops = removeUncountableLoops(MF);
  bool fixedLayout = fixupLoopLayout(MF);
  bool fixedPreHd = fixupLoopPreheader(MF);
  removedLoops |= removeTooLongLoops(MF);
  bool fixedLatch = fixupLoopLatch(MF);
  bool fixedInstr = fixupLoopInstrs(MF);

  // TODO Move to own function
  for (MachineBasicBlock &MBB : MF) {
    unsigned instrs = 0;
    for (MachineInstr &MI : MBB) {
      instrs++;
      // If this is a loop instruction that has not been moved to a dedicated
      // block (for alignment of that block), then split and align it.
      if (isHardwareLoop(MI) && instrs > 1) {
        MachineBasicBlock *New = splitMBBAt(&MBB, MI);
        if (New == &MBB) {
          // Nothing changed
          continue;
        }
        New->setAlignment(Align(4));
        break;
      }
    }
  }

  return removedLoops || fixedLayout || fixedPreHd || fixedLatch || fixedInstr;
}

// Get the size of an instruction. This function currently only works if
// instruction compression (standard extension C is disabled).
size_t getMISize(const MachineInstr &MI) {
  // Handle fast-path if we are not going to compress instructions.
  const MachineFunction * MF = MI.getMF();
  const RISCVInstrInfo *RII =
      static_cast<const RISCVInstrInfo *>(MF->getSubtarget().getInstrInfo());
  return RII->getInstSizeInBytes(MI);
}

// Returns the last block of the run of loop blocks that starts at the loop
// header and is contiguous in the layout. This is what
// MachineLoop::getBottomBlock() computes, except that it stops at the end of
// the function instead of dereferencing the end iterator, which asserts
// (!NodePtr->isKnownSentinel()) when the loop is the last code in the function.
static MachineBasicBlock *getLayoutBottom(MachineLoop *L) {
  MachineBasicBlock *Bottom = L->getHeader();
  for (MachineBasicBlock *Next = Bottom->getNextNode();
       Next && L->contains(Next); Next = Next->getNextNode())
    Bottom = Next;
  return Bottom;
}

// From used to fall through into To (its layout successor) and no longer
// does after a block move: make the edge an explicit branch, so that the
// control flow does not change. Same approach as
// ARMBlockPlacement::moveBasicBlock.
static void keepFallthrough(MachineBasicBlock *From, MachineBasicBlock *To,
                            const TargetInstrInfo *TII) {
  if (!From || !To || !From->isSuccessor(To) || From->isLayoutSuccessor(To))
    return;
  MachineBasicBlock::iterator Last = From->getLastNonDebugInstr();
  DebugLoc DL;
  if (Last != From->end()) {
    if (Last->isBarrier())
      return; // Unconditional branch, return, ...: no fallthrough.
    DL = Last->getDebugLoc();
  }
  TII->insertBranch(*From, To, nullptr, {}, DL);
}

// Returns the single successor of Latch outside L (where the hardware loop
// continues when its count is exhausted), or nullptr if there is none or more
// than one.
static MachineBasicBlock *getLatchExit(MachineLoop *L,
                                       MachineBasicBlock *Latch) {
  MachineBasicBlock *Exit = nullptr;
  for (MachineBasicBlock *Succ : Latch->successors()) {
    if (L->contains(Succ))
      continue;
    if (Exit && Exit != Succ)
      return nullptr;
    Exit = Succ;
  }
  return Exit;
}

// The hardware counts iterations at one place only: the end of the loop
// range, i.e. the latch named by the setup instruction. Block placement runs
// after PULPHardwareLoops and may tail-duplicate the latch into another loop
// block, which then also jumps back to the header (and tests the exit
// condition). Iterations that take that second back edge are not counted, so
// the counter and the software condition disagree: the loop runs too often,
// too rarely or forever. A latch that can leave the loop to two different
// blocks cannot be expressed either (the hardware has one fall-out point).
// Such loops cannot be hardware loops; the software loop is still complete
// at this point (its compare-and-branch instructions are only removed by
// fixupLoopLatch below), so keep it as a normal loop by deleting the setup
// instruction. The count register computed for it becomes dead code.
bool PULPFixupHwLoops::removeUncountableLoops(MachineFunction &MF) {
  MachineLoopInfo *MLI = &getAnalysis<MachineLoopInfoWrapperPass>().getLI();
  SmallVector<MachineInstr *, 8> ToRemove;
  for (MachineBasicBlock &MBB : MF)
    for (MachineInstr &MI : MBB) {
      if (!isHardwareLoop(MI))
        continue;
      MachineBasicBlock *LastMBB = MI.getOperand(0).getMBB();
      MachineLoop *L = MLI->getLoopFor(LastMBB);
      assert(L && L->contains(LastMBB) && "Loop does not contain LastMBB");
      MachineBasicBlock *Latch = L->getLoopLatch(); // null: several back edges
      if (!Latch || (Latch == LastMBB && !getLatchExit(L, LastMBB))) {
        LLVM_DEBUG(dbgs() << "PULP hwloop fixup: " << printMBBReference(*LastMBB)
                          << ": loop has " << (Latch ? "no single latch exit"
                                                     : "several back edges")
                          << ", keeping it a software loop\n");
        ToRemove.push_back(&MI);
      }
    }
  for (MachineInstr *MI : ToRemove)
    MI->eraseFromParent();
  return !ToRemove.empty();
}

// A loop whose end is further from its setup than any setup form can encode
// (12-bit halfword offset of lp.setup, and of lp.endi in the long form that
// replaces an lp.setupi) cannot be a hardware loop. Keep it a software loop
// by deleting the setup instruction, as removeUncountableLoops does; this
// must happen before fixupLoopLatch removes the loop's compare-and-branch.
// The final loop is not known yet, so use an upper bound of its end offset
// (the distance from the setup to the start of the loop's last instruction):
// all instructions from the setup up to the terminators of the loop's last
// block (the last instruction lies before them; it can be a NOP that
// fixupLoopInstrs adds there), including the counter update fixupLoopLatch
// may remove, the most alignment padding before aligned blocks, and for
// every loop nested inside the most it can grow (long form +8 or padding
// NOPs +4, a NOP at its end +4, alignment of its setup). PULPHardwareLoops
// only forms loops of at most 4095 bytes (counted as 4 bytes per instruction
// before register allocation), so this only triggers for loops that grew a
// lot afterwards, e.g. through inline asm with many instructions.
bool PULPFixupHwLoops::removeTooLongLoops(MachineFunction &MF) {
  MachineLoopInfo *MLI = &getAnalysis<MachineLoopInfoWrapperPass>().getLI();
  const int64_t G =
      MF.getSubtarget<RISCVSubtarget>().hasStdExtCOrZca() ? 2 : 4;
  SmallVector<MachineInstr *, 8> ToRemove;
  for (MachineBasicBlock &MBB : MF)
    for (MachineInstr &MI : MBB) {
      if (!isHardwareLoop(MI))
        continue;
      MachineLoop *L = MLI->getLoopFor(MI.getOperand(0).getMBB());
      assert(L && "Hardware loop end is not in a loop");
      MachineBasicBlock *Bottom = getLayoutBottom(L);
      int64_t Bound = 0;
      for (auto I = MI.getIterator(), IE = MBB.instr_end(); I != IE; ++I)
        Bound += getMISize(*I);
      MachineBasicBlock *B = MBB.getNextNode();
      for (; B; B = B->getNextNode()) {
        if (int64_t(B->getAlignment().value()) > G)
          Bound += B->getAlignment().value() - G;
        MachineBasicBlock::instr_iterator E =
            B == Bottom ? B->getFirstInstrTerminator() : B->instr_end();
        for (const MachineInstr &I : make_range(B->instr_begin(), E)) {
          Bound += getMISize(I);
          if (isHardwareLoop(I))
            Bound += (4 - G) + 8 + 4;
        }
        if (B == Bottom)
          break;
      }
      if (!B)
        continue; // The loop is not after its setup; not handled here.
      int64_t Limit =
          isHardwareLoopImm(MI)
              ? MaxEndOffsetSetup - 4 // lp.endi is 4 bytes after lp.starti.
              : std::min<int64_t>(MaxLoopRangeReg + SetupSize,
                                  MaxEndOffsetSetup);
      if (Bound > Limit) {
        LLVM_DEBUG(dbgs() << "PULP hwloop fixup: " << printMBBReference(MBB)
                          << ": loop may be " << Bound
                          << " bytes long, more than a hardware loop can "
                             "encode; keeping it a software loop\n");
        ToRemove.push_back(&MI);
      }
    }
  for (MachineInstr *MI : ToRemove)
    MI->eraseFromParent();
  return !ToRemove.empty();
}

// A PULP hardware loop repeats the address range from the instruction after
// lp.setup (the loop header) to the end of the block named by the setup
// instruction (the latch, chosen by PULPHardwareLoops): the jump back to the
// header happens only when the end address is reached. Machine block
// placement runs after PULPHardwareLoops and may place the latch above the
// header (loop rotation, MachineBlockPlacement::findBestLoopTop), so that the
// back edge is a fallthrough. Such a layout cannot be expressed as a hardware
// loop: the latch would lie outside the repeated range. Move the latch (with
// the loop blocks laid out right before it) after the last loop block that
// follows the header, which restores the header-first layout the hardware
// needs. The CFG does not change; broken fallthroughs become branches.
bool PULPFixupHwLoops::fixupLoopLayout(MachineFunction &MF) {
  MachineLoopInfo *MLI = &getAnalysis<MachineLoopInfoWrapperPass>().getLI();
  const TargetInstrInfo *TII = MF.getSubtarget().getInstrInfo();

  SmallVector<MachineInstr *, 8> Setups;
  for (MachineBasicBlock &MBB : MF)
    for (MachineInstr &MI : MBB)
      if (isHardwareLoop(MI))
        Setups.push_back(&MI);

  bool Changed = false;
  for (MachineInstr *MI : Setups) {
    MachineBasicBlock *LastMBB = MI->getOperand(0).getMBB();
    MachineLoop *L = MLI->getLoopFor(LastMBB);
    assert(L && L->contains(LastMBB) && "Loop does not contain LastMBB");
    MachineBasicBlock *Header = L->getHeader();
    MachineBasicBlock *Bottom = getLayoutBottom(L);

    // Is LastMBB in the layout run Header..Bottom?
    bool InRun = false;
    for (MachineBasicBlock *B = Header;; B = B->getNextNode()) {
      if (B == LastMBB) {
        InRun = true;
        break;
      }
      if (B == Bottom)
        break;
    }

    MachineBasicBlock *Top = LastMBB;
    if (InRun) {
      // In the run and last: the layout is fine. In the run but followed by
      // other loop blocks (placed after the latch, reached by branches): if
      // LastMBB is the loop's only latch, move it alone to the end of the run,
      // so that the back edge is at the end of the range. (If LastMBB is not
      // the latch, e.g. it was split, fixupLoopLatch retargets the end.)
      if (LastMBB == Bottom || LastMBB == Header ||
          L->getLoopLatch() != LastMBB)
        continue;
    } else {
      // Rotated: collect the loop blocks laid out contiguously before LastMBB
      // (the rest of the rotated loop top); they move together with it.
      while (Top->getPrevNode() && L->contains(Top->getPrevNode()))
        Top = Top->getPrevNode();
      assert(Top != &MF.front() && "Hardware loop latch is the entry block");
    }

    MachineBasicBlock *BeforeTop = Top->getPrevNode();
    MachineBasicBlock *AfterLast = LastMBB->getNextNode();
    MachineBasicBlock *AfterBottom = Bottom->getNextNode();

    MF.splice(std::next(Bottom->getIterator()), Top->getIterator(),
              std::next(LastMBB->getIterator()));

    keepFallthrough(BeforeTop, Top, TII);
    keepFallthrough(Bottom, AfterBottom, TII);
    keepFallthrough(LastMBB, AfterLast, TII);

    // The branch from Bottom to Top (typically the loop back edge into the
    // rotated latch) now targets the layout successor: drop it, so it does
    // not cost a jump in every iteration.
    MachineBasicBlock::iterator BI = Bottom->getLastNonDebugInstr();
    if (BI != Bottom->end() && BI->getDesc().isUnconditionalBranch() &&
        BI->getOperand(0).isMBB() && BI->getOperand(0).getMBB() == Top)
      BI->eraseFromParent();

    Changed = true;
  }
  return Changed;
}

bool PULPFixupHwLoops::fixupLoopPreheader(MachineFunction &MF) {
  bool changed = false;
  for (MachineBasicBlock &MBB : MF) {
    for (MachineInstr &MI : MBB) {
      if (isHardwareLoop(MI)) {
        MachineInstr &Term = *(--MBB.end());
        if (Term.getDesc().isUnconditionalBranch()) {
          assert(MBB.succ_size() == 1 && "Too many successors!");
          MachineBasicBlock *LoopStartMBB = *MBB.succ_begin();
          if (MBB.isLayoutSuccessor(LoopStartMBB)) {
            Term.eraseFromParent();
            changed = true;
            break;
          }
        }
      }
    }
  }
  return changed;
}

// Returns true if it is safe to remove uses of bumpReg. This is the case if it
// is not used between setup and the end of lastBlock AND the first use of the
// register after lastBlock is a write-only (no dependency on old value). The
// instructions that operate on the bump register throughout the loop are
// inserted into regUsers.
bool fixupBump(MachineBasicBlock *lastBlock, MachineInstr *setup,
               unsigned bumpReg, std::set<MachineInstr *> &regUsers) {

  std::set<MachineBasicBlock *> visited;
  std::set<MachineInstr *> tmpRegUsers;

  // Track backwards to find all instruction uses. Goal is to ensure bumped
  // register is not used within loop.
  std::queue<MachineBasicBlock *> backtrackQ;
  backtrackQ.push(lastBlock);
  while (!backtrackQ.empty()) {
    // Get next from queue.
    MachineBasicBlock *MBB = backtrackQ.front();
    backtrackQ.pop();
    if (visited.count(MBB) > 0) {
      continue;
    }
    visited.insert(MBB);

    // Loop backwards through block, recording any users of the bump register.
    // If we reach the top of the loop (setup), we will stop our search.
    bool foundSetup = false;
    for (auto I = MBB->instr_rbegin(), E = MBB->instr_rend(); I != E; I++) {
      MachineInstr *MII = &(*I);
      if (MII == setup) {
        foundSetup = true;
        break;
      }
      for (unsigned i = 0; i < MII->getNumOperands(); i++) {
        MachineOperand &MOp = MII->getOperand(i);
        if (MOp.isReg()) {
          if (MOp.getReg() == bumpReg) {
            tmpRegUsers.insert(MII);
          }
        }
      }
    }

    // Enqueue its predecessors.
    if (!foundSetup) {
      for (MachineBasicBlock *Pred : MBB->predecessors()) {
        backtrackQ.push(Pred);
      }
    }
  }

  // Track forwards, bfs, to check that the first use of the instruction is
  // always a write. Backloops are prevented, as the loop blocks are already in
  // the visited set.
  std::queue<MachineBasicBlock *> fwdQ;
  for (MachineBasicBlock *Succ : lastBlock->successors()) {
    fwdQ.push(Succ);
  }
  visited.insert(lastBlock);
  bool alwaysWrite = true;
  while (!fwdQ.empty()) {
    MachineBasicBlock *MBB = fwdQ.front();
    fwdQ.pop();
    if (visited.count(MBB) > 0) {
      continue;
    }
    visited.insert(MBB);

    // Check for uses
    bool found = false;
    for (MachineInstr &MI : *MBB) {
      // If this is a read of the register, and we have not yet encountered a
      // write, then it is not safe to remove this register.
      alwaysWrite &= !MI.readsRegister(bumpReg, /*TRI=*/nullptr);
      if (MI.modifiesRegister(bumpReg, nullptr)) {
        // We do not need to continue searching, the old value is killed here.
        found = true;
        break;
      }
    }

    // If we didn't find the first use, continue to next block(s). Quit early
    // if we already know that we don't always write.
    if (!found && alwaysWrite) {
      for (MachineBasicBlock *Succ : MBB->successors()) {
        fwdQ.push(Succ);
      }
    }
  }

  // If we don't always see an overwrite of the register value before the next
  // read after the hardware loop, then it is not safe to remove the bump
  // instruction: Return false.
  // TODO: If we can calculate the end value and assign it to the register after
  //       the loop, then we can just insert that load-immediate and continue.
  if (!alwaysWrite) {
    return false;
  }

  // Get all the users of the bump registers to the referenced set, and then
  // return true.
  regUsers.insert(tmpRegUsers.begin(), tmpRegUsers.end());
  return true;

}

bool PULPFixupHwLoops::fixupLoopLatch(MachineFunction &MF) {

  bool changedNow = false;
  bool changedOverall = false;
  std::set<MachineInstr *> toRemove;

  // Look at each loop instruction in turn, removing the branching instructions
  // at the end of them. The outer do...while loop and the breaks ensure that we
  // are not modifying the instruction stream while iterating over it in the
  // inner for loops: If we have changed the data structure, restart from
  // scratch.
  // TODO We might be able to optimize this a bit, but it shouldn't affect the
  //      total compilation time too much.
  do {
    changedNow = false;
    for (MachineBasicBlock &MBB : MF) {
      for (MachineInstr &MI : MBB) {
        if (isHardwareLoop(MI)) {
          // Get the ExitingBlock, and from there the ExitBlock
          MachineLoopInfo *MLI =
              &getAnalysis<MachineLoopInfoWrapperPass>().getLI();
          MachineBasicBlock *LastMBB = MI.getOperand(0).getMBB();
          MachineLoop *L = MLI->getLoopFor(LastMBB);
          assert(L->contains(LastMBB) && "Loop does not contain LastMBB");
          if (getLayoutBottom(L) != LastMBB) {
            // Update the end of the loop from previous transformations. If the
            // new bottom is reachable from the previous LastMBB, and all blocks
            // are in layout order and are still in the loop, then update.
            MachineBasicBlock *current = LastMBB;
            bool reachedEnd = false;
            while (current != getLayoutBottom(L) && !reachedEnd) {
              bool found = false;
              for (MachineBasicBlock &succ : MF) {
                if (current->isLayoutSuccessor(&succ) &&
                    L->getBlocksSet().find(&succ) != L->getBlocksSet().end()) {
                  current = &succ;
                  found = true;
                  break;
                }
              }
              if (!found) {
                reachedEnd = true;
              }
            }
            if (current == getLayoutBottom(L)) {
              LastMBB = getLayoutBottom(L);
              MachineOperand countMO = MI.getOperand(1);
              MI.removeOperand(1);
              MI.removeOperand(0);
              MI.addOperand(MachineOperand::CreateMBB(LastMBB));
              MI.addOperand(countMO);
            }
          }
          assert(getLayoutBottom(L) == LastMBB && "Last is not Bottom");
          // Where the hardware loop continues when the count is exhausted:
          // the latch's own exit. L->getExitBlock() is not used, because it is
          // null when other blocks also exit the loop (early exits) or when
          // two exit edges go to the same block.
          MachineBasicBlock *ExitBlock = getLatchExit(L, LastMBB);
          MachineBasicBlock::iterator LastI = LastMBB->getFirstTerminator();
          // LastMBB may have no terminator left (a back-edge branch removed
          // in an earlier round of this do...while loop): do not dereference
          // end() then.
          if (LastI != LastMBB->end()) {
            DebugLoc LastIDL = LastI->getDebugLoc();
            if (LastI->getOpcode() == RISCV::BEQ ||
                LastI->getOpcode() == RISCV::BNE ||
                LastI->getOpcode() == RISCV::BLT ||
                LastI->getOpcode() == RISCV::BGE ||
                LastI->getOpcode() == RISCV::BLTU ||
                LastI->getOpcode() == RISCV::BGEU ||
                LastI->getOpcode() == RISCV::P_BNEIMM ||
                LastI->getOpcode() == RISCV::P_BEQIMM) {
              // Check if it is safe to remove the bump instruction, in which
              // case the instructions to remove are placed in regUsers.
              for (unsigned i = 0; i < LastI->getNumOperands(); i++) {
                MachineOperand &MO = LastI->getOperand(i);
                if (MO.isReg()) {
                  std::set<MachineInstr *> regUsers;
                  if (fixupBump(LastMBB, &MI, MO.getReg(), regUsers)) {
                    // Remove the LastI from regUsers, since this instruction is
                    // handled separately.
                    if (regUsers.count(&(*LastI)) > 0) {
                      regUsers.erase(&(*LastI));
                    }
                    // If only the bump instruction remains, then it is safe to
                    // remove it. Caveat: With the current implementation we
                    // need to make sure that we are not violating the minimum
                    // length for HW loops.
                    if (regUsers.size() == 1) {
                      MachineInstr *Cand = (*regUsers.begin());
                      if (Cand->getOpcode() == RISCV::ADD ||
                          Cand->getOpcode() == RISCV::ADDI ||
                          Cand->getOpcode() == RISCV::SUB) {
                        if (Cand->getOperand(0).isReg() &&
                            Cand->getOperand(1).isReg() &&
                            Cand->getOperand(0).getReg()
                            == Cand->getOperand(1).getReg()) {
                          // Count only the non-branch instructions: the
                          // block's terminators are rewritten below and the
                          // latch can end with two branches (conditional
                          // plus unconditional), in which case size() <= 2
                          // let the bump go and left the latch without any
                          // instruction to mark the loop end with.
                          // (Only for the latch; other blocks keep the
                          // original rule.)
                          MachineBasicBlock *CandMBB = Cand->getParent();
                          if (CandMBB == LastMBB
                                  ? std::distance(CandMBB->begin(),
                                                  CandMBB->getFirstTerminator()) <= 1
                                  : CandMBB->size() <= 2) {
                            // If this is part of the two last (potentially)
                            // mandatory (hw loops require length of at least 2)
                            // instructions in the block, it would require much
                            // more work to remove it. Either because this is
                            // the instruction that marks the end of the HW
                            // loop, or because the length would change such
                            // that we need to insert more nops.
                            // FIXME: The bump fixup should be done at an
                            //        earlier stage such that we do not have to
                            //        worry about it during this phase of the
                            //        fixup.
                          } else {
                            toRemove.insert(Cand);
                          }
                        }
                      }
                    }
                  }
                }
              }
              // Delete one and change/add an uncond. branch to out of the loop.
              MachineBasicBlock *BranchTarget = LastI->getOperand(2).getMBB();
              LastI = LastMBB->erase(LastI);
              if (BranchTarget == ExitBlock) {
                // This is the branch we want to keep.
                if (LastI != LastMBB->end()) {
                  LastI = LastMBB->erase(LastI);
                }
                SmallVector<MachineOperand, 0> Cond;
                const RISCVSubtarget &HST = MF.getSubtarget<RISCVSubtarget>();
                const RISCVInstrInfo *TII = HST.getInstrInfo();
                TII->insertBranch(*LastMBB, BranchTarget, nullptr, Cond,
                                  LastIDL);
                changedNow = true;
                changedOverall = true;
              }
            } else if (LastI->getOpcode() == RISCV::PseudoBR) {
              MachineBasicBlock *BranchTarget = LastI->getOperand(0).getMBB();
              if (BranchTarget == L->getHeader())  {
                // Unconditional branch to loop start; just delete it.
                LastMBB->erase(LastI);
                changedNow = true;
                changedOverall = true;
              }
            } else {
              llvm_unreachable("Unknown branch type!");
            }
          }
        }
        if (changedNow) {
          break;
        }
      }
      if (changedNow) {
        break;
      }
    }

  } while (changedNow == true);

  for (MachineInstr *MI : toRemove) {
    MI->eraseFromParent();
  }

  return changedOverall;
}

/// This function makes two passes over the basic blocks. The first pass
/// labels all loop ends. The second checks the length of the hardware loops,
/// and pads them with NOPs if they are too short, or uses the explicit setup
/// instructions if they are too long (fixupOneLoopLength).
bool PULPFixupHwLoops::fixupLoopInstrs(MachineFunction &MF) {

  const RISCVInstrInfo *RII =
      static_cast<const RISCVInstrInfo *>(MF.getSubtarget().getInstrInfo());

  // First pass: Label the end of each loop.
  bool Changed = false;
  for (MachineBasicBlock &MBB : MF) {
    // Loop over all the instructions.
    MachineBasicBlock::iterator MII = MBB.begin();
    MachineBasicBlock::iterator MIE = MBB.end();
    while (MII != MIE) {
      if (MII->isMetaInstruction()) {
        ++MII;
        continue;
      }
      if (isHardwareLoop(*MII)) {
        assert(MII->getOperand(0).isMBB() &&
               "Expect a basic block as loop operand");
        // Figure out which MBB that is the last one in the loop.
        MachineBasicBlock *LastMBB = MII->getOperand(0).getMBB();

        // The latch can be left without any non-branch instruction once
        // fixupLoopLatch removed its compare-and-branch (for example a loop
        // whose counter update was folded into a post-increment load in the
        // header). The loop end must still label an instruction of the loop:
        // put a NOP there, as for inline asm below, instead of stepping
        // before the start of the block.
        if (LastMBB->getFirstTerminator() == LastMBB->begin()) {
          DebugLoc DL = MII->getDebugLoc();
          BuildMI(*LastMBB, LastMBB->getFirstTerminator(), DL,
                  RII->get(RISCV::ADDI), RISCV::X0).addReg(RISCV::X0)
                                        .addImm(0);
        }

        // Create a new basic block in the loop, and insert it after the
        // current last. It will be used to label the last instruction in the
        // loop.
        MachineBasicBlock::iterator instrToMove = --LastMBB->getFirstTerminator();

        // Inline ASM can contain multiple instructions, causing the loop to end
        // too early. Work around this by inserting a NOP at the end.
        if (instrToMove->isInlineAsm()) {
          DebugLoc DL = instrToMove->getDebugLoc();
          BuildMI(*LastMBB, LastMBB->getFirstTerminator(), DL,
                  RII->get(RISCV::ADDI), RISCV::X0).addReg(RISCV::X0)
                                        .addImm(0);
          instrToMove = --LastMBB->getFirstTerminator();
        }

        MachineBasicBlock::iterator firstPossibleMove = LastMBB->getFirstNonPHI();
        MachineFunction *MF = LastMBB->getParent();
        auto LoopEnd = MF->CreateMachineBasicBlock();
        MF->insert(++LastMBB->getIterator(), LoopEnd);
        // Adopt the control flow.
        LoopEnd->transferSuccessors(LastMBB);
        LastMBB->addSuccessor(LoopEnd);
        // Put the last instruction of the loop in this new block, whose label
        // we will use to calculate the length of the hardware loop.
        while ((instrToMove->isTransient() ||
              instrToMove->isBranch()) && instrToMove != firstPossibleMove) {
          instrToMove--;
        }
        LoopEnd->splice(LoopEnd->begin(), LastMBB, instrToMove, LastMBB->end());
        LoopEnd->setLabelMustBeEmitted();

        // LoopEnd inherited the loop back edge to the header, which no
        // instruction takes: the hardware jumps back by itself at the end
        // address. Mark it with the zero-size PseudoLOOPend terminator (as
        // Hexagon marks its hardware loop end with ENDLOOP0), so that the
        // block's successors are explained by its terminators; branch
        // analysis treats the block as unanalyzable, like any block ending
        // in a target-specific loop branch. The asm printer emits nothing
        // for it, so addresses and the loop length computed below do not
        // change. It carries no source location: with -g it must not change
        // the line table, and the debug-info writer takes the last located
        // instruction of a block as the line the block leaves with (for
        // is_stmt on the successor, DwarfDebug::findForceIsStmtInstrs).
        MachineLoopInfo *MLI =
            &getAnalysis<MachineLoopInfoWrapperPass>().getLI();
        if (MachineLoop *L = MLI->getLoopFor(LastMBB)) {
          MachineBasicBlock *Header = L->getHeader();
          if (LoopEnd->isSuccessor(Header))
            BuildMI(*LoopEnd, LoopEnd->getFirstTerminator(), DebugLoc(),
                    RII->get(RISCV::PseudoLOOPend))
                .addMBB(Header);
        }

        // The registers read by the moved instructions are live into
        // LoopEnd: compute its live-ins from its successors, as upstream
        // block-splitting code does (the block had none, which the machine
        // verifier reports as uses of undefined registers).
        LivePhysRegs LiveRegs;
        computeAndAddLiveIns(LiveRegs, *LoopEnd);

        // Update the loop setup instruction with the actual loop end.
        DebugLoc DL = MII->getDebugLoc();
        MachineInstrBuilder MIB = BuildMI(*MII->getParent(), MII,
            DL, RII->get(MII->getOpcode()));
        MIB.addMBB(LoopEnd);
        MIB.add(MII->getOperand(1));
        // Remove old
        MII = MII->getParent()->erase(MII);
      } else {
        ++MII;
      }
    }
  }

  // Second pass: pad loops that are too short and switch lp.setupi to the
  // long form (lp.starti, lp.endi, lp.counti) where its end offset does not
  // fit, based on the real sizes and addresses of all instructions.
  //
  // Both changes insert code, which makes every loop around the insertion
  // point longer, including loops decided earlier (an outer loop is visited
  // before the loops nested in it). So, like upstream branch relaxation
  // (llvm/lib/CodeGen/BranchRelaxation.cpp), recompute the layout after each
  // change and repeat until nothing changes. This terminates: a setup is
  // expanded at most once and a loop is padded at most once, since loops only
  // ever grow.
  while (fixupOneLoopLength(MF))
    ;

  return Changed;
}

namespace {
// Size of a hardware loop in the final code.
struct HwLoopExtent {
  // False if the end label does not follow the setup in the layout.
  bool EndAfterSetup = false;
  // Upper bound of the end offset encoded in the setup instruction: bytes
  // from the setup to the last instruction of the loop, including the
  // alignment padding the assembler may insert in between.
  int64_t EndOffset = 0;
  // Instruction bytes from the loop start (after the setup) to the last
  // instruction of the loop, without alignment padding.
  int64_t LoopLen = 0;
};
} // namespace

// Measures the loop set up by Setup, whose last instruction starts block End,
// with the real size of every instruction (getInstSizeInBytes, which knows
// which instructions will be compressed).
//
// Alignment: runOnMachineFunction later moves every setup that is not the
// first instruction of its block into a new 4-byte aligned block, so the
// assembler may insert padding before it, and before any aligned block.
// Addresses are multiples of the instruction granularity G (2 bytes with
// compressed instructions, else 4). If the setup itself ends up 4-byte
// aligned, the addresses after it are known modulo 4 and padding up to
// 4-byte alignment is known exactly. Otherwise the setup's address modulo 4
// depends on where the function is placed, and like upstream branch
// relaxation (BasicBlockInfo::postOffset, llvm/lib/CodeGen/BranchRelaxation
// .cpp) the worst case is assumed: A - G bytes before an A-aligned point.
static HwLoopExtent measureHwLoop(const MachineInstr &Setup,
                                  const MachineBasicBlock *End) {
  const MachineBasicBlock *SetupMBB = Setup.getParent();
  const MachineFunction &MF = *SetupMBB->getParent();
  const uint64_t G =
      MF.getSubtarget<RISCVSubtarget>().hasStdExtCOrZca() ? 2 : 4;
  const bool Known = &Setup != &SetupMBB->front() ||
                     SetupMBB->getAlignment() >= Align(4);

  HwLoopExtent E;
  int64_t Rel = 0, Bytes = 0;
  auto Pad = [&](Align A) {
    if (A.value() <= G)
      return;
    if (!Known)
      Rel += A.value() - G;
    else if (A.value() <= 4)
      Rel = alignTo(Rel, A);
    else
      Rel = alignTo(Rel, Align(4)) + A.value() - 4;
  };
  auto Add = [&](const MachineInstr &MI) {
    int64_t Size = getMISize(MI);
    Rel += Size;
    Bytes += Size;
  };

  for (auto I = Setup.getIterator(), IE = SetupMBB->instr_end(); I != IE; ++I)
    Add(*I);
  const MachineBasicBlock *B = SetupMBB->getNextNode();
  for (; B && B != End; B = B->getNextNode()) {
    Pad(B->getAlignment());
    for (const MachineInstr &MI : B->instrs()) {
      if (isHardwareLoop(MI) && &MI != &B->front())
        Pad(Align(4));
      Add(MI);
    }
  }
  if (!B)
    return E;
  Pad(End->getAlignment());
  E.EndAfterSetup = true;
  E.EndOffset = Rel;
  E.LoopLen = Bytes - SetupSize;
  return E;
}

/// Finds the first hardware loop (in layout order) that is too short or whose
/// end offset does not fit its setup instruction, and fixes it: pads it with
/// NOPs, or replaces lp.setupi with the long form. Returns false when every
/// loop is fine. Called until it returns false, because each fix makes the
/// loops around it longer.
bool PULPFixupHwLoops::fixupOneLoopLength(MachineFunction &MF) {
  const RISCVInstrInfo *RII =
      static_cast<const RISCVInstrInfo *>(MF.getSubtarget().getInstrInfo());

  for (MachineBasicBlock &MBB : MF) {
    for (MachineBasicBlock::iterator MII = MBB.begin(), MIE = MBB.end();
         MII != MIE; ++MII) {
      if (!isHardwareLoop(*MII))
        continue;
      assert(MII->getOperand(0).isMBB() &&
             "Expect a basic block as loop operand");
      MachineBasicBlock *TargetBB = MII->getOperand(0).getMBB();
      assert(getMISize(*MII) == SetupSize && "Unexpected setup size");

      HwLoopExtent Extent = measureHwLoop(*MII, TargetBB);
      // The end label must follow the setup; if it does not, the loop layout
      // is broken in a way this function cannot repair, and the assembler
      // reports the offset as out of range.
      if (!Extent.EndAfterSetup)
        continue;
      int64_t RangeLen = Extent.EndOffset - SetupSize;
      int64_t LoopLen = Extent.LoopLen;

      MachineBasicBlock::iterator inspt = std::next(MII);
      DebugLoc DL = MII->getDebugLoc();

      // Handle loop lengths (address range).
      if (isHardwareLoopImm(*MII) &&
          RangeLen > std::min<int64_t>(MaxLoopRangeImm,
                                       MaxEndOffsetSetupi - SetupSize)) {
        // If the loop spans a larger address range than what can be supported
        // by lp.setupi (five bits for relative end address), we have to
        // switch to the separate lp.starti, lp.endi, and lp.counti
        // instructions.
        assert(MBB.succ_size() == 1 && "Too many successors!");
        assert(isHardwareLoopZero(*MII) || isHardwareLoopOne(*MII));
        MachineBasicBlock *LoopStartMBB = *MBB.succ_begin();
        // Expand into long loop setup instructions, depending on if it is
        // loop 0 or loop 1.
        if (isHardwareLoopZero(*MII)) {
          BuildMI(MBB, inspt, DL, RII->get(RISCV::LOOP0starti))
              .addMBB(LoopStartMBB);
          BuildMI(MBB, inspt, DL, RII->get(RISCV::LOOP0endi)).addMBB(TargetBB);
          BuildMI(MBB, inspt, DL, RII->get(RISCV::LOOP0counti))
              .addImm(MII->getOperand(1).getImm());
        } else {
          BuildMI(MBB, inspt, DL, RII->get(RISCV::LOOP1starti))
              .addMBB(LoopStartMBB);
          BuildMI(MBB, inspt, DL, RII->get(RISCV::LOOP1endi)).addMBB(TargetBB);
          BuildMI(MBB, inspt, DL, RII->get(RISCV::LOOP1counti))
              .addImm(MII->getOperand(1).getImm());
        }
        // Take address for start block.
        LoopStartMBB->setMachineBlockAddressTaken();
        LoopStartMBB->setLabelMustBeEmitted();
        // This line is needed to set the hasAddressTaken flag on the
        // BasicBlock object.
        BlockAddress::get(
            const_cast<BasicBlock *>(LoopStartMBB->getBasicBlock()));
        // Remove old instruction.
        MII->eraseFromParent();
        return true;
      }
      if (isHardwareLoopReg(*MII) &&
          RangeLen > std::min<int64_t>(MaxLoopRangeReg,
                                       MaxEndOffsetSetup - SetupSize)) {
        // FIXME: If the loop spans a larger address range than what can fit
        //        in lp.setup instruction format (twelve bits), I am not sure
        //        what to do. We have no way of storing more information in
        //        any of the "long" instructions. We'd have to roll back,
        //        probably?
        errs().changeColor(raw_fd_ostream::Colors::RED, true);
        errs() << "UNHANDLED: Hardware Loop length " << RangeLen << " is "
               << "higher than limit for lp.setup: "
               << std::min<int64_t>(MaxLoopRangeReg,
                                    MaxEndOffsetSetup - SetupSize)
               << "\n";
        errs().resetColor();
        abort();
      }
      if (LoopLen < 4) {
        // Loop length is too small (must be at least two instructions): Fill
        // up with nops.
        // The nops go right after the setup, where the loop starts. The
        // setup is a terminator and a block may not continue after its
        // terminators (the machine verifier rejects it), so when the setup
        // ends its block, put the nops in a block of their own between it
        // and the block it falls into. Not at the start of that block:
        // other blocks may jump to its label and must still skip the nops.
        // The instructions and their addresses are the same as with the
        // nops in the setup's block.
        MachineBasicBlock *PadMBB = &MBB;
        MachineBasicBlock::iterator PadPt = inspt;
        MachineBasicBlock *Next = MBB.getNextNode();
        if (inspt == MBB.end() && Next && MBB.isSuccessor(Next)) {
          PadMBB = MF.CreateMachineBasicBlock();
          MF.insert(Next->getIterator(), PadMBB);
          MBB.replaceSuccessor(Next, PadMBB);
          PadMBB->addSuccessor(Next);
          PadPt = PadMBB->end();
        }
        while (LoopLen < 4) {
          MachineInstrBuilder NOP = BuildMI(*PadMBB, PadPt, DL,
                                            RII->get(RISCV::ADDI));
          NOP.addReg(RISCV::X0, RegState::Define);
          NOP.addReg(RISCV::X0);
          NOP.addImm(0);
          LoopLen += getMISize(*NOP.getInstr());
        }
        if (PadMBB != &MBB) {
          LivePhysRegs LiveRegs;
          computeAndAddLiveIns(LiveRegs, *PadMBB);
        }
        return true;
      }
    }
  }
  return false;
}
