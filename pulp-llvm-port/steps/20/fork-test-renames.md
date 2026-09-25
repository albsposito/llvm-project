# Step20 fork test relocation

`clang/test/Misc/target-invalid-cpu-note.c` → `clang/test/Misc/target-invalid-cpu-note/riscv.c` for fork CPU expectation additions, following upstream39e3085a55880dbbc5aeddc3661342980d5e1467. LIT_PATHS now selects the complete `clang/test/Misc/target-invalid-cpu-note` directory: all16 successors retain all24 compiler commands and48 diagnostic assertions. See notes/20/conflict-tests.md. H003 baseline mapping requires every successor PASS.

Step19 replay settings archived before this change: steps/19/checkpoint-config.env and checkpoint-fork-tests.txt. No LLVM test is omitted.
