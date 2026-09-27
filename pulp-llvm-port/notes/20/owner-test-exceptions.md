# Owner decisions on step-20 tests — 2026-09-27

Asked in the conductor session; answers recorded verbatim in scope. These apply only to the tests named here, not to any class of future edits.

## T001 — `llvm/test/MC/RISCV/rv32xmempool-invalid.s`: approved (this one only)

Upstream `107f3efdbede` "[RISCV][MC] Make error message of CSR with wrong extension more detailed (#104424)" reworded the CSR-without-extension diagnostic and updated upstream's own tests. Fork behaviour is unchanged (the `trace` CSR is still rejected without `+xmempool`, at the same location; evidence `logs/20-T001.repro.log`, `tasks/20/T001.result.json`). The owner approved changing the one expected-diagnostic CHECK line to the new upstream wording, `system register 'trace' requires 'xmempool' to be enabled`. No LLVM update script covers MC `-invalid` tests, so the edit is made by a `test-regen` worker as this recorded exception and independently reviewed (task 20/T006). No RUN line, other CHECK line, or test input may change.

## T002 — `llvm/test/CodeGen/RISCV/rvv/vsetvli-insert-zve64f.mir`: known failure, plus a step-23 design item

New upstream test at 20 (`d2b8acc10464`), never passed at 19. Its input MIR hardcodes inline-asm flag 3145737 (register class ID 47 = VR upstream); the fork's `PulpV2`/`PulpV4` register classes (codegen-core, since 18) shift class IDs by 2, so llc prints the comment `reguse:FPR64` instead of `reguse:VR`. Generated code is otherwise identical to upstream's (evidence `logs/20-T002.repro.log`, `tasks/20/T002.result.json`). Owner decision: add to `data/known-failures.txt` with this reason, and track removing `PulpV2`/`PulpV4` in favour of upstream's P-extension approach (v2i16/v4i8 in GPR, `isPExtPackedType`, see `steps/23/leads.md`) as a step-23 design item.

## T003 — `llvm/test/CodeGen/RISCV/freploop-nested.ll`: approved (one inserted line)

Fork test (added by Federico Ficarelli, CINECA, in `f1b7aebff8c2`, 2022). The FREP miscompile caused by upstream `9122c5235ec8` (bidirectional pre-RA scheduling) is fixed by 20/T003 (`8bcb70882fc6`, FREP_O/FREP_I as scheduling boundaries; reviewed APPROVE, `tasks/20/T003.review.json`), which restores instruction output identical to port-19-green. The test still fails only because the non-instruction assembler comment `# implicit-def: $f15_d` now prints between `li` and `frep.o` in `main1`. The owner approved (2026-09-27) adding exactly one line, `; CHECK-NEXT: # implicit-def: ...` (register as a pattern), between the existing `li` and `frep.o` checks of `main1`, keeping every existing CHECK-NEXT strict. Done by test-regen task 20/T008 on top of the T003 commit, independently reviewed; landed together with T003.

## F001 — `clang/test/CodeGen/RISCV/riscv-xpulpv2-intrinsics.c` and `riscv-xpulpv2-intrinsics-diag.c`: approved (2026-09-27)

Fork defect fix 20/F001 (`8a8fab3863dc`): the `__builtin_pulp_*RN` Sema check compared the wrong argument (`RoundArgNum` instead of `NormArgNum`), so every valid call (Round == 2^(Norm-1), GAP9 GCC's rule) was rejected and some invalid ones accepted; introduced by fork commit `f1b7aebff8c2`. The two fork tests contain 16 calls with Norm=2, Round=1 (`machhsRN`, `machhuRN`, `mulhhsRN`, `mulhhuRN`, `mulsRN`, `muluRN`, `subRN`, `subuRN`, 8 in each file), which GCC rejects and which passed only because of the bug. The owner approved changing Round from 1 to 2 in exactly those 16 calls and the matching expected IR values in `riscv-xpulpv2-intrinsics.c` (`i32 2, i32 1` → `i32 2, i32 2`). Generated instructions are unchanged (the instruction encodes only Norm). Done by test-regen task 20/T009 on top of the F001 commit, independently reviewed, landed together with F001.
