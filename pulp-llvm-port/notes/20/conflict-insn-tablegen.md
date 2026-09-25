# Step 20: insn-tablegen conflict resolution

## Conflict

Paused cherry-pick `1121be252fb3`, onto `llvmorg-20.1.8` from `llvmorg-19.1.7`. One both-modified path: `llvm/lib/Target/RISCV/RISCVInstrInfo.td`.

## Upstream evidence

- `95c5386ddb8a530b43533c82b5dbfc18e81a7235` — `[RISCV][NFCI] Rationalize Immediate Definitions (#120718)` replaces the old UImm20Operand base with RISCVUImmOp<20>.
- `c4645ffedacad18e4cd1dd372288aa55178b1c44` — `[RISCV] Add Qualcomm uC Xqcicsr (CSR) extension (#117169)` adds the Qualcomm include.
- `0cb7636a462a8d4209e2b6344304eb43f02853eb` — `[RISCV] Add MIPS extensions (#121394)` adds the MIPS include.

Evidence obtained with `git log -G` over the upstream release interval for the affected class/include names.

## Resolution

Preserved upstream's RISCVUImmOp<20> inheritance, and inserted the complete fork uimm12m1 operand definition immediately before it. The obsolete UImm20Operand definition is upstream context in the fork patch, not a fork addition. Preserved Qualcomm and MIPS includes and appended all five fork extension includes (Xfrep, Xdma, Xssr, Xsmallfloat, Xpulp). All automatically merged fork hunks and added files remain. No design decision or feature removal required; no tests or build fixes changed.

## Validation

`git diff --check` passed; conflict-marker search found no remaining markers in the resolved file. No build attempted, per conflict-resolver scope. Smallfloat constructor adaptation, if needed, remains for build phase.

The additional whole-index `git diff --cached --check` reported existing whitespace in automatically added XsmallfloatGen, Xssr, and SchedMempool files; these were outside the conflicted path and were preserved. The resolved path itself passed the whitespace check.

One `cherry-pick --continue` created insn-tablegen commit `5e214b809ca0`, automatically applied intrinsics as `32e4e60468b1`, and stopped at codegen-core pick `24a15b1dc253` with five conflicts (RISCVISelDAGToDAG.cpp, RISCVISelLowering.cpp, RISCVInstrInfo.cpp, RISCVRegisterInfo.td, RISCVTargetTransformInfo.h). Those conflicts were left untouched for the next resolver.
