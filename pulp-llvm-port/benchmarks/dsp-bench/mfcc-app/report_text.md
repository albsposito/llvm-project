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
<!-- META -->
- Both: `-D__GAP9__`, the SDK DSP include paths, and the shim `shim/at_api.h` (the gap9-sweep shim plus stubs for the L2 DMA-copy names that `FftLibrary*.c` needs to compile; that function is never called).
- The application file and the memcpy/memset file also get `-ffreestanding -fno-builtin`, as the gap9-sweep drivers do. The SDK kernel files get no extra flags.
- Link: GCC with its own ld; clang with `ld.lld` and GAP9 GCC's `libgcc.a`.

**Harness.** `benchmarks/gap9-sweep/sim` (crt0.S, link.ld, bench.h, run_sim.sh; GVSoC2 `ri5ky_testbench`, one RI5CY core) and `benchmarks/gap9-sweep/runtime` (rt.h, rt_libc.c), unchanged. Each stage is bracketed by the simulator cycle counter and the RI5CY instruction counter. Hashing, input conversion and printing run outside the timed regions. "Cycles per frame" is the sum of the seven stages, averaged over the 96 frames.

## Results

<!-- TABLES -->

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
