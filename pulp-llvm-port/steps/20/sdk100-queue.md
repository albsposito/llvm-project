# Queue: 100% GAP9 SDK compilation with LLVM

Owner request 2026-09-28: queue all work needed for 100% of the GCC-compilable SDK files (617, per `benchmarks/sdk-compile-survey/report.md`) to compile with our clang. The conductor launches each item when its dependencies have landed and its files are free, and reruns the survey after every milestone (M1-M4). Status is kept here and in BACKLOG.md.

Baseline: 209/617 (33.9%), survey 2026-09-28.

Checkpoint M1a (after F016 + F017, int-20 4851ef81477b): **476/617 = 77.1%** in both configurations (original flags + shim, and `-march=rv32imc_xgap9` without shim) — `benchmarks/sdk-compile-survey/checkpoint-M1-2026-09-28/report.txt`. Remaining 141: float16 types 132, clang-only implicit-declaration errors 7, missing trunch 1, ImgIO crash 1.

Checkpoint M3 (2026-09-29, int-20 d7c901b049e9, `-march=rv32imc_xgap9 -mPE=8`): **610/617 = 98.9%**; **609/609 = 100%** of the files GAP9 GCC compiles with the SDK's own -Werror flags. The 7 remaining failures are SDK bugs (implicit function declarations) that GCC also rejects under the SDK flags. Link readiness: 575/617 (32 objects need __truncsfbf2 (B133), 5 are silent false passes (B149), 1 needs OpenMP runtime (B150)) — `benchmarks/sdk-compile-survey/checkpoint-M3-2026-09-29/report.txt`.

Checkpoint M2a (2026-09-29, int-20 de8abd20c921, `-march=rv32imc_xgap9 -mPE=8`): **520/617 = 84.3%** (515 without -mPE) — `benchmarks/sdk-compile-survey/checkpoint-M2a-2026-09-29/report.txt`. Greedy path: f16abs2/f16altabs2 +39 (90.6%), fp32 builtins +16 (93.2%), other fp16 builtins +19 (96.3%), non-constant mulsN/clip Sema +11 (98.1%), implicit-decl flags +7 (99.2%), inline-asm SIMD 'r' operands (B131) +2, three one-file builtins +3 = 100%.

## Milestone M1 — PMSIS builtins and friends (expected ~77-80%)

| # | Item | Backlog | Depends on | Files / cluster | Status |
|---|---|---|---|---|---|
| 1 | Two PMSIS builtins | B87 | — | clang-builtins, intrinsics, insn-tablegen | landed (20/F016, 4851ef81477b) |
| 2 | CoreCount compile-time constant (-mPE) + run-time offset bug + `CoreCount_m1` (spec batch F) | B91, B107 | — | clang-driver, clang-builtins | done (20/F018, de8abd20c921) |
| 3 | `__builtin_shuffle` | B92 | — | clang-builtins (CGBuiltin), codegen-core | done (20/F019) |
| 4 | Hardware-loop crash on ImgIO.c (+B71) | B88 | — | passes (PULPHardwareLoops.cpp) | done (20/F020) |
| 5 | SDK build flags matching GCC 7 leniency: `-Wno-error=implicit-function-declaration,int-conversion` (+ other clang-only -Werror diagnostics) in the SDK clang toolchain file and a survey mode that uses them | survey step 5 | — | benchmarks/sdk-clang, benchmarks/sdk-compile-survey (harness only) | done 2026-09-29 (run.py modes gccsdk/sdkflags/sdknowerror/parity; wrapper policy in benchmarks/sdk-clang; db phase fixed) |
| 6 | Survey rerun M1 | — | 1-5 landed | harness | done (M1a 476/617, M2a 520/617) |

## Milestone M2 — remaining non-fp16 builtins and Sema (expected ~80-83%)

