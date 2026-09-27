# GAP9 SDK benchmark sweep: survey

Surveyed 2026-09-27. Nothing was built or run beyond quick compile probes of about one second each. The probe objects and error logs are in the session scratchpad and are not kept.

SDK: `/home/ubuntu/gap_sdk_release`, `sdk_version` = 5.21.14, HEAD `206cbda18bba`. GCC: `/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc`, GCC 7.1.1 20170509 with binutils ld 2.28.

## TL;DR

- **Top blocker: the fork cannot compile the SDK's real DSP kernels.** This is true for ref-18, int-19 and int-20 alike. With the same shim headers, GAP9 GCC compiles all 7 probed DSP files; our clang fails on every one. The failures are:
  - crashes in `PULPHardwareLoops` (segfault), in `CmplxFunctionsFix.c` (`CmplxMagSquared_Fix16`) and in `FirBasicKernelsf32.c`/`FirBasicKernelsf16.c` (`KerFirSeqf32`, `KerFirSeqf16`);
  - an assertion failure, `RISCVSubtarget::getMinRVVVectorSizeInBits` "Tried to get vector length without Zve or V", reached from the RISC-V TTI cost model during SimpleLoopUnswitch, in `FirBasicKernelsFix.c`. It fails at -O2, -Os and -O3 (-fno-unroll-loops does not help);
  - a Sema bug in the `__builtin_pulp_*RN` rounding checks (details below);
  - 43 missing `__builtin_pulp_*` builtins;
  - GCC-only language features.

  The benchmark therefore has two parts: fix or skip these in the port, or use hand-extracted, self-contained kernels.
- **The simulator exists only as source; it is not built.** `install/` is missing and no `gvsoc`/`gvrun` binary exists. Several apt packages are missing (listed below). Passwordless `sudo` works, so installing them is possible, but it is the owner's decision. The best runnable target is **gvsoc2's bare-metal `ri5ky_testbench`**: one RI5CY core with Xpulpv2 and Zfinx, and an MMIO cycle counter. It needs no PMSIS, FreeRTOS, flash image or boot ROM.
- **The encodings match.** A GAP9 GCC object disassembles identically with our `llvm-objdump --mattr=+xpulpv,+zfinx`. A clang object links with GAP GCC ld 2.28 when built with `-mno-relax`.
- **Suspected inherited miscompile: `__builtin_pulp_clip(x,-128,127)` emits `p.clip a0,a0,7` on 18, 19 and 20.** GCC emits `p.clip a0,a0,8`. GVSoC's `p_clipi_exec` clamps to `[-2^(N-1), 2^(N-1)-1]`, so 7 means `[-64,63]`. This must be confirmed on the simulator before any cycle comparison of kernels that use `gap_clip`. `p.clipu` agrees with GCC (9 for `[0,255]`).

## 1. Where the kernels are

