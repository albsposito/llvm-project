# 20/F035: regen report (owner-approved list entries, not a CHECK regeneration)

Script and command used (one line per test file):

- None. No LLVM update script covers the expected-output string in a gtest. The two lines were added by hand under the owner pre-approval in task 20/F035 ("adding ONLY the new extension lines to extension-enumerating tests (RISCVISAInfoTest.cpp) — same process as 20/F017"), recorded in `notes/20/owner-test-exceptions.md`, section "F035 xpulpf16alt/xpulpfvec".

Per changed CHECK block (one row each; every block that changed must appear):

| Test file | Function / block | Class | Before (instructions) | After (instructions) | Explanation |
|---|---|---|---|---|---|
| `llvm/unittests/TargetParser/RISCVISAInfoTest.cpp` | `TEST(RiscvExtensionsHelp, CheckExtensions)` expected `-march` extension list | cosmetic | n/a (0 instructions) | n/a (0 instructions) | Adds exactly two rows, `xpulpf16alt          1.0` and `xpulpfvec            1.0`, in alphabetical position between `xmipslsp` and `xpulpv`, for the two new GAP9 extensions (`FeatureVendorXpulpf16alt`, `FeatureVendorXpulpfvec`). No other row changed. They are list entries, not code; there are no instructions to classify. |

Instruction-mix check for the whole file: not applicable (a unit test of the extension table, no generated code). Result: `TargetParserTests` 583/583 pass with the change (`logs/20-F035.verify.log`).
