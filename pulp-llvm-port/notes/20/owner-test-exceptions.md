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

## B40 — proposed regression tests: approved (2026-09-27)

The owner approved adding the regression tests proposed in the `proposed_test` fields of tasks 20/F001, F002, F003, F004, F005, F006, R001 and E007 (new test files only; no existing test changes), so that tonight's fixes are guarded by lit. Done by test task 20/T010, independently reviewed. Each new test must fail on `port-20-green` (or on the build before its fix) and pass on the integration head, except where the fix predates the test's feature.

## B12 — stricter builtin range checks: approved (2026-09-27)

The owner approved making `__builtin_pulp_clip`, `__builtin_pulp_clipu` and `__builtin_pulp_bextract[u]` reject what GAP9 GCC rejects (clip: lo == -(hi+1); clip/clipu: hi <= 2^30-1; bextract: Size >= 1), including updating the existing fork test calls that use now-invalid arguments (e.g. `clip(-10,-4,15)`) to valid ones. Done by task 20/F011 (worker plus a test-regen commit), independently reviewed.

Note on B12 (2026-09-28): the owner's intent was "reject what GAP9 GCC rejects". GCC accepts clip/clipu upper bounds only up to 2^29-1 (N <= 30), so task 20/F011 caps at 2^29-1, not the 2^30-1 written above; the independent review (tasks/20/F011.review.json) confirmed GCC rejects 2^30-1.

## F017 xgap9 — `llvm/unittests/TargetParser/RISCVISAInfoTest.cpp`: approved (2026-09-28, one list entry)

On escalation 20/F017 (how clang should identify GAP9 for `__gap9__`), the owner chose, in the conductor chat on 2026-09-28, an `xgap9` extension spelled like GAP9 GCC's `-march=rv32imcxgap9`. The owner approved updating tests only to add the new extension's line where an existing test lists every extension. Because the ISA parser reads trailing digits as a version, the extension is registered as `xgap` version 9.0 (`-march=rv32imc_xgap9` parses, the same way `xpulpv2` = `xpulpv` 2.0). The only edit is one row, `xgap                 9.0`, in the expected output of `RiscvExtensionsHelp.CheckExtensions`, in its own commit with `Test-Regen: notes/20/F017-regen.md`. `clang/test/Driver/print-supported-extensions-riscv.c` was left alone: it already fails without this change because it lists none of the fork's extensions, and it is not in the step's lit suite. Adding only `xgap` there would not fix it. No other test edits.

## F035 xpulpf16alt/xpulpfvec — `llvm/unittests/TargetParser/RISCVISAInfoTest.cpp`: approved (2026-09-28, two list entries)

Task 20/F035 (backlog B90, fp16 design T0 + T1, owner decision D6/Q7) registers two new GAP9 extensions, `xpulpf16alt` (bfloat16 scalar in GPRs) and `xpulpfvec` (packed fp16 in GPRs), and makes `xgap9` imply them and Zhinx. The owner pre-approved, in the task written by the conductor, adding ONLY the new extension lines to extension-enumerating tests, by the same process as F017. The only edit is two rows, `xpulpf16alt          1.0` and `xpulpfvec            1.0`, in the expected output of `RiscvExtensionsHelp.CheckExtensions`, in their own commit with `Test-Regen: notes/20/F035-regen.md`. `clang/test/Driver/print-supported-extensions-riscv.c` was left alone for the same reason as F017 (it already fails, lists none of the fork's extensions, and is not in the step's lit suite). `llvm/test/CodeGen/RISCV/features-info.ll` uses plain `CHECK` lines and passes unchanged. No other test edits.