| Candidate | Path | Language, size | Self-contained? |
|---|---|---|---|
| FIR benchmark app | `examples/gap9/dsp/benchmarks/Fir/Test.c` (248 lines) | C | No. PMSIS cluster fork and DMA; links the FIR kernels below; Kconfig INT16/FLOAT16/FLOAT32; prints cycles via `gap_fc/cl_readhwtimer` |
| FIR kernels | `tools/autotiler_v3/BasicKernels/DSP_Libraries/FilteringFunctions/FirBasicKernels{Fix,f32,f16,f16a}.c` (about 190-205 lines each) | C with `gap_*` builtins | Nearly. Needs only `gap_coreid/ncore/waitbarrier` and `memcpy`. `KerFirSeq*` is sequential single-core code, a good benchmark target |
| MatMul benchmark | `examples/gap9/dsp/benchmarks/MatMul/` (`MatMulRunTest.c` 317 lines, `MatMulModel.c`) | C, **fp32** | No. The AutoTiler generates `MatMulKernels.c` at build time. But `MatMulSimpleSeq()` (lines 54-80) is a plain sequential fp32 triple loop that runs on the FC |
| AutoTiler MatMul/DotProd/MatAdd | `examples/gap9/dsp/autotiler/{MatMul,DotProd,MatAdd}/` | C | No (AutoTiler-generated tiling, `LibTile.a` prebuilt) |
| MatMul kernels | `DSP_Libraries/MatrixFunctions/MatMulDSP.c` (1067 lines: `KerParMatMulDSP_Fix16`, `_f32`, ...), `MatMulDSPf16{,a}.c`, `MatVectDSP.c`, `MatAddDSP.c` | C | Nearly. `MatMulDSP.c` includes fp16 code (`FastFloatApprox16.h`), so clang needs the f16 parts stripped out |
| FFT/DFT | `DSP_Libraries/TransformFunctions/FftLibraryFix.c` (1628 lines), `FftLibrary{f32,f16}.c`, `DftLibrary*.c`; apps in `examples/gap9/dsp/benchmarks/{FFTL1,RFFTL1,IRFFTL1,DftSimple}` | C | No. `FftLibraryFix.c` uses `AT_L2_COPY` and DMA events; its twiddle tables are in `LUT_Tables/*Def.c` (93k lines of data) |
| Windowing, complex math, fast math | `DSP_Libraries/WindowFunctions/PreProcessingFix.c`, `ComplexMathFunctions/CmplxFunctionsFix.c`, `FastMathFunctions/MathFuncsFix.c` | C | Nearly (the same shim is enough) |
| Integer int16 MatMul (plain C) | `examples/gap9/basic/getting_started/cluster_kernels.c` (`matmul_worker`, lines 34-55) | C | Kernel yes; the app is PMSIS with cluster DMA and prints `gap_fc_readhwtimer` deltas |
| CNN int8 MatMul (sdot 4x8) | `tools/autotiler_v3/BasicKernels/CNN_Libraries_SQ8/CNN_MatMul_Conv_SQ8.c` (2993 lines) | C | No (AutoTiler/NNTool runtime) |
| Perf-counter examples | `examples/gap9/basic/perf/perf.c` (`pi_perf_conf/start/read(PI_PERF_ACTIVE_CYCLES)`), `examples/gap9/basic/gvsoc/pcer/example.c` | C | Show how the APIs are used |

The builtin headers are `tools/autotiler_v3/Emulation/GapBuiltins.h` (gap_* → `__builtin_pulp_*`) and `rtos/pmsis/os/freeRTOS/vendors/gwt/gap9/pmsis/include/cores/TARGET_RISCV_32/builtins_gap9.h`. `DSP_Libraries/FloatDefines.h` maps the fp16 SIMD helpers to `__builtin_pulp_f16*2`.

## 2. How GAP9 apps build

- Environment: `export GAP_RISCV_GCC_TOOLCHAIN=/home/ubuntu/gap_riscv_toolchain_ubuntu` (the default `/usr/lib/gap_riscv_toolchain` does not exist), then `source configs/gap9_evk_audio.sh` (or `gap9_v2.sh`). These set `TARGET_CHIP=GAP9_V2`, `BOARD_NAME=gap9_evk`, `GVSOC2_TARGET=gap.gap9.evk`, and so on, via `configs/common.sh`. `sourceme.sh` is the interactive board picker.
- Per app, with CMake 3.19 or later: `CMakeLists.txt` does `include($ENV{GAP_SDK_HOME}/utils/cmake/setup.cmake)` … `setupos(target)`. Kconfig lives in `sdk.config` and `Kconfig`; the platform is chosen in `utils/kconfig/platform/platform.kconfig` (default `PLATFORM_GVSOC`; also `PLATFORM_GVSOC2`, `PLATFORM_BOARD`, `RTL`, …). The commands are `cmake -B build [-DCONFIG_PLATFORM_GVSOC2=y]`, then `cmake --build build -t run`.
- **Only GCC is supported.** `utils/cmake/macros.cmake:6-60` `setupcrosscompile` calls `find_program(GAP_RISCV_CC riscv32-unknown-elf-gcc)` and sets `CMAKE_C_COMPILER` from it. There is no clang, LLVM or TOOLCHAIN switch anywhere in `utils/cmake`, `configs` or `sourceme.sh`. The flags in `utils/cmake/gcc_flags.cmake` are `-march=rv32imcxgap9 -mPE=8 -mFC=1 -mint64 -fcommon -fno-jump-tables -fno-tree-loop-distribute-patterns -fno-delete-null-pointer-checks -fomit-frame-pointer -ffunction-sections -fdata-sections -funsigned-char -Wall -Wextra -Werror`. The link flags are `-nostartfiles -nostdlib -Wl,--gc-sections -lgcc -flto`.
- There are two ways to use clang inside the SDK flow:
  - Pass `-DGAP_RISCV_CC=<wrapper>`. `find_program` respects a cache variable that is already set. The wrapper sends the chosen kernel TUs to clang and everything else, including the link, to GCC.
  - Add clang-built `.o` files to `TARGET_SRCS`.

  The flags must be translated to `--target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax -funsigned-char -fno-jump-tables`. The GCC-only flags `-mPE/-mFC/-mint64` must be dropped.

