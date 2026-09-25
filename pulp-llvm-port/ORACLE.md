# Downstream oracle

Status: design only. `scripts/mix_diff.py` (check 5) is built and tested; the lane runner is not built yet (owner action in `PROGRESS.md`). Until it exists, a green step means "fork lit tests and upstream RISC-V tests pass", which cannot see a loop that still computes the right answer but lost its hardware-loop or SIMD code.

## Principle

Judge compiler output, never compiler code. The reference toolchain (the LLVM 18 fork, installed in Phase 0 at `toolchains/ref-18`) and the candidate (the step under test) build the same programs; the programs run on the same simulator; a script compares results.

## Lanes

| Lane | Exercises | Corpus | Simulator | Priority |
|---|---|---|---|---|
| Xpulpv2 | packed SIMD `pv.*`, hardware loops `lp.*`, post-increment `p.lw!`, MAC, `__builtin_pulp_*` | Deeploy kernel and network tests for Siracusa; pulp-nn XpulpV2 kernels | GVSoC | First: this is where the head commit's risk (v4i8/v2i16 legalization) lives |
| Snitch | SSR and SDMA builtins, `#pragma frep infer`, Xsmallfloat | `snitch_cluster` `sw/blas`, `sw/dnn`, `sw/tests` with their `verify.py` goldens | GVSoC, Verilator for final sign-off | Second. Open question: current `snitch_cluster` may have moved from the fork's builtins to inline asm since adopting the MC-only 22 toolchain; if so pin the corpus to a commit that still uses them (Deeploy's pinned `SNITCH_COMMIT_HASH e02cc9e3` is a candidate) |
| MemPool | Xmempool, scheduling model | `mempool` `software/apps` with `COMPILER=llvm` | Banshee | Optional |

Run lanes in Deeploy's image (`ghcr.io/pulp-platform/deeploy:main`), which carries pulp-sdk, snitch_cluster, GVSoC and Banshee at pinned commits; inject only the two toolchain directories.

## Checks per program

| # | Check | Pass rule |
|---|---|---|
| 1 | compiles and links | same exit status as reference |
| 2 | runs to completion | same exit code, no simulator trap |
| 3 | output | byte-identical result buffer, or within the test's own golden tolerance for float kernels |
| 4 | cycles | within 2% of reference; larger moves in either direction are flagged (an unexplained speed-up is a suspect too) |
| 5 | instruction mix | `scripts/mix_diff.py ref.dis cand.dis`: a PULP instruction family present in the reference and absent in the candidate FAILS; a family moving more than 10% is flagged |
| 6 | upstream conformance | covered by `scripts/lit.sh` at every step |

The lane runner emits one JSON row per program (`lane, program, compile, run, output, cycles_ref, cycles_cand, mix, verdict`) and exits 0 only when every row passes. A red row goes back to a worker with the objdump diff attached, and the worker may not touch the program or its golden.

## Blind spots

- Code no downstream program exercises: the fork's own lit tests are the only check there.
- GVSoC is instruction-accurate, not cycle-exact for every unit: cycle deltas are a smell, not a measurement.
- The reference defines correct by fiat: a miscompile already present in the 18 fork is reproduced faithfully and passes.

## Facts to record here when discovered

- Accepted `-march` spelling for the fork's extensions (Phase 0 step 5): `-march=rv32imc_xpulpv2` (verified 2026-09-24 with `toolchains/ref-18`; `a*b+c` at `-O2` compiles to `p.mac`).
- Deeploy image digest used, and the Deeploy / pulp-nn / snitch_cluster commits.
