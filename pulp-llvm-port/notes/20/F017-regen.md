# 20/F017: regen report (owner-approved list entry, not a CHECK regeneration)

Script and command used (one line per test file):

- None. No LLVM update script covers the expected-output string in a gtest. The one line was added by hand under the owner exception recorded in `notes/20/owner-test-exceptions.md`, section "F017 xgap9" (2026-09-28).

Per changed CHECK block (one row each; every block that changed must appear):

| Test file | Function / block | Class | Before (instructions) | After (instructions) | Explanation |
|---|---|---|---|---|---|
| `llvm/unittests/TargetParser/RISCVISAInfoTest.cpp` | `TEST(RiscvExtensionsHelp, CheckExtensions)` expected `-march` extension list | cosmetic | n/a (0 instructions) | n/a (0 instructions) | Adds exactly one row, `xgap                 9.0`, in alphabetical position between `xfvecsingle` and `xmempool`, for the new GAP9 extension (`FeatureVendorXgap9`, name `xgap`, version 9.0 so that `-march=..._xgap9` parses). No other row changed. It is a list entry, not a code change; there are no instructions to classify. |

Instruction-mix check for the whole file: not applicable (a unit test of the extension table, no generated code).