## 3. Performance measurement / simulators

- **Legacy GVSoC**: source is in `gvsoc/gvsoc` plus `gvsoc/gvsoc_gap`. It is built by `make all` (`cmake_sdk.build`: builds the whole SDK tree with `-j6`, installs to `install/workstation`; `SKIP_GVSOC`, `WITHOUT_OPENOCD` and `SKIP_GUI_TOOLS` are available). Apps run through `gapy`, which uses the flash image, fsbl/ssbl and boot ROM, so a full PMSIS/FreeRTOS app is needed.
- **gvsoc2** (new): source is in `gvsoc2/`. Build with `make gvsoc2.all` (pip deps from `gvsoc2/{gvrun,config_tree,core}/requirements.txt`, then a two-stage cmake build into `install/gvsoc2`). Only `gap.gap9.evk` is wired in by default (`Makefile:118`, `GVSOC2_TARGETS ?= $(GVSOC2_TARGET)`). `gvrun --target=gap.gap9.evk --parameter chip/binary=<elf> run` loads the ELF directly. Per `gvsoc2/README.gap_sdk.md`, helloworld runs; many peripherals are not modelled.
- **gvsoc2 `ri5ky_testbench` (recommended for this sweep)**: `gvsoc2/pulp/targets/ri5ky_testbench.py` and `gvsoc2/pulp/pulp/ri5ky/`. It is one core with ISA `rv32imafc_zfinx` + `PulpV2` + `Xf16/Xf16alt/Xfvec` (`gvsoc2/pulp/pulp/cpu/iss/ri5ky.py:93-99`), 1 MB RAM at 0x0 with latency 1, and boot address 0x80. The MMIO at `0x10000000` has +0x0 putchar, +0x4 exit(code), and +0x8/+0xC for the low and high halves of the cycle counter (`ri5ky_mmio.cpp`). The helper is `gvsoc2/pulp/tests/ri5ky_testbench/calibration/calib.h`. It has to be added at build time with `make gvsoc2.all GVSOC2_TARGETS="gap.gap9.evk ri5ky_testbench"`; the exact target string is unverified. We would write our own ~30-line `crt0.S` and linker script, because the SDK has no pulpos builder for it.
- GVSoC models the GAP9 ISA as `rv32imfc` + Gap9 + PulpV2 + Int64 + Xf16 + Xf16alt + Xfvec (`gvsoc/gvsoc_gap/gap/gap9/cpu/iss/gap9_cores.py:26`).
- Cycle APIs on GAP9: `gap_fc_readhwtimer()` and `gap_cl_readhwtimer()` (used by `Fir/Test.c` and the MatMul benchmark), `pi_perf_conf/start/stop/read(PI_PERF_CYCLES|PI_PERF_ACTIVE_CYCLES|...)`, and `gv_pcer_dump_*` for GVSoC PCER dumps.
- Host status: Ubuntu 24.04, GCC 13.3, CMake 3.28, Python 3.12, 32 cores, 123 GB RAM. Missing packages (from `requirements_apt_ubuntu_22_04.md`): `device-tree-compiler libfdt-dev flex bison libsdl2-dev libsndfile1-dev libsamplerate0-dev libelf-dev`, and the Qt6/gtkwave packages if the GUI is wanted. The Python modules are also missing (e.g. `prettytable`). No docker. Passwordless sudo works. Build time was not measured.
- Per ORACLE.md, GVSoC is instruction-accurate but not cycle-exact. `ri5ky_testbench` has a "slow mode", which is the cycle-accurate executor enabled via PCMR.active; see `calib.h`.

