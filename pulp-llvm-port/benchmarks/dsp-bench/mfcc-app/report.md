> **Correction, 2026-10-06 (board result, backlog B151).** The results this report marks as GCC "wrong" for float16/float16alt (RFFT, IRFFT, and GCC's low float16 MFCC accuracy) are a GVSoC simulator bug, not a GCC bug. On a real GAP9 board, `vfmre.h`/`vfmre.ah` compute `a*b - rd`, which is what GCC assumes; GVSoC computes `rd - a*b`. Test: `benchmarks/board-pack/t8_vfmre_sign_b151`. GCC's float16 results on the simulator are therefore not valid for those kernels; clang's results are unaffected (clang does not emit vfmre and is judged against the host reference).

# MFCC application benchmark: our clang vs GAP9 GCC

Run on 2026-10-06. Everything here is on the GVSoC simulator, one core. Nothing was measured on silicon.

## Headline

An MFCC front-end (the standard keyword-spotting feature extractor) built from the GAP9 SDK's own DSP kernels, run on the SDK clip `yes.wav` (1 s, 96 frames).

| variant | correct with clang? | cycles per frame, clang / GCC, -O2 | -O3 | clang / GCC ratio (O2, O3) | % of one core at 370 MHz (assumed), clang / GCC, -O2 |
|---|---|---|---|---|---|
| fixed-point (fix16) | yes, bit-exact with GCC and with the host build | 33084 / 32792 | 33003 / 32597 | 1.009, 1.012 | 0.89% / 0.89% |
| float32 | yes; 553 of 1248 outputs differ from GCC in the last bits (largest difference 6.1e-5 dB on values up to a few hundred) | 40820 / 36906 | 40051 / 36747 | 1.106, 1.090 | 1.10% / 1.00% |
| float16 | **does not link** as the SDK wires it (missing builtin, B149). With the SDK's alternative log kernel it runs and is correct | 42564 / 29102 (experiment) | 41986 / 27193 | 1.463, 1.544 | 1.15% / 0.79% |
| float16alt (bfloat16) | **does not link** (B133 `__truncsfbf2`, and B149). With compiler-rt's `__truncsfbf2` linked in it runs and is correct, but 24x slower | 705760 / 29102 (experiment) | 701894 / 27193 | 24.3, 25.8 | 19.1% / 0.79% |

- **Fixed-point: parity.** Clang is 1% slower than GCC and produces the same bits.
- **float32: clang is 9-11% slower.** About half of that is a default-flag difference (GCC fuses multiply-adds across C statements, clang only inside one expression). With `-ffp-contract=fast` clang is 3-5% slower. The rest is missing post-increment addressing.
- **float16: clang is about 1.5x slower**, because it has no packed (2-lane) float16 code generation; GCC uses `vfmul.h`, `vfmac.h`, `vfadd.h`.
- **bfloat16: not usable yet.** Clang does every bfloat16 operation in float32 and calls a software routine to round the result.
- **Code size** of the MFCC kernels: clang is 14-18% larger at -O2 for fix16/float32, 35% larger for float16, and 40-50% larger at -O3.
- **-Os is a clang win**: GCC -Os gives up hardware loops, clang -Os does not. Clang needs 0.59x (fix16) and 0.69x (float32) of GCC's cycles.
- **One wrong result was found, and it is not in clang:** the GCC build of the float16 and bfloat16 FFT gives wrong numbers on GVSoC (`vfmre.h`, see Findings). GCC's float16 output is therefore not used as an oracle; clang's float16 output is checked against the host build and the numpy reference instead.

## What was built

**Pipeline per frame:** pre-emphasis (0.97) -> Hann window -> real FFT (512) -> power spectrum (257 bins) -> mel filterbank (40 bands, Slaney) -> log (10 log10, i.e. dB) -> DCT-II, orthonormal (13 coefficients).

**Parameters** follow the SDK example `examples/gap9/dsp/nntool/Mfcc`: 16 kHz, 512-sample frame, 160-sample hop, n_fft 512, Hann window, power 2, log clip 1e-10 (1e-7 for float16, as the example's script does). Two choices differ from the example: 40 mel bands and 13 coefficients (the example uses librosa's default 128 bands and 40 coefficients), and a 0.97 pre-emphasis stage (the example passes 0, which skips the kernel). 96 frames are processed, the same count as the example's `main.c` computes for this clip.

**Kernels.** Every stage is an unmodified SDK DSP library function from `tools/autotiler_v3/BasicKernels/DSP_Libraries`, called through its parallel entry point with one core (`gap_ncore()` is 1 in the shim), in the order the SDK's AutoTiler generator wires them (`Generators/DSP_Generators/DSP_Generators.c`):

| stage | fix16 | float32 (float16 and float16alt: same names with `_f16` / `_f16a`) |
|---|---|---|
| pre-emphasis | `PreEmphasis` | `PreEmphasis_f32` |
| window | `WindowingReal2Real_Fix16` | `WindowingReal2Real_f32` |
| real FFT | `RFFT_DIF_Par_Fix16` (radix-4 256-point complex FFT, bit-reverse swap, RFFT post-processing) | `RFFT_DIF_Par_f32` |
| power spectrum | `CmplxMagSquared_Fix16` | `CmplxMagSquared_f32` |
| mel filterbank | **app glue** `MelFilterBank_Fix32_app` | `MelFilterBank_f32` |
| log | **app glue** `LogDb_Fix_app`, which calls the SDK's `ulogn_17_15` | `Db_f32` |
| DCT | `DctTypeII_Fix16` | `DctTypeII_f32` |

**Two fixed-point stages are not SDK kernels.** This SDK release has no fixed-point mel filterbank and no fixed-point log kernel. The generator still names `MelFilterBank_Fix32` and `MFCC_ComputeLog_Fix32`, but no library source defines them. The fixed-point variant therefore uses two small functions in `src/mfcc_app.c`, written in the style of `MelFilterBank_f32`. They are compiled by both compilers like the kernels. Their numbers measure the compilers on plain C, not on SDK code.

**Tables.** NNTool and the AutoTiler code generator are in the SDK tree but are not installed on this host (no `nntool` Python package, no librosa), so:
- FFT twiddles, RFFT twiddles and the bit-reverse table are the **SDK's own** `DSP_Libraries/TransformFunctions/LUT_Tables/*.c`, compiled unmodified.
- The window, the sparse mel filterbank and the DCT table are generated by `gen_tables.py` (pure Python) from the formulas in the SDK's `SetupLUT.py` and librosa, and written to `gen/mfcc_tables.h`, together with the wav samples as a C array.

**Compilers.**
- clang: `clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)` (wt/int-20 26e7268c3127 (snapshot of build/int-20, 2026-10-06)), flags `--target=riscv32-unknown-elf -march=rv32imc_xgap9 -mPE=8 -mabi=ilp32 -mno-relax`
- GCC: `riscv32-unknown-elf-gcc (GCC) 7.1.1 20170509`, flags `-march=rv32imcxgap9 -mPE=8 -mFC=1`
- Both: `-D__GAP9__`, the SDK DSP include paths, and the shim `shim/at_api.h` (the gap9-sweep shim plus stubs for the L2 DMA-copy names that `FftLibrary*.c` needs to compile; that function is never called).
- The application file and the memcpy/memset file also get `-ffreestanding -fno-builtin`, as the gap9-sweep drivers do. The SDK kernel files get no extra flags.
- Link: GCC with its own ld; clang with `ld.lld` and GAP9 GCC's `libgcc.a`.

**Harness.** `benchmarks/gap9-sweep/sim` (crt0.S, link.ld, bench.h, run_sim.sh; GVSoC2 `ri5ky_testbench`, one RI5CY core) and `benchmarks/gap9-sweep/runtime` (rt.h, rt_libc.c), unchanged. Each stage is bracketed by the simulator cycle counter and the RI5CY instruction counter. Hashing, input conversion and printing run outside the timed regions. "Cycles per frame" is the sum of the seven stages, averaged over the 96 frames.

## Results

### Table 1. Cycles per frame, clang vs GCC

One frame = 512 samples in, 13 MFCCs out. Mean over the 96 frames of the clip. "ratio" is clang / GCC; below 1 means clang is faster.

| configuration | opt | clang cycles | GCC cycles | ratio | clang instrs | GCC instrs | ratio |
|---|---|---:|---:|---:|---:|---:|---:|
| fix16 | O2 | 33084 | 32792 | 1.009 | 28698 | 27629 | 1.039 |
| fix16 | O3 | 33003 | 32597 | 1.012 | 28643 | 27789 | 1.031 |
| fix16 | Os | 33333 | 56217 | 0.593 | 28961 | 42005 | 0.689 |
| f32 | O2 | 40820 | 36906 | 1.106 | 37312 | 34286 | 1.088 |
| f32 | O3 | 40051 | 36747 | 1.090 | 36695 | 34202 | 1.073 |
| f32 | Os | 40825 | 59164 | 0.690 | 37317 | 48844 | 0.764 |
| f16 | O2 | does not link: `__builtin_pulp_v2hitov2hf_u` (B149) | 28849 | - | - | 26486 | - |
| f16 | O3 | does not link: `__builtin_pulp_v2hitov2hf_u` (B149) | 26962 | - | - | 24727 | - |
| f16 | Os | does not link: `__builtin_pulp_v2hitov2hf_u` (B149) | 60934 | - | - | 48837 | - |
| f16a | O2 | does not link: `__builtin_pulp_v2hitov2hf_u` (B149), `__truncsfbf2` (B133) | 28987 | - | - | 26624 | - |
| f16a | O3 | does not link: `__builtin_pulp_v2hitov2hf_u` (B149), `__truncsfbf2` (B133) | 27080 | - | - | 24845 | - |
| f16a | Os | does not link: `__builtin_pulp_v2hitov2hf_u` (B149), `__truncsfbf2` (B133) | 61054 | - | - | 48957 | - |
| f16+logf32 | O2 | 42564 | 29102 | 1.463 | 40232 | 26699 | 1.507 |
| f16+logf32 | O3 | 41986 | 27193 | 1.544 | 39803 | 24920 | 1.597 |
| f16+logf32 | Os | 42560 | 61548 | 0.691 | 40232 | 49273 | 0.817 |
| f16a+logf32 | O2 | does not link: `__truncsfbf2` (B133) | 29102 | - | - | 26699 | - |
| f16a+logf32 | O3 | does not link: `__truncsfbf2` (B133) | 27193 | - | - | 24920 | - |
| f16a+logf32 | Os | does not link: `__truncsfbf2` (B133) | 61548 | - | - | 49273 | - |
| f16a+logf32+rt | O2 | 705760 | 29102 | 24.251 | 548976 | 26699 | 20.562 |
| f16a+logf32+rt | O3 | 701894 | 27193 | 25.812 | 545949 | 24920 | 21.908 |
| f16a+logf32+rt | Os | 705834 | 61548 | 11.468 | 548887 | 49273 | 11.140 |
| f32+contract | O2 | 38567 | 36906 | 1.045 | 35367 | 34286 | 1.032 |
| f32+contract | O3 | 37943 | 36747 | 1.033 | 34886 | 34202 | 1.020 |
| f32+contract | Os | 38570 | 59164 | 0.652 | 35370 | 48844 | 0.724 |
| f16+logf32+contract | O2 | 42099 | 29102 | 1.447 | 39019 | 26699 | 1.461 |
| f16+logf32+contract | O3 | 41522 | 27193 | 1.527 | 38588 | 24920 | 1.548 |
| f16+logf32+contract | Os | 42095 | 61548 | 0.684 | 39019 | 49273 | 0.792 |

Configurations other than fix16, f32, f16 and f16a are labelled experiments:

- **f16+logf32**: log stage = SDK Db_f16_f32; linked with --gc-sections.
- **f16a+logf32**: log stage = SDK Db_f16a_f32; linked with --gc-sections.
- **f16a+logf32+rt**: log stage = SDK Db_f16a_f32; linked with --gc-sections; clang also links compiler-rt's truncsfbf2.c (B133 workaround). The GCC column is the f16a+logf32 GCC build.
- **f32+contract**: clang built with -ffp-contract=fast (GCC default behaviour); GCC unchanged.
- **f16+logf32+contract**: log stage = SDK Db_f16_f32; linked with --gc-sections; clang built with -ffp-contract=fast; GCC unchanged.

### Table 2. Correctness (O2; O3 and Os give the same MFCC bits as O2 for every compiler and configuration)

SNR and correlation are over all 96 x 13 output values. "numpy ref" is the float64 reference (ref_mfcc.py).

| configuration | compiler | MFCC checksum | vs GCC O2 | first stage that differs from GCC | vs host build | SNR vs numpy ref (dB) | corr vs numpy ref |
|---|---|---|---|---|---|---:|---:|
| fix16 | clang | 0xe81c221f | bit-exact | - | bit-exact | 29.75 | 0.999522 |
| fix16 | gcc | 0xe81c221f | (reference) | - | bit-exact | 29.75 | 0.999522 |
| f32 | clang | 0x2f96782c | 553/1248 values differ, SNR 146.74 dB, max diff 6.1e-05 | rfft | 1157/1248 values differ, SNR 131.38 dB, max diff 0.000168 | 115.88 | 1.0 |
| f32 | gcc | 0x34caedde | (reference) | - | 1155/1248 values differ, SNR 131.46 dB, max diff 0.000168 | 115.86 | 1.0 |
| f16 | clang | does not link: `__builtin_pulp_v2hitov2hf_u` (B149) | - | - | - | - | - |
| f16 | gcc | 0xc3fd2f9b | (reference) | - | 1248/1248 values differ, SNR 12.76 dB, max diff 104 | 10.06 | 0.971778 |
| f16a | clang | does not link: `__builtin_pulp_v2hitov2hf_u` (B149), `__truncsfbf2` (B133) | - | - | - | - | - |
| f16a | gcc | 0xc85e2923 | (reference) | - | 1248/1248 values differ, SNR 5.28 dB, max diff 316 | 12.52 | 0.969459 |
| f16+logf32 | clang | 0xa7d23918 | 1248/1248 values differ, SNR 12.25 dB, max diff 97.4 | rfft | - | 32.6 | 0.999732 |
| f16+logf32 | gcc | 0x4454866c | (reference) | - | - | 12.51 | 0.968804 |
| f16a+logf32 | clang | does not link: `__truncsfbf2` (B133) | - | - | - | - | - |
| f16a+logf32 | gcc | 0x94b17807 | (reference) | - | - | 12.51 | 0.969373 |
| f16a+logf32+rt | clang | 0x0048e8a5 | - | - | - | 32.46 | 0.999725 |
| f32+contract | clang | 0xd400c496 | 1007/1248 values differ, SNR 134.77 dB, max diff 9.92e-05 | rfft | 1161/1248 values differ, SNR 131.03 dB, max diff 0.000192 | 115.89 | 1.0 |
| f32+contract | gcc | 0x34caedde | (reference) | - | 1155/1248 values differ, SNR 131.46 dB, max diff 0.000168 | 115.86 | 1.0 |
| f16+logf32+contract | clang | 0xa804ff7c | 1247/1248 values differ, SNR 12.25 dB, max diff 97.8 | rfft | - | 32.59 | 0.999732 |
| f16+logf32+contract | gcc | 0x4454866c | (reference) | - | - | 12.51 | 0.968804 |

Host build (x86-64 gcc -O0, the same C sources) against the numpy reference:

| variant | SNR (dB) | correlation | max abs diff |
|---|---:|---:|---:|
| f16 | 9.53 | 0.950618 | 120 |
| f16a | 1.25 | 0.902886 | 323 |
| f32 | 115.85 | 1.0 | 0.000636 |
| fix16 | 29.75 | 0.999522 | 16.6 |

### Table 3. Cycles per frame by stage

**-O2** (clang / GCC / ratio)

| stage | fix16 | f32 | f16+logf32 | f16a+logf32+rt | f32+contract | f16+logf32+contract |
|---|---|---|---|---|---|---|
| preemph | 7133 / 8787 / **0.81** | 3105 / 2592 / **1.20** | 3107 / 2594 / **1.20** | 63181 / 2594 / **24.36** | 3103 / 2592 / **1.20** | 3106 / 2594 / **1.20** |
| window | 2593 / 2586 / **1.00** | 3105 / 2586 / **1.20** | 4130 / 2586 / **1.60** | 22613 / 2586 / **8.74** | 3105 / 2586 / **1.20** | 4130 / 2586 / **1.60** |
| rfft | 13039 / 11862 / **1.10** | 26747 / 25134 / **1.06** | 26566 / 16741 / **1.59** | 488633 / 16741 / **29.19** | 24536 / 25134 / **0.98** | 26532 / 16741 / **1.58** |
| spectrum | 1051 / 1046 / **1.00** | 1823 / 1303 / **1.40** | 1822 / 1560 / **1.17** | 30737 / 1560 / **19.70** | 1823 / 1303 / **1.40** | 1822 / 1560 / **1.17** |
| mel | 5625 / 4964 / **1.13** | 3020 / 2862 / **1.06** | 3510 / 2863 / **1.23** | 54112 / 2863 / **18.90** | 3020 / 2862 / **1.06** | 3510 / 2863 / **1.23** |
| log | 2298 / 2488 / **0.92** | 687 / 608 / **1.13** | 806 / 685 / **1.18** | 2307 / 685 / **3.37** | 647 / 608 / **1.06** | 766 / 685 / **1.12** |
| dct | 1345 / 1059 / **1.27** | 2333 / 1821 / **1.28** | 2623 / 2073 / **1.27** | 44176 / 2073 / **21.31** | 2333 / 1821 / **1.28** | 2233 / 2073 / **1.08** |
| total | 33084 / 32792 / **1.01** | 40820 / 36906 / **1.11** | 42564 / 29102 / **1.46** | 705760 / 29102 / **24.25** | 38567 / 36906 / **1.05** | 42099 / 29102 / **1.45** |

**-O3** (clang / GCC / ratio)

| stage | fix16 | f32 | f16+logf32 | f16a+logf32+rt | f32+contract | f16+logf32+contract |
|---|---|---|---|---|---|---|
| preemph | 7131 / 8765 / **0.81** | 3105 / 2591 / **1.20** | 3107 / 2594 / **1.20** | 63181 / 2594 / **24.36** | 3103 / 2591 / **1.20** | 3106 / 2594 / **1.20** |
| window | 2593 / 2583 / **1.00** | 3105 / 2584 / **1.20** | 4130 / 1335 / **3.09** | 22613 / 1335 / **16.94** | 3105 / 2584 / **1.20** | 4130 / 1335 / **3.09** |
| rfft | 12990 / 11776 / **1.10** | 25949 / 24940 / **1.04** | 26033 / 16576 / **1.57** | 484864 / 16576 / **29.25** | 23883 / 24940 / **0.96** | 26000 / 16576 / **1.57** |
| spectrum | 1051 / 1045 / **1.01** | 1823 / 1304 / **1.40** | 1822 / 1068 / **1.71** | 30737 / 1068 / **28.78** | 1823 / 1304 / **1.40** | 1822 / 1068 / **1.71** |
| mel | 5625 / 4963 / **1.13** | 3098 / 2863 / **1.08** | 3508 / 2863 / **1.23** | 54112 / 2863 / **18.90** | 3098 / 2863 / **1.08** | 3508 / 2863 / **1.23** |
| log | 2298 / 2407 / **0.95** | 687 / 609 / **1.13** | 806 / 684 / **1.18** | 2307 / 684 / **3.37** | 647 / 609 / **1.06** | 766 / 684 / **1.12** |
| dct | 1315 / 1058 / **1.24** | 2284 / 1856 / **1.23** | 2580 / 2073 / **1.24** | 44079 / 2073 / **21.26** | 2284 / 1856 / **1.23** | 2190 / 2073 / **1.06** |
| total | 33003 / 32597 / **1.01** | 40051 / 36747 / **1.09** | 41986 / 27193 / **1.54** | 701894 / 27193 / **25.81** | 37943 / 36747 / **1.03** | 41522 / 27193 / **1.53** |

GCC-only variants (clang does not link them), cycles per frame by stage at -O2 / -O3:

| stage | f16 | f16a | f16a+logf32 |
|---|---|---|---|
| preemph | 2594 / 2594 | 2594 / 2594 | 2594 / 2594 |
| window | 2585 / 1335 | 2585 / 1335 | 2586 / 1335 |
| rfft | 16741 / 16576 | 16741 / 16576 | 16741 / 16576 |
| spectrum | 1560 / 1068 | 1560 / 1068 | 1560 / 1068 |
| mel | 2863 / 2863 | 2863 / 2863 | 2863 / 2863 |
| log | 434 / 454 | 572 / 572 | 685 / 684 |
| dct | 2072 / 2072 | 2072 / 2072 | 2073 / 2073 |
| total | 28849 / 26962 | 28987 / 27080 | 29102 / 27193 |

### Table 4. Real-time headroom

Formula: cycles per second of audio = cycles per frame x 16000 / 160 (100 frames per second). Core fraction = that / (f_clk in Hz). **Assumed clock: 370 MHz**, the value the SDK Mfcc example sets (`FREQ_CL` in its CMakeLists.txt). It is an assumption, not a measurement: to rescale, multiply the percentage by 370 / (your MHz).

| configuration | opt | compiler | cycles per s of audio | % of one core at 370 MHz | x faster than real time |
|---|---|---|---:|---:|---:|
| fix16 | O2 | clang | 3308369 | 0.89% | 112 |
| fix16 | O2 | gcc | 3279231 | 0.89% | 113 |
| fix16 | O3 | clang | 3300251 | 0.89% | 112 |
| fix16 | O3 | gcc | 3259725 | 0.88% | 114 |
| f32 | O2 | clang | 4082000 | 1.10% | 91 |
| f32 | O2 | gcc | 3690600 | 1.00% | 100 |
| f32 | O3 | clang | 4005100 | 1.08% | 92 |
| f32 | O3 | gcc | 3674700 | 0.99% | 101 |
| f16 | O2 | gcc | 2884900 | 0.78% | 128 |
| f16 | O3 | gcc | 2696200 | 0.73% | 137 |
| f16a | O2 | gcc | 2898700 | 0.78% | 128 |
| f16a | O3 | gcc | 2708000 | 0.73% | 137 |
| f16+logf32 | O2 | clang | 4256400 | 1.15% | 87 |
| f16+logf32 | O2 | gcc | 2910200 | 0.79% | 127 |
| f16+logf32 | O3 | clang | 4198600 | 1.13% | 88 |
| f16+logf32 | O3 | gcc | 2719300 | 0.73% | 136 |
| f16a+logf32 | O2 | gcc | 2910200 | 0.79% | 127 |
| f16a+logf32 | O3 | gcc | 2719300 | 0.73% | 136 |
| f16a+logf32+rt | O2 | clang | 70575966 | 19.07% | 5 |
| f16a+logf32+rt | O3 | clang | 70189366 | 18.97% | 5 |
| f32+contract | O2 | clang | 3856700 | 1.04% | 96 |
| f32+contract | O2 | gcc | 3690600 | 1.00% | 100 |
| f32+contract | O3 | clang | 3794300 | 1.03% | 98 |
| f32+contract | O3 | gcc | 3674700 | 0.99% | 101 |
| f16+logf32+contract | O2 | clang | 4209900 | 1.14% | 88 |
| f16+logf32+contract | O2 | gcc | 2910200 | 0.79% | 127 |
| f16+logf32+contract | O3 | clang | 4152200 | 1.12% | 89 |
| f16+logf32+contract | O3 | gcc | 2719300 | 0.73% | 136 |

### Table 5. Code size (bytes of .text)

"pipeline code" is the sum of the MFCC kernel and glue functions that are linked in (the SDK kernels, the two fixed-point glue functions; not the harness, not libgcc). It is the like-for-like number. "app text" is the whole .text of the program linked with -ffunction-sections and --gc-sections; it also contains the harness, and for GCC 1634 bytes of libgcc 64-bit division used only by the harness print routine, so it flatters clang.

| configuration | opt | clang pipeline code | GCC pipeline code | ratio | clang app text | GCC app text | ratio |
|---|---|---:|---:|---:|---:|---:|---:|
| fix16 | O2 | 2800 | 2380 | 1.176 | 6172 | 6188 | 0.997 |
| fix16 | O3 | 3372 | 2406 | 1.401 | 6744 | 7348 | 0.918 |
| fix16 | Os | 2674 | 2098 | 1.275 | 5898 | 5178 | 1.139 |
| f32 | O2 | 3546 | 3110 | 1.140 | 6994 | 6932 | 1.009 |
| f32 | O3 | 4340 | 3112 | 1.395 | 7790 | 8066 | 0.966 |
| f32 | Os | 3224 | 2538 | 1.270 | 6470 | 5644 | 1.146 |
| f16 | O2 | does not link: `__builtin_pulp_v2hitov2hf_u` (B149) | 3278 | - | - | 7064 | - |
| f16 | O3 | does not link: `__builtin_pulp_v2hitov2hf_u` (B149) | 3608 | - | - | 8546 | - |
| f16 | Os | does not link: `__builtin_pulp_v2hitov2hf_u` (B149) | 2522 | - | - | 5602 | - |
| f16a | O2 | does not link: `__builtin_pulp_v2hitov2hf_u` (B149), `__truncsfbf2` (B133) | 3314 | - | - | 7100 | - |
| f16a | O3 | does not link: `__builtin_pulp_v2hitov2hf_u` (B149), `__truncsfbf2` (B133) | 3644 | - | - | 8582 | - |
| f16a | Os | does not link: `__builtin_pulp_v2hitov2hf_u` (B149), `__truncsfbf2` (B133) | 2570 | - | - | 5650 | - |
| f16+logf32 | O2 | 3784 | 2800 | 1.351 | 7206 | 6586 | 1.094 |
| f16+logf32 | O3 | 4750 | 3130 | 1.518 | 8170 | 8068 | 1.013 |
| f16+logf32 | Os | 3416 | 2262 | 1.510 | 6638 | 5342 | 1.243 |
| f16a+logf32 | O2 | does not link: `__truncsfbf2` (B133) | 2800 | - | - | 6586 | - |
| f16a+logf32 | O3 | does not link: `__truncsfbf2` (B133) | 3130 | - | - | 8068 | - |
| f16a+logf32 | Os | does not link: `__truncsfbf2` (B133) | 2262 | - | - | 5342 | - |
| f16a+logf32+rt | O2 | 7932 | 2800 | 2.833 | 11564 | 6586 | 1.756 |
| f16a+logf32+rt | O3 | 11052 | 3130 | 3.531 | 14686 | 8068 | 1.820 |
| f16a+logf32+rt | Os | 6782 | 2262 | 2.998 | 10214 | 5342 | 1.912 |
| f32+contract | O2 | 3184 | 3110 | 1.024 | 6634 | 6932 | 0.957 |
| f32+contract | O3 | 3574 | 3112 | 1.148 | 7026 | 8066 | 0.871 |
| f32+contract | Os | 3144 | 2538 | 1.239 | 6394 | 5644 | 1.133 |
| f16+logf32+contract | O2 | 3672 | 2800 | 1.311 | 7094 | 6586 | 1.077 |
| f16+logf32+contract | O3 | 4554 | 3130 | 1.455 | 7974 | 8068 | 0.988 |
| f16+logf32+contract | Os | 3336 | 2262 | 1.475 | 6558 | 5342 | 1.228 |

**Per function, -O2** (bytes; functions present after --gc-sections; inlined callees are counted in their caller, so a "-" means the function was inlined or not needed by that compiler):

*fix16*

| function | clang | GCC | ratio |
|---|---:|---:|---:|
| `Radix4FFT_DIF_Par_Fix16` | 712 | 632 | 1.13 |
| `Radix2FFT_DIF_Par_Fix16` | 680 | 466 | 1.46 |
| `RFFT_DIF_Par_Fix16` | 296 | 214 | 1.38 |
| `DctTypeII_Fix16` | 244 | 214 | 1.14 |
| `PreEmphasis` | 240 | 176 | 1.36 |
| `MelFilterBank_Fix32_app` | 196 | 182 | 1.08 |
| `LogDb_Fix_app` | 158 | 154 | 1.03 |
| `ulogn_17_15` | 112 | 90 | 1.24 |
| `WindowingReal2Real_Fix16` | 112 | 84 | 1.33 |
| `CmplxMagSquared_Fix16` | 50 | 36 | 1.39 |
| `get_max` | - | 80 | - |
| `SwapSamples_Par` | - | 52 | - |
| **pipeline code (sum)** | 2800 | 2380 | 1.18 |

*f32*

| function | clang | GCC | ratio |
|---|---:|---:|---:|
| `Radix4FFT_DIF_Par_f32` | 1104 | 1122 | 0.98 |
| `Radix2FFT_DIF_Par_f32` | 1084 | 672 | 1.61 |
| `Db_f32` | 414 | 452 | 0.92 |
| `RFFT_DIF_Par_f32` | 376 | 272 | 1.38 |
| `DctTypeII_f32` | 184 | 174 | 1.06 |
| `MelFilterBank_f32` | 124 | 140 | 0.89 |
| `WindowingReal2Real_f32` | 112 | 84 | 1.33 |
| `PreEmphasis_f32` | 82 | 64 | 1.28 |
| `CmplxMagSquared_f32` | 66 | 48 | 1.38 |
| `SwapSamples_Par_f32` | - | 82 | - |
| **pipeline code (sum)** | 3546 | 3110 | 1.14 |

*f16+logf32*

| function | clang | GCC | ratio |
|---|---:|---:|---:|
| `Radix4FFT_DIF_Par_f16` | 1120 | 886 | 1.26 |
| `Radix2FFT_DIF_Par_f16` | 1120 | 584 | 1.92 |
| `Db_f16_f32` | 462 | 428 | 1.08 |
| `RFFT_DIF_Par_f16` | 382 | 262 | 1.46 |
| `DctTypeII_f16` | 292 | 242 | 1.21 |
| `MelFilterBank_f16` | 130 | 140 | 0.93 |
| `WindowingReal2Real_f16` | 118 | 84 | 1.40 |
| `PreEmphasis_f16` | 98 | 76 | 1.29 |
| `CmplxMagSquared_f16` | 62 | 46 | 1.35 |
| `SwapSamples_Par_f16` | - | 52 | - |
| **pipeline code (sum)** | 3784 | 2800 | 1.35 |



## Analysis

Per-PC profiles are in `analysis/prof.<config>.<compiler>.O2.txt` (made with `pc_profile.py`, a GVSoC instruction trace). All ratios below are clang / GCC cycles at -O2.

### Fixed-point: 1.01 overall

- **Pre-emphasis 0.81, a clang win.** The kernel first scans the frame for its largest sample (`get_max`). Clang inlines that function, keeps the running maximum in a register and uses a hardware loop: 6 cycles per sample. GCC keeps the maximum in memory and uses a compare-and-branch loop: 10 cycles per sample. Clang's own loop still has a wasted `nop` per iteration and no post-increment store.
- **DCT 1.27.** The inner loop reads two words from one pointer at offsets -4 and 0 and then adds 8, so clang emits `lw; lw; lw; addi; addi` plus the two `pv.sdotsp.h` (7 instructions). GCC uses three post-increment loads (5 instructions). This is BACKLOG **B20**.
- **Mel filterbank 1.13** (app glue, not an SDK kernel). The two inner loops are identical in both compilers (2 and 4 instructions, hardware loops). Clang spends about 16 more cycles per band in the outer loop: more set-up instructions and two unconditional jumps per band.
- **Real FFT 1.10.**
  - Radix-4 butterfly loop: clang keeps one base pointer and recomputes the three other addresses with three `add` per butterfly; GCC keeps four pointers. Clang also emits `pv.add.h` then `pv.sra.h` where GCC emits the fused `pv.add.h.div4`. Result: 26 instructions per butterfly against 21.
  - RFFT post-processing loop: 12 instructions per bin against 10. Clang uses a plain `lw` plus `addi -4` for the pointer that walks backwards (GCC: `p.lw -4(a!)`), and a separate `pv.sub.h` for the negation that GCC folds into `pv.sub.h.div4`.
- **Log 0.92, a small clang win** (app glue around the SDK's `ulogn_17_15`).
- Window and power spectrum are equal within 1%.

### float32: 1.11 overall (1.05 with `-ffp-contract=fast`)

- **Power spectrum 1.40.** 7 instructions per bin against 5: two loads from one pointer plus an `addi` (B20), and `sw` plus `addi` instead of a post-increment store.
- **DCT 1.28.** Same pattern as fixed-point (B20): 7 instructions per two taps against 5.
- **Pre-emphasis 1.20 and window 1.20.** The loads are post-increment in both compilers. The store is not: clang emits `sw` then `addi`, GCC emits `p.sw ...!`. One extra instruction in a 4-instruction loop. BACKLOG **B21** records that float post-increment was enabled for loads only ("stores deliberately not enabled").
- **Real FFT 1.06, and 0.98 with `-ffp-contract=fast`.** The SDK source computes the products in one statement and adds them in another. GCC 7 fuses multiply-adds across statements by default (`-ffp-contract=fast`); clang's default (`on`) fuses only inside one expression. In `RFFT_DIF_Par_f32` GCC has 3 `fmadd.s` and 1 `fnmsub.s`; clang has none and 4 more `fmul.s`/`fadd.s`. With the flag, clang's FFT is 2-4% faster than GCC's.
- **Log 1.13** (1.06 with the flag): the same fusing difference in the SDK's `fastlog2`.

### Why float32 is not bit-exact

Clang and GCC agree bit for bit after pre-emphasis and after the window. They first differ in the FFT, by at most 3.7e-9 on frame 40 (148 dB SNR between them), because they fuse different multiply-adds. A fused multiply-add rounds once where a separate multiply and add round twice, so the last bit can differ. In the final MFCCs 553 of 1248 values differ, by at most 6.1e-5 dB; the SNR between the two compilers is 146.7 dB. Both are equally close to the float64 numpy reference (115.9 dB) and to the host build (131 dB; x86 fuses nothing at -O0). `-ffp-contract=fast` does not make clang bit-exact with GCC either (134.8 dB): the two compilers still pick different operations to fuse. No wrong result.

### float16: clang does not link; 1.46 in the experiment

- **Link failure (B149).** The SDK's float16 log kernel `Db_f16` uses `fastlog2_v2h`, which needs `__builtin_pulp_v2hitov2hf_u` (packed unsigned-int to float16 conversion). Clang does not have that builtin. The SDK header disables the implicit-declaration warning, so the file compiles silently and fails at link time: `ld.lld: error: undefined symbol: __builtin_pulp_v2hitov2hf_u`.
- **Experiment `f16+logf32`.** The SDK has a second log kernel, `Db_f16_f32`, which converts each value to float32 and uses the float32 log. Using it, and linking with `--gc-sections` so the unused `Db_f16` is dropped, clang links and runs. Both compilers are built the same way.
- **Cause of the 1.46x: no packed float16 code.** GCC compiles the SDK's `v2h` arithmetic to 2-lane instructions (`vfmul.h`, `vfmac.h`, `vfadd.h`, `vfsub.h`, `pv.pack.h`). Clang scalarises it: the RFFT post-processing loop is 27 instructions per bin with clang and 15 with GCC, and the FFT stage is 1.59x. This is the float16 vector work recorded under **B90** (task T5) and **B115**.
- **Second cause: no post-increment addressing for 16-bit float loads and stores.** The window loop is `lh; lh; fmul.h; sh; addi; addi; addi` (7 instructions) against GCC's `p.lhu !; p.lhu !; fmul.h; p.sh !` (4): ratio 1.60. At -O3 GCC also vectorises that loop to `vfmul.h` and the ratio becomes 3.09.
- **Correctness.** Clang's float16 FFT output is bit-identical to the host build (x86 IEEE half precision), and its MFCCs have 32.6 dB SNR against the numpy reference. That SNR is a property of half precision, not of the compiler: in quiet frames the mel energies are below the smallest normal float16 (6.1e-5), so only a few bits are left.

### float16alt (bfloat16): clang does not link; 24x in the experiment

- **Link failure (B133).** Every bfloat16 kernel object references `__truncsfbf2`, which GAP9 libgcc does not have. The plain `f16a` configuration also hits B149.
- **Experiment `f16a+logf32+rt`** (clang only): compiler-rt's `truncsfbf2.c` is compiled with our clang and linked in. The program runs and its MFCCs have 32.5 dB SNR against the numpy reference, so the result is right.
- **It is 24x slower than GCC.** Clang has no native bfloat16 arithmetic: each operation is widened to float32, done with `fadd.s`/`fmul.s`, and rounded back by a call to the software routine `__truncsfbf2`. There are 291 call sites, and 78% of all executed cycles are inside `__truncsfbf2`. GCC uses the native `fadd.ah`, `fmul.ah`, `vfmul.ah` and so on. The 705760 cycles per frame are 19% of a core at 370 MHz, against 0.8% for GCC. Linking compiler-rt is a way to get a number, not a fix.

### Code size

- Like for like (the MFCC kernels and glue only), clang is larger: 1.18x (fix16), 1.14x (float32), 1.35x (float16) at -O2; 1.40x, 1.40x, 1.52x at -O3; 1.27x, 1.27x, 1.51x at -Os.
- The largest single contributors at -O2 are functions that never run here: `Radix2FFT_DIF_Par_*` is 1.46x to 1.92x GCC's size. Among the functions that run, the small loop kernels are 1.3-1.4x (`RFFT_DIF_Par_*`, `PreEmphasis*`, `WindowingReal2Real_*`, `CmplxMagSquared_*`): separate `addi` instructions where GCC uses post-increment, and for float16 the scalarised vectors.
- The whole-program .text is about equal (0.997 for fix16, 1.009 for float32 at -O2), but only because GCC's build pulls 1634 bytes of 64-bit division from libgcc for the harness print routine. Do not quote that ratio as a code-size result.

### -Os

GCC -Os emits almost no hardware loops (10 `lp.setup` in the fix16 program, against 125 at -O2), so every stage is 1.5-2x slower than its own -O2. Clang -Os keeps them (103) and costs under 1% more cycles than clang -O2. Clang -Os is 0.59x (fix16) and 0.69x (float32) of GCC -Os in cycles, and 1.27x in kernel code size.

## Findings to act on

1. **GCC float16 / bfloat16 FFT is wrong on GVSoC: `vfmre.h`.** For the packed expression `a * b - c`, GAP9 GCC emits `vfmre.h`, and on GVSoC that instruction returns `c - a * b` (both lanes have the wrong sign). The SDK's `RFFT_DIF_Par_f16` loop contains exactly this, so GCC's float16 spectrum is garbage on GVSoC (-3 dB SNR against the host build on frame 40) and its MFCCs have 10-12.5 dB SNR against the reference. The bfloat16 build shows the same (12.5 dB).
   - Reproducer: `repro/f16_vec_ops.c` (build line in the file). With GCC -O2 it prints `mre ... MISMATCH` and `rfft ... MISMATCH`; all other packed operations match. With clang it passes, because clang does not emit `vfmre.h`.
   - Whether the simulator or GCC is wrong cannot be decided here: it needs the instruction definition or a run on silicon. Either way GVSoC + GCC is not an oracle for float16 code that contains this pattern. GCC's float16 cycle counts are still usable, because the instruction count does not depend on the sign.
   - Not in BACKLOG.md yet. It belongs next to the known simulator issues B113, B127 and B136. None of those three plays a part here: `pv.shuffle2`, `vfsgnj.ah` and an `fcvt` with the rmm rounding mode do not appear in any of the -O2 disassemblies.
2. **B149 blocks the SDK's float16 MFCC with clang** (`__builtin_pulp_v2hitov2hf_u`). It is a link error, not a wrong result.
3. **B133 blocks every bfloat16 kernel with clang**, and the compiler-rt stopgap costs 24x. Native bfloat16 arithmetic is needed before any bfloat16 number is meaningful.
4. **`-ffp-contract`.** GCC's default is `fast`, clang's is `on`. On this application it is worth 5.5% of float32 cycles and 10% of float32 kernel code size (the size ratio to GCC drops from 1.14 to 1.02). Options: make `fast` the default for the GAP9 target or the wrapper, or document it. It changes last-bit results, so it is an owner decision. Not in BACKLOG.md yet.
5. **Post-increment stores for float, and post-increment loads and stores for float16** are missing (float32 loops `sw` + `addi`; float16 loops `lh`/`sh` + `addi`). B21 covers float32 loads only. This is the cause of the 1.20 ratios on the simplest float loops.
6. **B20** (two offsets from one pointer, no post-increment) is the cause of the DCT (1.27-1.28) and float power-spectrum (1.40) gaps.
7. **SDK issues, not compiler issues**, found on the way:
   - This SDK release has no fixed-point mel filterbank or log kernel, although its generator names them.
   - The SDK's plain-C emulation used for the host build has two bugs. `Cvt_v2u_v2h(a)` is a bit cast instead of a value conversion, which breaks `fastlog2_v2h`; the host build uses a wrapper (`hostshim/PiecewiseMath_host.c`) that replaces only that macro. `Maxf32(a, b)` evaluates its argument twice, so `Db_f16_f32` with `*(pIn++)` skips every other input on the host; the `+logf32` configurations are therefore not compared with a host build.
   - The host float16 build with `Db_f16` has only 9.5 dB SNR against the reference, and the host bfloat16 build 1.3 dB. The SDK's 16-bit fast log does not handle the subnormal mel energies of quiet frames. Whether the same happens on the target could not be separated from finding 1.

## Caveats

- **Simulator, not silicon.** GVSoC `ri5ky_testbench` models one RI5CY core with flat memory. It does not model GAP9's L1/L2 memory latency, TCDM contention, the instruction cache or the cluster. Cycle counts are the simulator's.
- **Single core.** The kernels' parallel entry points run with `gap_ncore() == 1`. The real SDK application runs them on the 8-core cluster; that cannot run on the available simulator even with GCC (`benchmarks/sdk-clang/report.txt`).
- **370 MHz is an assumption**, taken from the SDK example's CMakeLists.txt. The formula is given with Table 4.
- **Did not link with clang:** float16 as wired by the SDK (B149), float16alt (B133 and B149). The float16 and float16alt clang numbers are labelled experiments with a different log kernel, `--gc-sections`, and for float16alt compiler-rt's `__truncsfbf2`.
- **GCC's float16 and float16alt outputs are wrong on GVSoC** (finding 1), so for those variants "correct" for clang means: FFT bit-identical to the host build, and 32.5 dB SNR against the numpy reference.
- **The reference is numpy, not librosa.** librosa is not installed. `ref_mfcc.py` is a float64 numpy implementation of librosa's formulas, written independently of `gen_tables.py`, with pre-emphasis added and without the `top_db` clamp, to match what the kernels compute.
- **Fixed-point accuracy** is 29.75 dB SNR against the reference (correlation 0.9995). That is the SDK Fix16 FFT path's precision (Q12 input, gain 1/128, so quiet bins keep few bits) plus the Q5 dB output of the glue; it is identical for both compilers.
- **The fixed-point mel and log stages are benchmark glue**, 24% of the fixed-point cycles.
- The pre-emphasis state is set by the application to the true previous sample of each overlapping frame. The kernel on its own would use the last sample of the previous frame.
- The two fixed-point glue functions and the stage timing code are the only code here that is not from the SDK or the existing harness.

## Reproduce

```
cd benchmarks/dsp-bench/mfcc-app
python3 run.py            # tables, host builds, 51 target builds, GVSoC runs, results.json (about 20 s on 12 jobs)
python3 report.py         # report.md from results.json and report_text.md
python3 pc_profile.py build/fix16/clang/O2/prog.elf DctTypeII_Fix16,PreEmphasis --top 30
/home/ubuntu/gvsoc-venv/bin/python debug_stages.py f16+logf32 40     # stage-by-stage comparison of one frame
```

Files: `src/mfcc_app.c` (application), `gen_tables.py` and `gen/mfcc_tables.h` (tables and wav array), `ref_mfcc.py` (numpy reference), `shim/`, `hostshim/`, `run.py`, `report.py`, `report_text.md` (the hand-written parts of this report), `debug_stages.py`, `pc_profile.py`, `repro/f16_vec_ops.c`, `analysis/` (per-PC profiles), `results.json`, `build/` (objects, ELFs, disassembly, logs).
