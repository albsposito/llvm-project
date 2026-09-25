# Step20 ownership relocations

`llvm/lib/Target/RISCV/RISCVCallingConv.cpp` added to codegen-core ownership after upstream093b8bfe6b64 moved CC_RISCV from RISCVISelLowering.cpp. Resolver relocated two existing PULP hunks; notes/20/conflict-codegen-core.md and landed1ea0c09d95a9 record evidence. No source changes in this bookkeeping update.
