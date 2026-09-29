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

## 2026-09-28 evening: SDK build flags that match GCC 7 (`sdkflags`)

Queue item 5 of `steps/20/sdk100-queue.md`. Compiler: a snapshot of `build/int-20` clang, `ccfd68f6ac76` (xgap9 from F017 present, F016 not yet landed).

**New phases** (`strict` is unchanged: pure clang defaults, no `-Werror`):
- `gccsdk`: GAP9 GCC with the SDK's own warning flags, **including `-Werror`**.
- `sdkflags`: clang as the SDK build drives it through the wrapper `../sdk-clang/bin/riscv32-unknown-elf-clang`. It uses `-march=rv32imc_xgap9`, which predefines `__gap9__` and the other GCC macros, so there is no macro shim. It passes the SDK's `-W` flags including `-Werror`, plus the wrapper's diagnostic policy (below).
- `sdknowerror`: `sdkflags` without `-Werror`, as in a `CONFIG_DISABLE_WERROR` build.
- `parity`: writes `sdkflags_parity.json`. A file counts as ok only if clang exits 0 **and** the survey classifier finds nothing in its log. So a missing builtin that was demoted to a warning still counts as a failure.

| mode | clang flags | compared with | ok | parity |
|---|---|---|---|---|
| strict | clang defaults + macro shim, no `-Werror` | GCC, no `-Werror` (617) | 209 | 33.9% |
| sdknowerror | SDK `-W` flags without `-Werror` + policy, xgap9 | GCC, no `-Werror` (617) | 213 | 34.5% |
| sdkflags | SDK `-W` flags with `-Werror` + policy, xgap9 | GCC with the SDK's `-Werror` (609) | 208 | 34.2% |

- **GCC 7 with the SDK's own `-Werror` rejects 8 of the 617 files.** They are the 7 "clang-stricter default error" files plus `RNN_BasicKernels_NE16.c`, and no configured app builds them.
  - With `-Werror`, those 7 are SDK bugs that GCC rejects too, not clang gaps. That corrects step 5 of "What it would take".
  - Without `-Werror`, the policy makes 4 of them compile: `ring.c`, `get_param.c`, `downmixer.c`, `passthrough.c`. The other 3 also need the F016 builtins.
- **Only one file compiles in strict and fails in sdkflags:** `malloc_internal.c`. It uses `-Wformat` with `%lX` on a `uint32_t`, which is correct for GCC (`int32_t` is `long int`) and wrong for clang (`int32_t` is `int`). This is a real type difference, deliberately not hidden. No app builds this file (its flags are inferred).
- **Projection, run once and not a phase:** with the F016 stop-gap header (`gap9_clang_compat.h`), the fp16 probe types and CoreCount set to 8, a `-Werror` SDK build compiles **179/609** files with the SDK's literal flags and **510/609** with the policy.
  - The policy therefore removes the clang-only `-Werror` stoppers from 331 files.
  - 5 files still fail on `-Werror` alone, all real problems: uninitialized uses in `bsp/fs/read_fs/read_fs.c` (61 apps), `bsp/fs/lfs/pi_lfs.c`, `bsp/ota/ota.c` and `bsp/ota/updater.c`, plus `malloc_internal.c`.
  - Also still an error: `-Wunsequenced` in `CNN_Copy.c` (`gap_pack2f16((f16)*(pIn++), (f16)*(pIn++))`, where the lane order is unspecified). It shows up behind the fp16 errors.
- **App check:** `examples/gap9/basic/helloworld` builds and links through the SDK's CMake with its `-Werror` and without `CONFIG_DISABLE_WERROR` (wrapper, `GAP_CLANG_MARCH=rv32imc_xgap9`, compat header, GNU as/ld). The warnings stay visible (50 `unknown-attributes`, 3 `enum-conversion`, 2 `compound-token-split-by-macro`, 2 `implicit-const-int-float-conversion`). With `GAP_CLANG_GCC7COMPAT=0` it stops at `fll.c`.

**The policy** is defined in the wrapper, which is the single source of truth, with the reason for each flag:
- **Spelling:** `-Wno-discarded-qualifiers` becomes `-Wno-incompatible-pointer-types-discards-qualifiers`, clang's name for the SDK's own option. Without it, 6 FreeRTOS kernel files fail.
- **Precedence:** `-Wall`/`-Wextra` are moved in front of explicit `-Wno-X`. GCC lets an explicit option win wherever a group appears; clang applies options in order. The mbedtls flags repeat `-Wall -Wextra` after `-Wno-unused-parameter`, which breaks `aes.c` and `ecp.c`.
- **Without `-Werror` only:** `-Wno-error=` for `implicit-function-declaration`, `implicit-int`, `int-conversion`, `incompatible-function-pointer-types` and `return-mismatch`.
  - This is the complete set of C diagnostics that clang 20 makes errors by default and GCC 7.1.1 only warns about, each checked with both compilers.
  - With `-Werror` GCC fails on them too, so clang's default already matches.