| # | Item | Backlog | Depends on | Files / cluster | Status |
|---|---|---|---|---|---|
| 7 | Builtins batch A: 7 f32 scalar (f32max/min/abs/sqrt, rintsf2, rdownsf2, rupsf2) | B97 | 1 landed | clang-builtins, intrinsics/codegen | done (20/F036, 271b0c142ccb) |
| 8 | Builtins batch C: 11 mulf*/macf* aliases, mul64hs/hu/hus, trunch, truncb | B97 | 1 landed | clang-builtins | done (20/F037, 4b76df2c70d0) |
| 9 | Builtins batch B: 10 GAP9 complex/divN builtins, 16 new instructions gated on xgap9 | B97 | 1 landed (F017 landed) | insn-tablegen, mc, clang-builtins | done (20/F038, 107b802911c5) |
| 10 | Accept non-constant mulsN / clip / clipu arguments as GCC does (with a correct fallback sequence) | B93 (Sema part) | 1, 2, 3 landed | clang-builtins (SemaRISCV), codegen | done (20/F043, 7ddac1d3b507: deferred post-optimisation check, as GCC) |
| 11 | Hardware-loop crash on tlv320 driver at -Os | B108 | 4 landed | passes (PULPHardwareLoops.cpp) | queued |
| 12 | Survey rerun M2 | — | 7-11 landed | harness | queued |

## Milestone M3 — half precision (expected ~95-98%)

Design: `benchmarks/fp16-design/design.md`; owner decisions D5, D6.

| # | Item | Depends on | Files / cluster | Status |
|---|---|---|---|---|
| 13 | T0+T1: xgap9 implies Zhinx; register bfloat16 and packed-fp16 extensions | F017, F021 landed | registration | done (20/F035) |
| 14 | T4: clang knows the SDK type names `float16` (= `_Float16`) and `float16alt` (= `__bf16`), predefined macros, HasFullBFloat16 under the new extension, per-op rounding (`-fbfloat16-excess-precision=none` behaviour) for GCC equivalence | 13 | clang-driver (Targets/RISCV.cpp), maybe clang Basic | queued |
| 15 | T2: MC definitions of the GAP9 GPR-operand scalar `.ah` and vector `.h`/`.ah` instructions (from GVSoC isa_smallfloats.py), separate decoder namespace from Snitch (B96) | 13 | insn-tablegen (new RISCVInstrInfoXpulpfloat.td), mc | queued |
| 16 | T3: scalar bfloat16 codegen in GPRs (legal ops, patterns, calling convention, libcalls, `(int)float16alt` rounds like GCC per D6) | 13, 15 | codegen-core, insn-tablegen | queued |
| 17 | T5a: packed v2f16/v2bf16 arithmetic, vfmac, splat .r forms, post-increment, misaligned rule (keep F021's answer) | 15, 16 | codegen-core, insn-tablegen | queued |
| 18 | T5b: packed fp16 shuffles/pack/extract/insert/compare (lane convention per B99/Q2), v2h shuffles via F019's path (B115) | 17, 3 | codegen-core | queued |
| 19 | T6: 26 fp16 builtins (spec batches D, E1-E3) | 16, 17, 7-9 | clang-builtins, intrinsics | done for the SDK-blocking set: f16abs2/f16altabs2 (20/F041, e7f97bbd0f05) and 12 others (20/F042, d7c901b049e9); native .ah/vf* codegen stays with T3/T5 |
| 20 | T7: GCC mixed float16/float16alt promotion and varargs double promotion (owner-approved, D6) | 14 | clang Sema (SemaExpr.cpp, Upstream-File-Edit) | queued |
| 21 | Survey rerun M3 + T8 acceptance: bit-exact GVSoC runs of CNN_MatMul_Conv_fp16.c, MatMulDSP.c, DftLibraryf16a.c vs GCC | 14-20 | harness | queued |

## Milestone M4 — the tail (target 100%)

| # | Item | Depends on | Status |
|---|---|---|---|
| 22 | Diagnose the 5 files the survey could not attribute (fp16 cases the probe could not separate) and any file still failing after M3 | research now; fixes after M3 | research queued now |
| 23 | Fix every new back-end failure bucket the M1-M3 reruns expose (one task per root cause) | reruns | queued |
| 24 | Generated AutoTiler/NNTool kernels (`*Kernels.c`, not in the 617): generate them via the SDK flow (benchmarks/sdk-clang) and compile with clang | M3 | queued |
| 25 | Final survey + SDK app ladder rerun (build, link, run on GVSoC vs GCC) | all | queued |

Related but not required for compilation (tracked in BACKLOG): B104 (-mrelax loop relocs, F031), B109 (assembler syntax, F034), B110/B105 (relocation clashes), B111 (SDK-side integration issues) — needed for building whole SDK apps with an all-LLVM toolchain.