## 4. ISA mapping

- GAP9 GCC multilibs: `rv32imcxgap8`, `rv32imcxgap9`, `rv32imcxgap10` (ilp32). SDK spelling: `-march=rv32imcxgap9 -mPE=8 -mFC=1 -mint64`. The predefined macros include `__gap9__ __pulp__ _pulp __riscv_flen=32 __riscv_float_abi_soft`. **FP uses integer registers**: `fmadd.s` is encoded on x10..x12 with a soft ABI, which is effectively Zfinx. `float16` and `float16alt` are builtin GCC types (`v2h`/`v2ah` are vectors of them).
- `-march` spellings the fork accepts (probed): `rv32imc_xpulpv2` and `rv32imc_xpulpv` on all three; `rv32imc_zfinx_xpulpv2` on all three; `rv32imcf_xpulpv2`, `rv32imcf_zfh_xpulpv2` and `rv32imc_zfinx_zhinx_xpulpv2` on 19 and 20 (on ref-18 use canonical `rv32imfc_…`). `xgap9` and `xpulpv3` are rejected by all three. The fork's PULP extension names in `wt/int-20/llvm/lib/Target/RISCV/RISCVFeatures.td:1481-1520` are `xpulpv` (v2.0), `xfrep`, `xdma`, `xssr`, `xmempool`. `RISCVInstrInfoXsmallfloatGen.td` adds `xfalthalf`, `xfvechalf`, `xfvecalthalf`, `xfaux*` and others; these are MC-level only, Snitch/FPR-based, and untested against GAP9 encodings. There are no Xgap, Int64 or cplx names. `BareMetal.cpp:78` has an `rv32imfcxpulpv2/ilp32f` multilib.
- Equivalent `-march` for our clang: **`-march=rv32imc_zfinx_xpulpv2 -mabi=ilp32`** (add `_zhinx` for scalar fp16 on 19/20).
- Encoding check: the GCC `rv32imcxgap9` output for `lp.setup`, `p.lw rd,4(rs!)`, `pv.sdotsp.h`, `p.mac`, `pv.add.h` and `p.clip` disassembles identically with `build/int-20/bin/llvm-objdump --mattr=+xpulpv,+zfinx`.
- **GAP9 features the fork does not support** (builtin diff: 182 `__builtin_pulp_*` used by the GAP9 headers against 174 defined in `wt/int-20/clang/include/clang/Basic/BuiltinsRISCVXpulp.td`; 43 are missing):
  - complex Q15: `pv.cplxmul.h.{r,i}[.divN]`, `pv.cplxconj.h`, `pv.subrotmj.h`; builtins `cplxmuls*`, `cplx_conj`, `cplxmjrot2`, `sub2rotmj`;
  - `pv.add/sub.{h,b}.div{2,4,8}` (`add2div2`, …), `pv.pack.h.h`, `p.bitrev`;
  - Int64 register-pair ops (`add.d`, `p.mac.d`, …; enabled by `-mint64`) and `mul64h*`;
  - fractional multiply (`mulfs/mulfu[N|RN]`, `macfs/macfu[N|RN]`);
  - `truncb/trunch`, `vitmax2/vitsel2`;
  - fp builtins `f32abs/min/max/sqrt`, `rintsf2/rupsf2/rdownsf2`, and all `__builtin_pulp_f16*`/`f16alt*` (Xfvec SIMD fp16, `vfadd.h`, …);
  - `float16alt` (PULP bf16-like Xf16alt, whose encoding differs from Zfbfmin);
  - GCC's `__builtin_shuffle` (used in `MatMulDSPf16.c`).
