# Xpulpv2: LLVM 19 port versus LLVM 18

Measured 2026-09-25. **No code-size or emitted-code regression appeared in the ten straight-line kernels: their `.text` bytes are identical between compilers at both O2 and O3. However, all five C loop kernels crash in both versions.** This is a static comparison, not a runtime performance or functional-correctness certification.

## Scope and results

The corpus contains 15 small, standalone C functions created for this benchmark: packed 4×8-bit and 2×16-bit addition and shifts, signed packed maximum, 8/16-bit accumulated dot products, bit extraction/popcount, scalar MAC, scalar sum/copy loops, packed addition loop, and two packed dot-product loops. Every function is compiled separately; failures are retained rather than omitted from the results. These synthetic kernels are not Deeploy or pulp-nn application benchmarks.

| C corpus result, per optimization level | LLVM 18 | LLVM 19 |
|---|---:|---:|
| Compiled functions, O2 and separately O3 | 10/15 | 10/15 |
| Sum of successful function sizes | 74 bytes | 74 bytes |
| Static instructions in successful functions | 25 | 25 |
| Crashing loop functions | 5 | 5 |

All 20 successful cross-version pairs (ten functions × two optimization levels) have byte-identical `.text`, verified with the same `llvm-objcopy`. The code includes `pv.add.b/h`, `pv.srl.b/h`, `pv.max.b`, `pv.sdotsp.b/h`, `p.mac`, `p.extractu`, and `p.cnt`. The instruction numbers above count static instructions once; they are not dynamically executed counts or cycles.

The five unsigned dynamic-trip-count loops (`sum_loop`, `copy_loop`, `dot8_loop`, `dot16_loop`, `packed_add8_loop`) cause a compiler child-process segmentation fault in `PULPHardwareLoops::convertToHardwareLoop` on **both** versions, at **both** optimization levels. Clang returns status 1 and diagnoses frontend exit code 139. This gives 20 failed version/optimization/function combinations. The crashes establish an inherited practical limitation beyond the existing green lit suite; their exact root cause has not been diagnosed here. No pass was disabled to hide these failures. Sources and complete diagnostics are preserved in `sources/` and the four compiler/optimization directories.

## Supplemental existing hardware-loop corpus

To measure paths that successfully reach hardware-loop lowering, both `llc` binaries also compile the exact `xpulp-hwloop.ll` from `port/18`, copied unchanged into this directory. Both receive `-O=2 -march=riscv32 -mattr=+xpulpv -filetype=obj`. Its existing per-function target attributes are retained; this is a separate backend corpus, not the C frontend measurement.

| Metric | LLVM 18 | LLVM 19 |
|---|---:|---:|
| Functions compiled | 7 | 7 |
| Sum of function sizes | 446 bytes | 438 bytes |
| Static instructions, including compressed instructions | 157 | 155 |
| Hardware-loop instructions | 8 | 8 |
| Postincrement memory instructions | 4 | 4 |
| `strcmp` function size | 42 bytes | 34 bytes |

All six counted-loop functions have unchanged sizes. Only `strcmp` changes: LLVM 19 removes two `p.extbz` instructions. Inspection shows that the compared/subtracted value is supplied by unsigned byte loads (`lbu` / `p.lbu`), making redundant zero-extension removal a plausible explanation. **This interpretation is not execution-based correctness proof.** The strict existing `mix_diff.py` oracle reports **FAIL**, because the bitmanip family falls from two instructions to zero in this corpus; the report preserves that verdict in `hwloop-mix.json`. Hardware loops and postincrement families both report OK. The separate bit-extract/count microkernels retain their PULP instructions, so this is not evidence that all bitmanip selection disappeared.

## Compile-time measurements

Seven paired repetitions follow the initial compilation warmup. Compiler order alternates on each repetition; jobs run serially. Reported values sum the median wall time of each of the ten successful single-function compilations, including process startup. Raw samples are in `results.json`.

| Optimization | LLVM 18 | LLVM 19 | Difference |
|---|---:|---:|---:|
| O2 | 111.14 ms | 115.68 ms | +4.1% |
| O3 | 110.28 ms | 115.69 ms | +4.9% |

These tiny compilations are mostly startup and fixed overhead. The host is shared with ongoing LLVM port builds, is not CPU-isolated, and no frequency controls or statistical significance test were applied. Treat these timings as reproducibility diagnostics; they do not establish a compiler-throughput regression. Both builds have assertions enabled and use Release configuration.

## Revisions, flags and reproduction

- LLVM 18: `port/18`, `1c33bd3dba2bd1f3942842135daba498af1b3eb5`, reports clang 18.1.4; `toolchains/ref-18/bin`.
- LLVM 19: `port-19-green`, `9b2edaf923ad46816535d7361e9daef79be0529c`, reports clang 19.1.7; `build/int-19/bin`.
- Identical C flags: `--target=riscv32-unknown-elf -march=rv32imc_xpulpv2 -mabi=ilp32 -ffreestanding -fno-builtin`, plus either `-O2` or `-O3`, then `-c`. No CPU tuning override or LTO.
- Same LLVM 19 disassembler for both objects, with `--mattr=+xpulpv,+c`; same LLVM 18 `llvm-nm` and `llvm-objcopy` for sizes/byte comparisons. Explicit `+c` ensures compressed instructions are decoded rather than dropped as unknown.
- C sources and hashes, compiler versions, raw timings and mnemonic histograms: `results.json`. Exact expanded commands: `commands.json`; supplemental commands and source hash: `supplement.json`.

From this directory, run:

```sh
python3 run.py
python3 supplement.py
python3 analyze.py
```

`run.py` intentionally records compile failures and continues. `supplement.py` intentionally preserves `mix_diff.py` FAIL as data rather than aborting before writing its result; inspect `hwloop-mix.json`. `analyze.py` checks the observed 20 byte-identical successful pairs; a future changed result fails that check. Reruns overwrite measured artifacts; the prose timing table describes this recorded run.

## Limits and follow-up

No GVSoC, Spike, QEMU RISC-V, or PULP runner was found on PATH; no installed downstream corpus or simulator was found under the available home/opt locations. ORACLE.md describes an unimplemented simulator lane. No native execution, linked firmware, result buffers, correctness checks or cycle measurements were run. Identical code reproduces whatever behavior the reference already had; it cannot prove that behavior is correct.

Next useful work is to diagnose the shared loop crash, independently inspect the `strcmp` change, and run representative downstream applications on an actual Xpulpv2-compatible simulator or hardware. The current evidence supports preservation of these successful packed-SIMD primitives, not a claim that LLVM 19 is faster or that the whole Xpulpv2 workload space is regression-free.
