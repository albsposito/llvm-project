# GAP9 SDK compile survey (B30)

Run on 2026-09-28. SDK `/home/ubuntu/gap_sdk_release` 5.21.14 (HEAD `206cbda18bba`), not modified.

- **LLVM:** a snapshot of `build/int-20/bin/clang`, `clang 20.1.8 (albsposito/llvm-project b0f18c5a6b88)` (includes F012/F015).
- **GCC:** GAP9 GCC 7.1.1.
- **Flags common to both:** `-O2` plus the SDK's per-file `-D`/`-I`/`-f` flags.
- **GCC flags:** the SDK's `-march=rv32imcxgap9 -mPE=8 -mFC=1 -mint64`, without `-Werror`.
- **Clang flags:** `--target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax`, the GAP newlib headers, and a shim for the macros GAP9 GCC predefines and clang does not: `__gap9__ __pulp__ __pulp _pulp __riscv__ _riscv`.

Everything is reproducible with `run.py` (default work dir `/tmp/sdk-compile-survey-work`, or `--work` / `SURVEY_WORK`; it recreates a scratch venv with `kconfiglib`, `xxhash`, `fdt`, and copies clang into the work dir first). Per-file data is in `results.json`, builtins in `builtins.json`, the greedy fix ranking in `fix_ranking.json`, compile commands in `compile_db.json.gz`.

## Headline

**LLVM compiles 209 of the 617 GCC-compilable files: 33.9% parity.**

- 398 of the 408 failures come from two missing PMSIS builtins used in headers almost every PMSIS file includes.
- Adding just those two builtins takes parity to **476/617 = 77.1%**.

## How the survey was done

1. **Compile commands from the SDK's own CMake, configure only.** App trees copied into a scratch mirror, rest of the SDK symlinked. All 215 apps configured with `cmake -B … -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` and the gap9_evk_audio config. 190 configured fully; the 25 audio-framework apps fail in the audio-framework's own cmake code. This gave exact commands for 618 existing C sources.
2. **175 more target sources** under `rtos/`, `libs/`, `BasicKernels/` and `audio-framework/lib` are not compiled by any app; they got the flags of the nearest covered file plus their own include dirs ("inferred").
3. **95 files excluded:** host code (mbedtls programs and tests, the x86 PMSIS emulation, MATLAB/Python tools) and unused files (FreeRTOS heap_1..5 and mpu_wrappers, an ESP32 firmware file). The AutoTiler host generators (`Autotiler/`, `Generators/`) are not counted.
4. **GCC first.** Files GCC cannot compile are harness-setup failures, not LLVM gaps.
5. **LLVM on the GCC-compilable files, four modes:**
   - **strict:** clang defaults; the headline numbers.
   - **lenient:** adds `-Wno-error=` for diagnostics clang makes errors but GCC 7 does not. Unknown builtins become external calls, so the back end runs on almost every file (crash search).
   - **fp16probe:** maps `float16`→`_Float16` (+zhinx), `float16alt`→`__bf16` (wrong semantics, probe only) and `__builtin_pulp_CoreCount()`→8.
   - **nodefs:** strict without the macro shim.

## Totals per area

"After 2 builtins" = the file compiles once `__builtin_pulp_OffsetedWritePtr` and `__builtin_pulp_event_unit_read_fenced` exist (from the lenient run: those two are its only remaining errors).

