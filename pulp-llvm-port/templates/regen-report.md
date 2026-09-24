# <step>/<task-id>: regen report

Script and command used (one line per test file):

- `llvm/utils/update_llc_test_checks.py --llc-binary <build>/bin/llc <test>`

Per changed CHECK block (one row each; every block that changed must appear):

| Test file | Function / block | Class | Before (instructions) | After (instructions) | Explanation |
|---|---|---|---|---|---|
| | | cosmetic / semantic | count | count | why this is only register naming / label numbering / scheduling order, or what semantically changed |

Rules: `cosmetic` means the multiset of instruction mnemonics in the block is identical (only register names, labels, immediates of stack offsets, or order changed). Anything else is `semantic`, and a `semantic` row means the task result is `escalated`, not landed.

Instruction-mix check for the whole file (`llvm-objdump` or the CHECK lines themselves): count of `lp.`, `p.l*/p.s*` post-increment, `pv.`, `p.mac`, `frep.`, `scfg*` before and after.
