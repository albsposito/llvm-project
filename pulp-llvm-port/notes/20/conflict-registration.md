# Step 20 registration conflict resolution

## Cause

Cherry-pick `43da10e5e761` (`[pulp] registration: extensions, features, processors, CSRs`) from llvmorg-19.1.7..port/19 onto llvmorg-20.1.8 encountered four both-modified paths. Automatically merged RISCV.td and RISCVSubtarget.h changes were retained.

## Resolution

- `llvm/lib/Target/RISCV/RISCVFeatures.td`: preserve upstream removal of forced-sw-shadow-stack by `e3b0ef7aaacb` (`[RISCV] Remove forced-sw-shadow-stack in RISCVFeatures.td (#115447)`). Those definitions were unchanged fork-parent context, not fork additions. Append all fork definitions. `d280a9c5e226` (`[NFC] [RISCV] Refactor class RISCVExtension (#120040)`) removed the explicit ISA-name constructor argument and derives Name/Desc from record names. Adapt five fork constructors to the new integer-first signature, overriding Name and Desc to retain exact prior values. Existing record identifiers retain default `fieldname = !subst("Feature", "Has", NAME)` results and all cross-cluster references. Versions, implications and predicates are preserved. References: RISCVFeatures.td:29-40 defines constructor/properties; CORE-V FeatureVendorXCVelw at line 1183 and FeatureVendorXCVmem at line 1204 demonstrate constructor use. CORE-V follows the naming convention; no upstream vendor record with Name/Desc overrides was found. Overriding the same inherited properties preserves the old feature identifiers without broad cross-cluster renaming. No ISA behavior change is intended.
- `llvm/lib/Target/RISCV/RISCVProcessors.td`: retain upstream SPACEMIT_X60 ending and RP2350_HAZARD3, then append fork MEMPOOL and SNITCH unchanged. Relevant commits: `9fa2386ff132` (`[RISCV] Add Hazard3 Core as taped out for RP2350 (#102452)`), `5a16ed96c536` (`[RISCV] Add +unaligned-scalar-mem to spacemit-x60 (#115125)`), `beb12f92c719` (`[RISCV] Add +optimized-nfN-segment-load-store (#114414)`), `4da960b898f4` (`[RISCV] Add mvendorid/marchid/mimpid to CPU definitions (#116202)`).
- `llvm/lib/Target/RISCV/RISCVSystemOperands.td`: retain control-transfer CSRs from `0ca77f6656a7` (`[RISCV] Add CSRs and an instruction for Smctr and Ssctr extensions. (#105148)`), then append fork trace CSR with unchanged Xmempool requirement and encoding.
- `llvm/unittests/TargetParser/RISCVISAInfoTest.cpp`: union expected extension lists in lexical order, preserving MIPS entries from `0cb7636a462a` (`[RISCV] Add MIPS extensions (#121394)`) and every fork extension/version. No assertion, test, RUN line or check removed or weakened. This was the assigned conflict-only test merge, not test regeneration.

## Validation

`git diff --check` and staged diff check passed; marker scan over all four paths found none. No build or test regeneration attempted. SmallfloatGen constructor adaptation remains for its owning cluster/build phase.

## Outcome

Committed registration as `324298c2579c`. Continued exactly once; sequence now paused at `1121be252fb3` (`[pulp] insn-tablegen: Xpulp/Xsmallfloat/Xssr/Xdma/Xfrep instructions and sched models`) with conflict in llvm/lib/Target/RISCV/RISCVInstrInfo.td. No changes made to that cluster. Initial note write failed because notes/20 did not yet exist; directory created and this note recorded immediately after continuation.
