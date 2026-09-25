# Fork test relocations at LLVM 19

- `llvm/unittests/Support/RISCVISAInfoTest.cpp` → `llvm/unittests/TargetParser/RISCVISAInfoTest.cpp`. Existing relocated test tracked in data/fork-tests.txt; lit.sh selects TargetParserTests by source location. Round 1 executed it, with RiscvExtensionsHelp.CheckExtensions failing. No coverage removed.
