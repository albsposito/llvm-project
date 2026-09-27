# 20/T006: regen report

Script and command used (one line per test file):

- `llvm/test/MC/RISCV/rv32xmempool-invalid.s`: no LLVM update script covers MC `-invalid` diagnostic tests (`update_mc_test_checks.py` only generates encoding/asm CHECKs for valid input), so rule 3 is satisfied by the owner exception `notes/20/owner-test-exceptions.md#t001`. The single line was edited with one anchored `sed` substitution on line 4, replacing only the message text; the new text is copied verbatim from the output of `build/int-20/bin/llvm-mc` (`logs/20-T006.repro.log`).

Per changed CHECK block (one row each; every block that changed must appear):

| Test file | Function / block | Class | Before (instructions) | After (instructions) | Explanation |
|---|---|---|---|---|---|
| llvm/test/MC/RISCV/rv32xmempool-invalid.s | line 4, expected diagnostic for `csrr t0, trace` | cosmetic | 0 (diagnostic only; input `csrr` x1 unchanged) | 0 (diagnostic only; input `csrr` x1 unchanged) | Only the wording of the error changed (`system register use requires an option to be enabled` -> `system register 'trace' requires 'xmempool' to be enabled`, upstream `107f3efdbede`). Location `[[@LINE+1]]:13`, `error:` prefix, RUN lines and input are unchanged. |

Instruction-mix check for the whole file: the file has no instruction CHECK lines; the only input is one `csrr`. Counts of `lp.`, `p.l*/p.s*` post-increment, `pv.`, `p.mac`, `frep.`, `scfg*`: 0 before, 0 after.

Verification: `build/20-T006/bin/llvm-lit -v llvm/test/MC/RISCV/rv32xmempool-invalid.s` (wrapper running build/int-20 lit and tools on the wt/20-T006 test tree): before FAIL (`logs/20-T006.repro.log`), after PASS (`logs/20-T006.verify.log`).
