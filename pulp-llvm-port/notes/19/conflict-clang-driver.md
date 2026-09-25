# Conflict: clang-driver (step 19)

Pick: `a19538668ad2` "[pulp] clang-driver: target macros and driver flags", applied onto `llvmorg-19.1.7` (stack from `port/18`, base `e6c3289804a6`), in `wt/int-19` on top of `bce97b01d54c` (clang-frep-pragma).

Merged cleanly: `clang/lib/Basic/Targets/RISCV.cpp`, `clang/lib/Basic/Targets/RISCV.h`, `clang/lib/Driver/ToolChains/Arch/RISCV.cpp`, `clang/lib/Driver/ToolChains/BareMetal.cpp`.

## Paths

| Path | Conflict type | Upstream change | Resolution |
|---|---|---|---|
| `clang/include/clang/Driver/Options.td` | both modified (one block) | `9f2d8cdf4209` "[flang][clang][docs] Split out Clang specific doc text for -mrvv-vector-bits" rewrote the `DocBrief` of `mrvv_vector_bits_EQ` into a `!strconcat`/`!cond` expression. The fork's `def mno_fdiv` sat directly after that def, so its context line changed. | Kept upstream's new `DocBrief` unchanged and re-inserted the fork's two-line `def mno_fdiv : Flag<["-"], "mno-fdiv">, Group<m_riscv_Features_Group>, HelpText<...>` right after it, same position and same text as in the fork. `m_riscv_Features_Group` still exists at 19 (`Options.td:238`), and the def is still inside the `let Flags = [TargetSpecific]` block as before. |

## Checks

- Commit diffstat is identical to the original pick (5 files, +29/-2).
- No conflict markers (`grep '^<<<<<<<'`: none). `git diff --cached --check` only reports a trailing-whitespace line at `clang/lib/Basic/Targets/RISCV.h:30`, which is the fork's own line from the original commit (not a resolution artefact); left as is.
- No build (per SOP).

## Known build issue for the next phase (not fixed here, per SOP)

- `clang/lib/Driver/ToolChains/Arch/RISCV.cpp:222-223` (fork `-mno-fdiv` handling) calls `feat.equals("+fdiv")` / `feat.equals("-fdiv")`. `StringRef::equals` was removed by `3fa409f2318e` "[ADT] Remove StringRef::equals (#98735)" (deprecated in `de483ad51389`). Fix is `feat == "+fdiv"` (see steps/19/leads.md).

## Result

Committed as `84ea4c5a39bd` on `port/19`. `cherry-pick --continue` then stopped on the tests pick (`d7d66a4709b9`); see `notes/19/conflict-tests.md`.
