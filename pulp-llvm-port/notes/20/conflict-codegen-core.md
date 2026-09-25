# Step 20 codegen-core conflict

status: resolved-with-escalations

Pick `24a15b1dc253` ([pulp] codegen-core: lowering, ISel, instr/register info, TTI), from llvmorg-19.1.7 onto llvmorg-20.1.8 in wt/int-20. Five both-modified paths resolved, plus mandatory calling-convention relocation. Evidence below was found with range-limited `git log -G`, `-S`, and `--follow` in llvmorg-19.1.7..llvmorg-20.1.8. No tests changed or build run.

## Changes and evidence

All paths below are under llvm/lib/Target/RISCV/.

- RISCVISelDAGToDAG.cpp (both modified): kept upstream RISCVInstrInfo.h include from `a5b65399a7e0` “[RISCV] Move ActiveElementsAffectResult to TSFlags. NFC (#101123)”; retained fork removal of obsolete RISCVMachineFunctionInfo.h include. Kept getSegInstNF from `22f98740b618` “[llvm][RISCV] Support RISCV vector tuple CodeGen and Calling Convention (#97995)”, then the complete PULP indexed-load/shuffle helpers. Existing auto-merged LOAD selection keeps PULP before CORE-V, whose RV32 predicate remains intact. CORE-V reference: RISCVISelDAGToDAG.cpp:1679.
- RISCVISelLowering.cpp (both modified): retained upstream redistribution of XCValu actions from `76a15e5fc1af` “[RISCV] Keep all the setOperationActions for the same types and opcodes together.” and RV32 guards from `ad8026587464` “[RISCV] Qualify all XCV predicates with !is64Bit. (#101074)”; appended original DMA and nofdiv actions without restoring stale duplicated XCValu block. CORE-V current references: lines 299, 315, 385, 408, 1561 and 22039. Kept upstream Zfinx inline-asm f constraint cases from `1bc1a79a65a9` “[RISCV] Support inline assembly 'f' constraint for Zfinx. (#112986)” and NoX0 classes from `03dcd88c781d` “[RISCV][ISel] Ensure 'in X' Constraints prevent X0 (#112563)”; appended unchanged Xsmallfloat vector cases after scalar cases.
- RISCVISelLowering.cpp calling-convention conflict: upstream `093b8bfe6b64` “[RISCV] Separate the calling convention handlers into their own file. NFC (#107484)” moved the handler into RISCVCallingConv.cpp. `62180dfd8d86` “[RISCV] Reduce the interface to RISCVCCAssignFn. NFC (#107503)” changed its signature; `db67a66e8e02` “Revert \"[RISCV] RISCV vector calling convention (2/2)\" (#97994)” removed RVVArgDispatcher. Retained upstream removal of the old block and relocated exactly the PULP GPR-allocation branch and existing PULP assertion alternative to CC_RISCV in RISCVCallingConv.cpp:533 and :593. The replacement allocator for non-PULP vectors is upstream allocateRVVReg. CORE-V has no separate vector ABI handler; current CORE-V hooks above do not supply an alternate ABI design. `ee4582f9c8c3` “[RISCV] Use CCValAssign::getCustomReg for fixed vector arguments/returns with RVV. (#108470)” now marks RVV fixed vectors custom; this conversion remains for non-PULP fixed vectors, while existing PULP direct GPR assignment remains ordinary getReg. No fastcc changes. This new path must be included in codegen-core cluster ownership.
- RISCVInstrInfo.cpp (both modified): kept fork OPERAND_UIMM12M1 validation and upstream removal of the obsolete explicit OPERAND_SIMM12 case from `95c5386ddb8a` “[RISCV][NFCI] Rationalize Immediate Definitions (#120718)”. Upstream consolidated immediate validation remains intact.
- RISCVRegisterInfo.td (both modified): kept all reordered upstream GPR floating classes and section boundaries from `4a0c3077b007` “[RISCV][NFCI] Reorder RISCVRegsiterInfo.td”, inserted original PulpV2/PulpV4 classes before that section.
- RISCVTargetTransformInfo.h (both modified): kept upstream canSplatOperand, isProfitableToSinkOperands (`853c43d04a37` “[TTI] NFC: Port TLI.shouldSinkOperands to TTI (#110564)”) and memcmp expansion (`7a5b040e2039` “[RISCV] Add initial support of memcmp expansion”), then fork isLoweredToCall. Reused the identical existing getPreferredAddressingMode declaration at line 391, introduced by `f590963db836` “[RISCV] Implement RISCVTTIImpl::getPreferredAddressingMode for HasVendorXCVmem (#120533)”, rather than declare twice. No functionality removed: the shared signature serves both features.

## Escalations and build follow-ups

- ESCALATE: step-19 branch-immediate round trip question remains open. PULP P_BEQIMM/P_BNEIMM may be reconstructed as CORE-V CV_BEQIMM/CV_BNEIMM; preserved existing behavior, no guessed predicate design.
- ESCALATE: step-19 dual xpulpv/xcvmem order remains: selector tries PULP first, lowering CORE-V first. RV32 CORE-V predicates kept; no policy chosen.
- ESCALATE: step-19 RVVArgDispatcher index drift is superseded by its upstream removal, but mixed V/PULP vectors still inherit the fork's broad vector-to-GPR rule and fastcc still has no PULP case. Relocation preserves direct PULP GPR assignments, avoids applying RVV custom conversion to them, and preserves tuple/RVV upstream behavior otherwise. Validate packed ABI before judging mixed-extension support; no new ABI policy chosen.
- Build follow-up (unconflicted, deliberately untouched): RISCVTargetTransformInfo.cpp:2395 and :2650 both define getPreferredAddressingMode after clean auto-merge. First is CORE-V RV32 behavior from f590963db836; second is PULP behavior from the fork. A scoped worker must combine the feature decisions while retaining the upstream fallback and PULP post-index result. Header declaration is now singular.

## Validation

`git diff --check` clean before staging. Conflict marker scan of all five resolved files clean. No full build, targeted build, or test edits attempted per conflict-resolver SOP. Existing whitespace in cleanly merged fork files is outside this resolution.

Upstream-File-Edit: RISCVCallingConv.cpp is the upstream-relocated home of the two existing PULP CC_RISCV hunks formerly in RISCVISelLowering.cpp (093b8bfe6b64); necessary to preserve fork calling-convention functionality.

Continuation result: landed as `1ea0c09d95a9`. Sequencer advanced to passes pick `647fe517f583`, paused on RISCVTargetMachine.cpp; stopped without editing that cluster. Upstream-File-Edit trailer is present on the codegen commit.
