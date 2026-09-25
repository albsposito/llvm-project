# 20/conflict-clang-frep-pragma: retain FREP alongside LLVM 20 pragma handling

## What upstream changed

- `clang/include/clang/Basic/Attr.td` (both modified): upstream `380bb51b70b6d9f3da07a87f56fc3fe44bc78691`, "[HLSL] Adding Flatten and Branch if attributes with test fixes (#122157)", inserted HLSLControlFlowHint at the fork's Frep attribute insertion point.
- `clang/lib/Sema/SemaStmtAttr.cpp` (both modified): the same commit added HLSLControlFlowHint dispatch beside the fork's Frep dispatch.
- `clang/lib/Parse/ParsePragma.cpp` (both modified): `834dfd23155351c9885eddf7b9664f7697326946`, "[Parse] Remove ParseDiagnostic.h (#116496)", replaced the forwarding ParseDiagnostic.h header with Basic/DiagnosticParse.h.

## Why this is equivalent

Retained both complete attribute definitions and both Sema dispatch cases. Retained upstream's direct DiagnosticParse.h include and added the fork's FrepHint.h include; the removed forwarding header supplied exactly that same diagnostic header. All fork handler registration, removal, annotation parsing, diagnostics, and code generation remain intact. This is an insertion-point and header relocation merge, with no changed pragma behavior or vendor-extension redesign.

Validation: `git diff --check` passed; conflict-marker scan of the three paths found none. No build or tests were run, as required by the resolver SOP. No tests were edited.

## What breaks if this is wrong

Losing the Frep definition or dispatch would reject or fail to lower `#pragma frep infer`. Losing handler registration or parser diagnostics would change accepted pragmas or error reporting. Losing HLSL definitions or dispatch would regress upstream branch/flatten attributes; retaining the obsolete diagnostic include would fail compilation.

## Upstream reference

- Commit: `380bb51b70b6d9f3da07a87f56fc3fe44bc78691` [HLSL] Adding Flatten and Branch if attributes with test fixes (#122157).
- Commit: `834dfd23155351c9885eddf7b9664f7697326946` [Parse] Remove ParseDiagnostic.h (#116496).
- Reference code: `clang/include/clang/Basic/Attr.td:4361`, `clang/lib/Sema/SemaStmtAttr.cpp:664`, `clang/lib/Parse/ParsePragma.cpp:14` at `llvmorg-20.1.8`.
- Release notes: not inspected; causative commits verified using `git log -S` and `git show`.

Additional check: `git diff --cached --check` reports existing whitespace in the automatically applied fork hunks at ParseStmt.cpp:2589 and :2593. These are outside the three conflicted paths and were left untouched. The resolved paths pass the whitespace check.