- **Fork bugs found while probing, all inherited from ref-18:**
  1. `clang/lib/Sema/SemaRISCV.cpp` (the block after line 1440): the rounding check calls `ArgValue(*RoundArgNum)` where it should call `ArgValue(*NormArgNum)`. Every `gap_mulsRN`/`gap_macsRN`/`gap_roundnorm`-style call with a constant norm therefore fails with "argument value 16384 is outside the valid range [-2147483648, -2147483648]". This affects `PreProcessingFix.c` and `FastFixedApprox.h`.
  2. The `PULPHardwareLoops::convertToHardwareLoop` segfault. It also hits real SDK code, not only the unsigned-trip-count loops in `19-vs-18`.
  3. The `getMinRVVVectorSizeInBits` assertion, reached from RISCVTargetTransformInfo through RISCVISelLowering on xpulpv2 packed vector types without V.
  4. The `p.clip` immediate off by one, described in the TL;DR.

## 5. Plan for the sweep

**Corpus (12 kernels).** Copy them into `benchmarks/gap9-sweep/src/`, with one kernel per TU plus a shared `harness.c`. Keep the SDK sources unmodified and use the shim header below.

1. `KerFirSeqBaseline` / `KerFirSeq` (int16) from `FirBasicKernelsFix.c`
2. `KerFirSeqf32` from `FirBasicKernelsf32.c` (fp32 under Zfinx)
3. `matmul_worker` int16 from `getting_started/cluster_kernels.c`, single-core
4. `MatMulSimpleSeq` fp32 from `benchmarks/MatMul/MatMulRunTest.c`
5. `KerParMatMulDSP_Fix16` from `MatMulDSP.c`, with core count forced to 1
6. `MatVectDSP.c`, fixed-point part
7. `MatAddDSP.c`, fixed-point part
8. `PreProcessingFix.c` (pre-emphasis and windowing)
9. `CmplxFunctionsFix.c` (`CmplxMagSquared_Fix16`)
10. Radix-2 FFT butterfly loop from `FftLibraryFix.c`, extracted without DMA and with a small twiddle table
11. The int8 dot product `gap_sumdotp4` loop (DotProd pattern)
12. The existing `benchmarks/19-vs-18/kernels.c` loops, as a regression anchor

Shim, for compiling outside PMSIS (GCC accepted it for all 7 probed files). Put it in a directory that comes first in `-I` so it replaces `at_api.h`:

```c
#pragma once
#include <stdint.h>
#include <string.h>
typedef signed short v2s __attribute__((vector_size(4)));  /* + v2u, v4s, v4u */
#ifdef __clang__
typedef _Float16 float16; typedef _Float16 float16alt;      /* float16alt is WRONG (bf16): compile probing only */
#endif
typedef float16 v2h __attribute__((vector_size(4))); typedef float16alt v2ah __attribute__((vector_size(4)));
typedef v2s V2S; typedef float16 f16; typedef float16alt f16a;
#define gap_coreid() 0
#define gap_ncore() 1
#define gap_waitbarrier(x) ((void)0)
#define __GAP_H__ 1
#include "GapBuiltins.h"
#define L1_CL_MEM
#define L2_MEM
#define AT_L2_MEM
#define AT_NORM(x,n) gap_roundnorm_reg((x),(n))
```

Include paths: `-I<shim> -I$AT/BasicKernels/DSP_Libraries -I$AT/BasicKernels/DSP_Libraries/FastMathFunctions -I$AT/Emulation -isystem /home/ubuntu/gap_riscv_toolchain_ubuntu/riscv32-unknown-elf/include`, where `AT=/home/ubuntu/gap_sdk_release/tools/autotiler_v3`. Defines: `-D__gap9__ -D__GAP9__ -D__pulp__`.