| area | files | excluded | in scope | GCC ok | LLVM ok | parity | after 2 builtins | parity |
|---|---|---|---|---|---|---|---|---|
| rtos/freertos | 77 | 6 | 71 | 67 | 64 | 96% | 67 | 100% |
| rtos/pmsis-implem | 59 | 0 | 59 | 57 | 7 | 12% | 55 | 96% |
| rtos/pmsis-bsp | 93 | 2 | 91 | 69 | 22 | 32% | 68 | 99% |
| rtos/other (tools, sfu) | 7 | 1 | 6 | 6 | 3 | 50% | 3 | 50% |
| libs/mbedtls | 97 | 0 | 97 | 97 | 97 | 100% | 97 | 100% |
| libs/other | 107 | 83 | 24 | 23 | 4 | 17% | 20 | 87% |
| at/DSP_Libraries | 38 | 0 | 38 | 38 | 0 | 0% | 0 | 0% |
| at/CNN_Libraries* | 70 | 1 | 69 | 68 | 0 | 0% | 0 | 0% |
| at/other-kernels | 3 | 0 | 3 | 3 | 0 | 0% | 0 | 0% |
| audio-framework | 111 | 2 | 109 | 50 | 5 | 10% | 39 | 78% |
| examples/basic | 142 | 0 | 142 | 100 | 1 | 1% | 98 | 98% |
| examples/dsp | 16 | 0 | 16 | 2 | 0 | 0% | 0 | 0% |
| examples/nn | 6 | 0 | 6 | 0 | 0 | – | 0 | – |
| examples/audio | 9 | 0 | 9 | 5 | 3 | 60% | 5 | 100% |
| examples/isp etc. | 18 | 0 | 18 | 11 | 0 | 0% | 6 | 55% |
| nn_menu | 24 | 0 | 24 | 10 | 3 | 30% | 7 | 70% |
| utils (ssbl, gap_cli) | 11 | 0 | 11 | 11 | 0 | 0% | 11 | 100% |
| **total** | **888** | **95** | **793** | **617** | **209** | **33.9%** | **476** | **77.1%** |

The files that compile are mostly code that does not include PMSIS headers: mbedtls, the FreeRTOS kernel, some BSP drivers. **No AutoTiler kernel file, DSP or CNN, compiles today.**

**Harness-setup failures (GCC fails too): 176 files.** 153 miss a header only a full build generates (AutoTiler/NNTool `*Kernels.h`, SFU `*_LN_Descr.h`, test-data headers, audio-framework headers whose cmake step failed); 23 fail for other reasons (config-specific BSP drivers with inferred flags, baselibc template files, a few audio-framework files).

## LLVM failure buckets (408 files)

Primary bucket (first cause, order crash > option > builtin > type > GCC-only > asm):

| bucket | files | example |
|---|---|---|
| missing builtin | 398 | PMSIS/BSP/examples, via `OffsetedWritePtr` / `event_unit_read_fenced` |
| unsupported type (float16/float16alt) | 5 | `DSP_Libraries/MatrixFunctions/MatMulDSP.c`, `MatAddDSP.c`, `MatVectDSP.c` |
| clang-stricter default error | 4 | `audio-framework/.../passthrough/src/passthrough.c` |
| crash (assertion) | 1 | `libs/gap_lib/img_io/ImgIO.c` |
| unknown -march/option | 0 | |
| inline asm | 0 | |

Everything each failing file needs, merged across strict, lenient and fp16probe runs:

| cause | files |
|---|---|
| any missing builtin | 399 (398 need the PMSIS pair; 43 need at least one other builtin) |
| `float16`/`float16alt` built-in types (and `v2h`/`v2ah`) | 132 |
| GCC-only: `__builtin_pulp_CoreCount()` folded to 8 by `-mPE=8`, used in a static initializer (`static int ActiveCore = gap_ncore();`) | 68 (all CNN kernels) |
| GCC-only: `__builtin_shuffle` (1232 call sites in 28 files) | 26 |
| our Sema checks stricter than GCC: non-constant `mulsN` norm (9 files) or non-constant `clip`/`clipu` bounds (2 files) | 11 |
| clang-stricter default errors (implicit function declaration, int-conversion) | 7 |
| other (parse errors behind float16; `float_t`) | 6 |
| crash | 1 |

