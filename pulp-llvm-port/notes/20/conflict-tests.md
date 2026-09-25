# Step 20 tests conflict resolution

status: resolved

## Conflicts and upstream evidence

Paused pick: 1aa5cd982ae0c7670e7e74e51b46dfaaffe56ded, `[pulp] tests: fork-authored lit tests and pipeline expectations`.

- `clang/test/Misc/target-invalid-cpu-note.c`: deleted by us (upstream base), modified by incoming fork. Bounded `git log --follow --name-status llvmorg-19.1.7..llvmorg-20.1.8` identifies 39e3085a55880dbbc5aeddc3661342980d5e1467, `[clang][NFC] Split invalid-cpu-note tests (#104601)`. That commit splits all target tests into `clang/test/Misc/target-invalid-cpu-note/`; the exact fork successor is `clang/test/Misc/target-invalid-cpu-note/riscv.c`. Migrated both fork CPUs (`mempool-rv32`, `snitch`) into both RISCV32 and TUNE-RISCV32 contiguous SAME lists using upstream's anchored format. All four RUN lines, error assertions, upstream CPU entries and end-of-line anchors remain. RISCV64/TUNE-RISCV64 are unchanged. Accepted upstream removal of the obsolete aggregate only after verifying this split; other targets retain their upstream split tests. Conductor must use this exact successor in the fork manifest and the entire successor directory in LIT_PATHS to retain multi-target coverage.
- `llvm/test/CodeGen/RISCV/O0-pipeline.ll` and `O3-pipeline.ll`: both modified. e80d8e1b421b, `[RISCV] Insert simple landing pad before indirect jumps for Zicfilp. (#91860)`, adds Landing Pad Setup at the fork insertion point. Kept it followed by PULP pseudo expansion, SDMA expansion, SSR expansion, machine dominator/loop analyses, Snitch frep loops, refreshed analyses, PULP Hardware Loops, matching preserved `RISCVTargetMachine.cpp:619-624`. All other upstream pass lines remain; fork SSR reservations and hardware-loop fixup additions remain. No regeneration or speculative expectation changes.

## Validation

Verified every line of each HEAD upstream test is an ordered subsequence of its merged successor. Resolved-file staged diff whitespace check passes; unstaged `git diff --check` passes. No conflict markers remain in the three successor paths. No builds run, per resolver role.

Whole-pick staged whitespace check reports pre-existing incoming whitespace in riscv-sdma-intrinsics.c, nofdiv.ll, pulp-expand-pseudo.mir, pulp-select-pseudo.ll, ssr-pseudo-instructions.mir, ssr-register-merging.mir, xsmallfloat-inline-asm.ll, rv32xfrep-valid.s, xpulp-asm-parser.s. Those unrelated test files were left untouched.

## Complete upstream split mapping

All 24 old compiler commands are retained across the 16 successors (FileCheck prefixes renamed locally). Joining anchored SAME fragments reproduces the old diagnostic assertions; see verification caveat below. Preserve all successor tests in the baseline pass requirement.

- `clang/test/Misc/target-invalid-cpu-note/aarch64.c`: 2 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/amdgcn.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/arm.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/avr.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/bpf.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/hexagon.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/lanai.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/mips.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/nvptx.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/powerpc.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/r600.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/riscv.c`: 4 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/sparc.c`: 2 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/systemz.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/wasm.c`: 1 RUN command(s).
- `clang/test/Misc/target-invalid-cpu-note/x86.c`: 4 RUN command(s).

Pick continued successfully: tests commit `731ab8a6ac7e`; queued docs commit `94bbab7f1554` also applied, without further conflicts.

Split assertion verification caveat: the old AVR list lacked an end-of-line anchor; upstream split adds `{{$}}` (the only difference after reconstructing every old diagnostic list). Thus all 48 old error/note assertions are preserved, with the AVR list strengthened. The 24 compiler command strings before their FileCheck pipe compare identically across the split. Prefix changes are local naming only.
