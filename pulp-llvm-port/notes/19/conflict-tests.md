# Conflict: tests (step 19)

Pick: `d7d66a4709b9` "[pulp] tests: fork-authored lit tests and pipeline expectations", applied onto `llvmorg-19.1.7` (stack from `port/18`, base `e6c3289804a6`), in `wt/int-19` on top of the clang-driver pick.

The pick touches 56 files. All new fork test files were added cleanly. `clang/test/Driver/riscv-arch.c` and `llvm/test/CodeGen/RISCV/O3-pipeline.ll` auto-merged. Two paths conflicted.

## Paths

| Path | Conflict type | Upstream change | Resolution |
|---|---|---|---|
| `clang/test/Misc/target-invalid-cpu-note.c` | both modified (2 blocks: `RISCV32-NEXT` and `TUNE-RISCV32-NEXT` CPU lists) | `d59a4cac5fe6` "[RISCV] Add Syntacore SCR3 processor definition (#95953)" appended `syntacore-scr3-rv32` to both rv32 CPU lists. | Kept upstream's list, including `syntacore-scr3-rv32`, and inserted the fork's two CPUs where the fork had them (alphabetical order, same as at 18): `mempool-rv32` after `generic-rv32`, `snitch` after `sifive-e76`. No RUN line changed. The CHECK text is the union of both sides. Nothing else was rewritten. |
| `llvm/test/CodeGen/RISCV/O0-pipeline.ll` | both modified (1 block) | `28233408a2c8` "[CodeGen] [ARM] Make RISC-V Init Undef Pass Target Independent ... (#77770)" renamed the line `RISC-V init undef pass` to `Init Undef Pass`. Also, `1a58e88690c1` / `0ebe48f068c0` moved `RISC-V Insert VSETVLI pass` out of this spot; that part merged without conflict. | Kept upstream's `Init Undef Pass` line and put the fork's 9 pass lines (PULP pseudo expansion, SDMA, SSR, MDT+MLI, Snitch frep loops, MDT+MLI, PULP Hardware Loops) right after `RISC-V Insert Write VXRM Pass` and before it. That is the same position as at 18, and it matches `RISCVPassConfig::addPreRegAlloc` at `llvm/lib/Target/RISCV/RISCVTargetMachine.cpp:562-568` in this tree (fork passes added after the VXRM pass; Init Undef is added later by TargetPassConfig). |

## Pipeline expectation files that need regeneration (test-regen role, later)

- `llvm/test/CodeGen/RISCV/O0-pipeline.ll` (hand-merged as described above).
- `llvm/test/CodeGen/RISCV/O3-pipeline.ll` (auto-merged). The fork's hunks landed next to upstream's new lines (`Init Undef Pass`, VSETVLI now after PHI elimination/coalescing). The fork's hunk also moves one `MachineDominator Tree Construction` line from after `Two-Address instruction pass` to before `Eliminate PHI nodes` (together with a `Machine Natural Loop Construction`). That was the 18 layout and needs checking against real `llc` output at 19.

Both files must be regenerated from `llc -debug-pass=Structure` output once the tree builds. Any change to the fork's pass lines beyond position is a semantic change and must be escalated.

## Checks

- Every `+` line of the fork commit is present verbatim in the resulting files. The only exceptions are the two merged CPU-list lines above, which now also contain upstream's `syntacore-scr3-rv32`.
- No RUN lines removed, no test deleted or renamed.
- No conflict markers. `git diff --cached --check` reports only trailing whitespace and blank-at-EOF in the fork's own new test files (unchanged from 18).

## Result

Committed as `8aa898a062a2` on `port/19`. The last pick, `[pulp] docs: fork README` (`README.md`), then applied cleanly as `7c27289bc3a1`, so no docs conflict note was needed. The cherry-pick sequence is complete.