- No option or inline-asm failures.
- **Predefined macros:** all 209 successes also compile without the shim, but `Emulation/Gap.h` picks its types on `__gap9__`, so without it the fp16 kernels silently take the emulation path (`float16` = `short`). Clang should predefine `__gap9__`, `__pulp__`, `__riscv__` for GAP9.

## Missing builtins, ranked

The SDK uses 212 distinct `__builtin_pulp_*` names; **71 are missing** in our clang (more than the 43 in the earlier survey because the DSP/CNN float headers add fp16 and conversion builtins). "Call sites" counts direct calls plus calls through `#define` wrappers.

| builtin | files blocked | call sites | wrappers |
|---|---|---|---|
| event_unit_read_fenced (p.elw) | 398 | 3 (static inline in headers, in every PMSIS TU) | evt_read32 |
| OffsetedWritePtr (p.sw of a pointer value) | 377 | 10 (same pattern) | GAP_WRITE_PTR |
| f32max | 15 | 88 | Maxf32, Clipf32 |
| f16altmax | 14 | 253 | MaxF16, Clipf16a |
| f32min | 9 | 9 | Minf32 |
| f16altmin | 9 | 32 | MinF16 |
| f16max | 9 | 256 | MaxF16, Clipf16 |
| f16altmax2 | 8 | 67 | Maxv2ah |
| f32abs | 7 | 3 | Absf32 |
| f16max2 | 6 | 74 | Maxv2h |
| f16min | 6 | 35 | MinF16 |
| f32sqrt | 5 | 14 | Sqrtf32 |
| f16min2 / f16altmin2 | 3 / 3 | 28 / 21 | Minv2h / Minv2ah |
| rintsf2 | 2 | 32 | AT_SCALEF, gap_f32rmm |

Blocking 1 file each: trunch, mulfsN, add2div2, add2div4, sub2div2, sub2rotmj, cplx_conj, cplxmuls2, cplxmuls2div2, cplxmuls2div4, v2hftov2ohf, v2ohftov2hf, f16sqrt, f16altsqrt, mul64hu. The other 36 block no file today (unused, or only in files blocked earlier). Full table in `builtins.json`.

## Crashes and hangs (P1; both inherited from ref-18, confirmed with the ref-18 and int-19 llc)

**1. PULP Hardware Loops produces invalid MIR, ending in a LiveVariables assertion.**
- Found in `libs/gap_lib/img_io/ImgIO.c`, `@GetInputImageInfos`.
- Assertion: `LiveVariables.cpp:141 'MBB != &MF->front() && "Can't find reaching def for virtreg"'`. With `-verify-machineinstrs`, reported right after "PULP Hardware Loops": "Virtual register defs don't dominate all uses".
- Trigger: a counted loop (exit at 256) whose exit value feeds a phi in a block that a multi-way switch loop also reaches.
- Reduced reproducer (30 lines): `crash-pulp-hwloops-GetInputImageInfos.ll`.

```
build/int-20/bin/llc -O2 -mtriple=riscv32 -mattr=+xpulpv,+zfinx,+m,+c crash-pulp-hwloops-GetInputImageInfos.ll -o /dev/null
build/int-20/bin/llc -O2 -verify-machineinstrs -mtriple=riscv32 -mattr=+xpulpv,+m,+c crash-pulp-hwloops-GetInputImageInfos.ll -o /dev/null
```

Full-file reproducer: `run.py --phases lenient --only img_io/ImgIO --force`.

**2. Instruction selection loops forever on two adjacent 16-bit float loads followed by two stores, with Xpulpv2.**
- Found in `DftLibraryf16a.c` (fp16probe run): 300 s timeout in "RISC-V DAG->DAG Pattern Instruction Selection" on `_DIT_DFT_MR`.
- Reproducers: `hang-isel-f16-pair-xpulpv.c` (`_Float16`), `hang-isel-bf16-pair-xpulpv.c` (`__bf16`), `hang-isel-bf16-pair-xpulpv.ll`.
- Hangs with `-march=rv32imc_zfinx_xpulpv2 -O2`; not without Xpulpv2, not at `-O0`, not with `+zhinx` for `_Float16`.
- Probable cause: a DAG combine turns the pair into a 2 x 16-bit vector that the PULP packed-SIMD lowering cannot handle. Affects any fp16 storage code built without Zhinx.