- **Always:**
  - `-Wno-typedef-redefinition`: a C11 redefinition to the same type, which GCC accepts silently in gnu99. A redefinition to a different type is still an error.
  - `-Wno-error=` for `unknown-attributes` (`tiny`, `optimize`), `enum-conversion`, `compound-token-split-by-macro`, `self-assign`, `header-guard`, `deprecated-non-prototype`, `implicit-const-int-float-conversion`, `constant-conversion`, `pointer-bool-conversion`, `tautological-pointer-compare` and `empty-body`.
  - Each of these fires in a file that GCC 7 compiles with the SDK's `-Werror`. They are demoted, not silenced, so the build log still shows them.
- **Guard:** clang puts "use of unknown builtin" in the `implicit-function-declaration` group, so the wrapper fails any compile that calls a `__builtin_*` clang does not know.
- **Code generation:** `-ffp-contract=fast`, which is GAP9 GCC's default (`-Q --help=optimizers`) and owner decision D6/Q5. It fuses `a*b+c` across statements, as GCC does.
- **Not added: `-fno-math-errno`.**
  - GAP9 GCC keeps `-fmath-errno`: there is no `__NO_MATH_ERRNO__`. At `-O2` it compiles `sqrtf` to `fsqrt.s` with a `call sqrtf` fallback; at `-Os` it is a plain `tail sqrtf` into newlib libm.
  - Clang's default already does the same.
  - GCC 7 has no `__builtin_sqrtf16`, so the `sqrtf16` libcall is a problem for the fp16 builtin work (F035/T6), not for the flags. The fix belongs there: lower the PULP fp16 sqrt builtins to `llvm.sqrt`.

**Harness fix (compile database):** the tracked `compile_db.json.gz` pointed into a deleted scratch directory (`.../F021-survey/bld/...`), so every run failed with `'dt.h' file not found`.
- The `db` phase now writes `<work>/compile_db.json.gz` and never overwrites the tracked file.
- The tracked file is now a snapshot. Its work-dir paths are stored as `@WORK@` and replaced at load time; old absolute paths are also remapped. It is refreshed only by the explicit phase `dbsnapshot`.
- Any phase that needs the database runs `configure` + `db` in `--work` automatically when the cmake build dirs it refers to are missing.
- Checked from an empty `--work` with `--phases snapshot,gcc,strict`: configure ran by itself, and the result was GCC 617, strict 209, the same as the baseline.

Reproduce:

```
python3 run.py --work DIR --phases snapshot,gcc,gccsdk,strict,sdkflags,sdknowerror,parity
```

### 2026-09-29 update: the current compiler, `-mPE=8`, fresh work dir

- **Compiler:** a snapshot of `build/int-20` clang with `lib/clang`, `de8abd20c921`, the same compiler as the M2a checkpoint (it includes F016, F018 and F019).
- **Harness changes:**
  - `sdkflags` and `sdknowerror` now pass the SDK's `-mPE=8`, which clang now accepts (F018 folds `CoreCount()` as GCC does). `-mFC` is still dropped: clang has no equivalent.
  - The M2a modes `pe8`, `xgap9`, their `*lenient` variants and `pe8abs*` are folded into `run.py`, so the checkpoint can be reproduced with the tracked script.
  - `parity` also runs `nm -u` on every ok object and rejects a file whose object has an undefined `__builtin_*`. Some SDK headers, such as `FastFloatApprox16.h`, silence `-Wimplicit-function-declaration` with a pragma, so an unknown builtin can compile without any message.
  - The wrapper applies the same check to every `-c` compile.
- **Run from an empty `--work`** with `--phases snapshot,gcc,gccsdk,strict,pe8,sdkflags,sdknowerror,parity`: configure and db ran by themselves, and the whole run took 6.5 min at `-j12`.

| mode | flags | compared with | ok | parity |
|---|---|---|---|---|
| strict | clang defaults + macro shim, xpulpv2 | GCC, no `-Werror` (617) | 477 | 77.3% |
| pe8 | `-march=rv32imc_xgap9 -mPE=8`, no shim, clang defaults | GCC, no `-Werror` (617) | 520 | 84.3% |
| sdknowerror | pe8 + SDK `-W` flags without `-Werror` + policy | GCC, no `-Werror` (617) | 527 | 85.4% |
| sdkflags | pe8 + SDK `-W` flags with `-Werror` + policy | GCC with the SDK's `-Werror` (609) | 515 | 84.6% |

- **sdknowerror is pe8 plus exactly the 7 implicit-declaration files** from the M2a report: `pi_malloc` ×3, `strtol`, `bsp_virtual_eeprom_conf_init`, `SDIO_TRACE`, `TIMESTAMP_TRACE_ERR`. Nothing else changes.
  - This mode is like for like with the survey's GCC reference, which also compiles without `-Werror`.
  - With the SDK's own `-Werror`, GCC 7 rejects the same 7 files, so there they are SDK bugs, not clang gaps.
- **sdkflags is pe8 minus 5 files, on GCC's 609:**
  - uninitialized uses in `read_fs.c:184`, `pi_lfs.c:147/156`, `ota.c:271` and `updater.c:56`, which GCC 7 misses;
  - `malloc_internal.c` (`%lX` on a `uint32_t`, because `int32_t` is `int` in clang).

  All 5 are deliberate.
- **App check:** `examples/gap9/basic/helloworld` builds and links with the SDK's `-Werror`, **without the compat header** and with native `-mPE=8`. The wrapper setting is `GAP_CLANG_MARCH=rv32imc_xgap9`, variant `clang-gnuas-gnuld`. Without the policy it stops at `fll.c`.

