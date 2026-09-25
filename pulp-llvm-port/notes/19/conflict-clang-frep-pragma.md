# Conflict: clang-frep-pragma (step 19)

Pick: `960965111088` "[pulp] clang-frep-pragma: #pragma frep parsing, attribute, codegen", applied onto `llvmorg-19.1.7` (stack from `port/18`, base `e6c3289804a6`), in `wt/int-19` on top of `432bf0bd9f64` (clang-builtins).

Merged cleanly: `clang/include/clang/Basic/AttrDocs.td` (`FrepDocs`), `clang/include/clang/Basic/TokenKinds.def`, `clang/include/clang/Parse/FrepHint.h` (new), `clang/include/clang/Parse/Parser.h`, `clang/lib/CodeGen/CGStmt.cpp`, `clang/lib/CodeGen/CodeGenFunction.h`, `clang/lib/Parse/ParsePragma.cpp`, `clang/lib/Parse/ParseStmt.cpp`. The fork's `handleFrepAttr` function in `SemaStmtAttr.cpp` also merged cleanly.

## Paths

| Path | Conflict type | Upstream change | Resolution |
|---|---|---|---|
| `clang/include/clang/Basic/Attr.td` | both modified (both sides added a new def right after `def LoopHint`) | `92fc1eb0c1ae` "[HLSL] add loop unroll (#93879)" added `def HLSLLoopHint : StmtAttr` at that spot | Kept both. Upstream's `HLSLLoopHint` stays unchanged, and the fork's `def Frep : Attr` (pragma spelling `frep`, enum arg `infer`, `AdditionalMembers`, `FrepDocs`) follows it, word for word. Pure ordering, no adaptation needed. |
| `clang/lib/Sema/SemaStmtAttr.cpp` | both modified (both sides added a `case` right after `AT_LoopHint` in `ProcessStmtAttribute`) | `92fc1eb0c1ae` (same commit) added `case ParsedAttr::AT_HLSLLoopHint: return handleHLSLLoopHintAttr(...)` | Kept both. Upstream's case comes first, then the fork's `case ParsedAttr::AT_Frep: return handleFrepAttr(S, St, A, Range);`, unchanged. |

## Checks

- `grep '^<<<<<<< '` (and `=======`, `>>>>>>>`) on both paths: no hits.
- `git diff --check` / `--cached --check`: no conflict markers. The only hits are two trailing-whitespace lines in `clang/lib/Parse/ParseStmt.cpp` (lines 2541 and 2545). They are part of the fork's original hunk and are carried over unchanged (not touched, per rule 9 / one-root-cause).
- No build (per SOP).

## Known build-phase item (not a conflict, not fixed here)

- `clang/lib/Parse/ParsePragma.cpp:1647` still calls `llvm::makeArrayRef(ValueList)`, which was removed upstream in `c70d3874e95b` "[ADT] Remove makeArrayRef and makeMutableArrayRef (#79719)". It needs `ArrayRef(ValueList)` (see steps/19/leads.md). This is for the build-fix phase.

## Result

Committed as `bce97b01d54c` on `port/19` (10 files, +295). `cherry-pick --continue` then stopped on the next pick, `a19538668ad2` "[pulp] clang-driver: target macros and driver flags" (conflict in `clang/include/clang/Driver/Options.td`). I left it untouched.