**Compile matrix.** Run -O2 and -O3; C is the path to each clang (`toolchains/ref-18/bin`, `build/int-19/bin`, `build/int-20/bin`):

```
$C/clang --target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax \
  -O3 -funsigned-char -fno-jump-tables -ffunction-sections -c k.c -o k.o
riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -mint64 -O3 -funsigned-char \
  -fno-jump-tables -ffunction-sections -c k.c -o k.o      # GAP9 GCC reference
```

Keep failures as rows, as the 19-vs-18 study did, and never hide them. Expected failures today: kernels 1, 2 and 9 crash; kernel 8 hits the Sema error; any fp16 kernel fails.

**Run (preferred: gvsoc2 `ri5ky_testbench`).**

1. Install the apt and pip deps. Owner approval is needed.
2. `cd /home/ubuntu/gap_sdk_release && source configs/gap9_evk_audio.sh && make gvsoc2.all GVSOC2_TARGETS="gap.gap9.evk ri5ky_testbench"`
3. Harness: our own `crt0.S` (boot at 0x80, set sp to the top of the 1 MB RAM, call `main`, write the return code to `0x10000004`). It reads `*(volatile uint32_t*)0x10000008` around N repetitions of each kernel, checks output against a golden (host-computed, or GCC's output), and prints through putchar at 0x10000000.
4. Link with `build/int-20/bin/ld.lld`, or GAP `riscv32-unknown-elf-gcc -nostartfiles -T link.ld`, against the GAP `libgcc.a` (`lib/gcc/riscv32-unknown-elf/7.1.1/rv32imcxgap9/ilp32`). Use the same harness object for all compilers; only the kernel `.o` changes.
5. `env -u PYTHONPATH /home/ubuntu/gap_sdk_release/install/gvsoc2/bin/gvrun --target=ri5ky_testbench --parameter <binary param> run`. Check the exact binary parameter name in `ri5ky_testbench.py`.
6. Compare with the ORACLE.md checks 2-5: output identical, cycles within 2%, `mix_diff.py`.

**Alternative run** (full GAP9 chip, cluster): a PMSIS app built by the SDK with `CONFIG_PLATFORM_GVSOC=y` (legacy, `make all`) or `CONFIG_PLATFORM_GVSOC2=y`. Swap in clang kernel objects via the `GAP_RISCV_CC` wrapper, and read `gap_cl_readhwtimer`/`pi_perf_read`. This is heavier and needs the whole SDK build.

**Static fallback (can start now; no simulator needed).** For each successful `.o`:

```
build/int-20/bin/llvm-objdump -d --mattr=+xpulpv,+zfinx,+zhinx k.o > k.<cc>.dis
python3 scripts/mix_diff.py k.ref-18.dis k.int-20.dis --out mix.json
build/int-20/bin/llvm-readelf -sW k.o    # per-function sizes (as benchmarks/19-vs-18/run.py does)
```

Also disassemble the GCC objects with the same `llvm-objdump` flags; the encodings match, so the mnemonics are comparable, which gives a GCC-versus-LLVM mix reference. `benchmarks/19-vs-18/run.py` and `analyze.py` can be reused with a new source list.

## Blockers, in order

1. The fork's hwloop crash, the TTI/RVV assertion and the Sema RN bug stop the real DSP kernels from compiling on every version. The corpus is limited to what compiles until these are fixed. Note that ORACLE.md "reference defines correct" means ref-18 fails the same way.
2. No simulator binary. gvsoc2 needs apt and pip deps plus a build of unknown duration, and `ri5ky_testbench` is not in the default `GVSOC2_TARGETS`.
3. The suspected `p.clip` miscompile. Validate outputs on the simulator before trusting cycle counts.
4. GAP9-only instructions (cplx, divN, Int64, Xfvec fp16, float16alt) are out of scope for the fork. Kernels using them either fail to compile or compare GCC's special instructions against LLVM's generic code; label such rows "not like-for-like".
5. The SDK build flow is GCC-only. clang objects need a wrapper or pre-built `.o` injection, with `-mno-relax` (GNU ld 2.28 is from 2017).