```
timeout 20 build/int-20/bin/clang --target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -O2 -c hang-isel-f16-pair-xpulpv.c -o /dev/null   # exit 124
```

**Not reproduced:** the 2026-09-27 survey crashes (PULPHardwareLoops segfault in CmplxMagSquared/KerFirSeq, getMinRVVVectorSizeInBits assertion) and the Sema RN bug. Not conclusive: in lenient/fp16probe runs those files reach codegen only with missing builtins turned into external calls, which changes the loops.

## Spot check of the objects that compile (209 files)

Correctness and performance out of scope. Summed over all 209 objects (dominated by mbedtls):
- **Totals:** GCC 68,324 instructions (2,966 PULP); LLVM 78,100 (2,099 PULP).
- **Never emitted by LLVM:** `p.bclr` (GCC: 560), `p.bset` (71), `lp.setupi` (57).
- **Emitted much less by LLVM:** post-increment `p.lw` (107 vs 437), `p.sw` (102 vs 229), `p.insert` (16 vs 156).
- **Emitted more by LLVM:** `p.extbz` (284 vs 0), `p.addun` (55 vs 0), `p.mac` (108 vs 66).
- `p.beqimm`/`p.bneimm` are emitted from C in this build (284/298), thanks to F015.

## What it would take

Greedy order from `fix_ranking.json`; parity against the 617 GCC-compilable files.

| # | fix | files unlocked | parity after |
|---|---|---|---|
| 1 | OffsetedWritePtr + event_unit_read_fenced (two small intrinsics) | +267 | 77.1% |
| 2 | float16 = `_Float16` (Zhinx); float16alt = a new PULP Xf16alt type (not Zfbfmin); v2h/v2ah vectors | +38 | 83.3% |
| 3 | fold CoreCount() to a constant from a `-mPE=`-style option | +24 | 87.2% |
| 4 | `__builtin_shuffle` (map onto `__builtin_shufflevector`) | +17 | 90.0% |
| 5 | `-Wno-error=implicit-function-declaration,int-conversion` in the flags (flags only) | +7 | 91.1% |
| 6 | accept non-constant mulsN/clip/clipu arguments, as GCC does | +6 (+2) | 92.1% |
| 7 | fp scalar builtins: f32/f16/f16alt max/min/abs/sqrt, rintsf2 | about +33 | about 98.2% |
| 8 | the hardware-loop crash | +1 | 98.7% |
| 9 | the complex/divN/fractional/64-bit builtins | about +4 | about 99.4% |

- Step 1 is the only large lever for PMSIS, BSP, examples and apps; every AutoTiler kernel also includes PMSIS headers, so it comes first there too.
- DSP kernels need steps 1+2, plus 3 for MatMul/MatAdd/MatVect/Fir and 4 for the f16 MatMul/FFT.
- CNN kernels need steps 1+2+3, plus 4 for 13 files and 6 for the fp16 CNN files.
- 5 files are never unlocked by these steps (fp16 cases the probe cannot separate).

## Caveats

- **Inferred flags:** 85 of the 175 inferred-flag files fail under GCC as well, so they count as harness failures.
- **Generated kernels:** AutoTiler/NNTool-generated `*Kernels.c` files do not exist without a full build and are not in the corpus.
- **Back end mostly untested:** the 398 files blocked in the front end reached codegen only in the lenient/fp16probe runs with missing builtins as external calls. More back-end crashes are likely once steps 1-4 land. Re-run this survey after each step.
- **Probe type:** `float16alt`→`__bf16` has the wrong semantics and is a probe only.
