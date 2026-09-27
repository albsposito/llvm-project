# GAP9 SDK kernel sweep: runtime (cycle counts on GVSoC)

**Simulator caveat.** Numbers come from the GAP9 SDK's GVSoC2 `ri5ky_testbench` (one RI5CY/GAP9 core, 1 MB zero-latency RAM), run in its slow timing mode. GVSoC is an instruction-accurate simulator with a timing model (pipeline stalls, hardware-loop and branch costs), **not** a cycle-exact model of GAP9 silicon: no caches/TCDM banking/cluster DMA are modelled and memory latency is 0. Treat ratios between builds as meaningful, absolute cycles as indicative.

Per build: one warm-up call, then 4 timed calls; `cycles` = MMIO simulator cycles per call (`bench_cycles()` delta / 4), `instrs` = retired instructions per call (RI5CY PCCR instret, CSR 0x781). Runs are deterministic (repeat runs give identical counts). The timed region includes the call(s) and, for the per-element micro kernels, the driver's call loop.

## Summary

Geometric mean of cycle ratios vs **ref18**, over the kernels where every LLVM build (ref18, port19, port20, port20fix, port20fix2) ran and produced the reference checksum (WRONG RESULT builds excluded):

| opt | ratio | all such kernels | n | SDK/loop kernels only (no call-loop micro kernels) | n |
|---|---|---|---|---|---|
| O2 | port19/ref18 | **1.000** | 12 | 1.000 | 3 |
| O2 | port20/ref18 | **0.949** | 12 | 1.000 | 3 |
| O2 | port20fix/ref18 | **0.949** | 12 | 1.000 | 3 |
| O2 | port20fix2/ref18 | **0.949** | 12 | 1.000 | 3 |
| O2 | gcc/ref18 | **0.804** | 12 | 0.884 | 3 |
| O3 | port19/ref18 | **1.000** | 12 | 1.000 | 3 |
| O3 | port20/ref18 | **0.949** | 12 | 1.000 | 3 |
| O3 | port20fix/ref18 | **0.949** | 12 | 1.000 | 3 |
| O3 | port20fix2/ref18 | **0.949** | 12 | 1.000 | 3 |
| O3 | gcc/ref18 | **0.805** | 12 | 0.887 | 3 |

- O2 geomean set (12): k03_matmul_worker_i16, k06_matvect_dsp_f32, k11_dotprod_i8, k12_packed_add8, k12_packed_add16, k12_packed_shift8, k12_packed_shift16, k12_packed_max8, k12_dot8, k12_dot16, k12_bit_count, k12_mac
- O3 geomean set (12): k03_matmul_worker_i16, k06_matvect_dsp_f32, k11_dotprod_i8, k12_packed_add8, k12_packed_add16, k12_packed_shift8, k12_packed_shift16, k12_packed_max8, k12_dot8, k12_dot16, k12_bit_count, k12_mac

Per compiler, over all kernel x opt builds (27 kernels x 2 opts): ok / wrong result / compile or link failure / hang or simulator failure:

| compiler | ok | wrong | compile-fail | hang/sim-fail |
|---|---|---|---|---|
| ref18 | 24 | 5 | 25 | 0 |
| port19 | 24 | 5 | 25 | 0 |
| port20 | 36 | 5 | 13 | 0 |
| gcc | 54 | 0 | 0 | 0 |
| port20fix | 41 | 0 | 13 | 0 |
| port20fix2 | 54 | 0 | 0 | 0 |

Geometric mean of cycle ratios vs **gcc** (GAP9 GCC), per LLVM compiler, over the kernels where that compiler's build is correct at that opt level (so the kernel sets differ between compilers; n given). "SDK kernels" = kernels taken from the GAP9 SDK (k01-k10); "all" adds the kernels written for the sweep (k11, clip, k12 micro kernels).

| opt | compiler | SDK kernels /gcc | n | all correct kernels /gcc | n |
|---|---|---|---|---|---|
| O2 | ref18 | 1.203 | 2 | **1.243** | 12 |
| O2 | port19 | 1.203 | 2 | **1.243** | 12 |
| O2 | port20 | 1.132 | 3 | **1.182** | 18 |
| O2 | port20fix | 1.105 | 4 | **1.177** | 21 |
| O2 | port20fix2 | 1.046 | 10 | **1.138** | 27 |
| O3 | ref18 | 1.197 | 2 | **1.242** | 12 |
| O3 | port19 | 1.197 | 2 | **1.242** | 12 |
| O3 | port20 | 1.129 | 3 | **1.181** | 18 |
| O3 | port20fix | 1.129 | 3 | **1.185** | 20 |
| O3 | port20fix2 | 1.062 | 10 | **1.144** | 27 |

- WRONG RESULT (checksum differs from GAP9 GCC, confirmed by the host build): `clip` on port19 O2, port19 O3, port20 O2, port20 O3, ref18 O2, ref18 O3; `k05_matmul_dsp_fix16` on port19 O2, port20 O2, ref18 O2; `k12_bit_extract` on port19 O2, port19 O3, port20 O2, port20 O3, ref18 O2, ref18 O3. No speed number from these builds is used anywhere below.
  - `clip`: p.clip off-by-one: __builtin_pulp_clip(x,-128,127) encoded as p.clip ...,7 (GCC 8) = clamp to [-64,63]
  - `k05_matmul_dsp_fix16`: p.clip off-by-one: gap_clip(x,15) encoded as p.clip ...,15 (GCC 16) = clamp to [-16384,16383]
  - `k12_bit_extract`: p.extractu off-by-one: __builtin_pulp_bextractu(a,8,8) encoded as p.extractu ...,8,8 (GCC 7,8) = 9-bit field

## Setup

- **ref18**: `/home/ubuntu/llvm-project/pulp-llvm-port/toolchains/ref-18/bin/clang` (clang version 18.1.4 (https://github.com/albsposito/llvm-project.git 1c33bd3dba2bd1f3942842135daba498af1b3eb5))
- **port19**: `/home/ubuntu/llvm-project/pulp-llvm-port/toolchains/port-19/bin/clang` (clang version 19.1.7 (https://github.com/albsposito/llvm-project.git 9b2edaf923ad46816535d7361e9daef79be0529c))
- **port20**: `/home/ubuntu/llvm-project/pulp-llvm-port/toolchains/port-20/bin/clang` (clang version 20.1.8 (https://github.com/albsposito/llvm-project.git b6cd96bd37263d1ab670bf7b54fd64253fc87619))
- **gcc**: `/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc` (riscv32-unknown-elf-gcc (GCC) 7.1.1 20170509)
- **port20fix**: `/home/ubuntu/llvm-project/pulp-llvm-port/toolchains/port-20fix/bin/clang` (clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 6e4c7f2a471f58958f091e21cf5cf560410d8363))
- **port20fix2**: `/home/ubuntu/llvm-project/pulp-llvm-port/toolchains/port-20fix2/bin/clang` (clang version 20.1.8 (https://github.com/albsposito/llvm-project.git d9911b45132754836b0f047b383e230d57c41686))
- Kernel TU: compiled with exactly the static sweep command (`../run.py`: LLVM `--target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax -isystem /home/ubuntu/gap_riscv_toolchain_ubuntu/riscv32-unknown-elf/include`, GCC `-march=rv32imcxgap9 -mPE=8 -mFC=1`, sweep shim + SDK includes, `-O2`/`-O3`). Every clang kernel object is byte-identical to the static sweep's object in `../build/` (checked by sha256, `kernel_obj_same_as_static_sweep`).
- Driver (`drivers/<kernel>.c`, helpers in `rt.h`) and `rt_libc.c` (memcpy/memset): same compiler, same flags and opt level, plus `-ffreestanding -fno-builtin`. Runtime: `../sim/crt0.S`, `../sim/link.ld`, `../sim/bench.h`. LLVM builds link with that toolchain's `ld.lld` (+ GAP9 `libgcc.a` for 64-bit helpers), GCC builds with the GCC driver and `-lgcc`.
- Driver trip counts are read from volatile globals: port20 crashes on constant-trip-count hardware loops at object emission (`lp.setupi`, see `../sim/README.md`). Untimed driver helpers (PRNG fill, FNV-1a hash, printing) are `optnone` under clang because ref18/port19 crash in the "PULP Hardware Loops" pass on such simple loops; they run outside the timed region.
- Host reference: `gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0` `-O2 -fwrapv`, same driver (`-DRT_HOST`) + the same kernel source, with `hostshim/at_api.h` defining `__EMUL__` (not `__pulp__`) so the SDK's `Emulation/GapBuiltins.h` uses its plain-C branch; the sweep's own TUs that call `__builtin_pulp_*` directly get the models in `hostshim/pulp_emul.h`.
- Simulator: GVSoC2 ri5ky_testbench via ../sim/run_sim.sh (crt0.S slow mode, PCCR on); builds and simulations run in parallel (one thread per core).

| kernel | workload | host reference semantics | host == GCC -O2 |
|---|---|---|---|
| k01_fir_fix16 | KerFirSeq int16 FIR, 256 samples x 32 taps, Norm 12 (streaming delay line; KerFirSeqBaseline run once untimed, both outputs checksummed) | SDK Emulation/GapBuiltins.h (__EMUL__ plain-C branch) | yes |
| k02_fir_f32 | KerFirSeqf32 fp32 FIR, 256 samples x 32 taps, integer-valued samples/taps (SDK int accumulators; all arithmetic exact), baseline run once untimed | SDK Emulation/GapBuiltins.h (__EMUL__ plain-C branch) | yes |
| k03_matmul_worker_i16 | C[32x32] int32 = A[32x32] x B[32x32] int16, values in [-2048,2047] | SDK Emulation/GapBuiltins.h (__EMUL__ plain-C branch) | yes |
| k04_matmul_simple_f32 | MatMulSimpleSeq fp32 Out[32x32] = M1[32x32] x M2[32x32] (non-transposed), values in [-1,1) | plain C (no PULP builtins) | no (fp32: max rel err 1.3e-05; x86 has no fused multiply-add, GCC/clang RISC-V builds fuse) |
| k05_matmul_dsp_fix16 | Out[32x32] int16 = clip16(roundnorm(In1[32x32] x In2[32x32], 11)), values in [-4096,4095] (35/1024 outputs saturate int16, 283/1024 fall outside [-16384,16383]) | SDK Emulation/GapBuiltins.h (__EMUL__ plain-C branch) | yes |
| k06_matvect_dsp_f32 | Out[64] = In2[64x256] x In1[256], fp32 in [-1,1) | SDK Emulation/GapBuiltins.h (__EMUL__ plain-C branch) | no (fp32: max rel err 2.7e-05; x86 has no fused multiply-add, GCC/clang RISC-V builds fuse) |
| k07_matadd_dsp_fix16 | KerParMatAdd_DSP_Fix16 Out[32x32] int16 = clip16(roundnorm(In1+In2, 1)), full-range int16 | SDK Emulation/GapBuiltins.h (__EMUL__ plain-C branch) | yes |
| k08_preprocessing_fix | PreEmphasis (Q15 0.97, dynamic shift to Q13) + WindowingReal2Cmplx_Fix16 (400-point integer Welch window, zero-padded to 512 complex), 512 int16 samples | SDK Emulation/GapBuiltins.h (__EMUL__ plain-C branch) | yes |
| k09_cmplx_fix | 512 complex int16 -> re^2+im^2 (uint32) | SDK Emulation/GapBuiltins.h (__EMUL__ plain-C branch) | yes |
| k10a_fft_radix2_scalar | Radix2FFT_DIF_Scalar 256-point complex int16 FFT (SDK R2_Twiddles_fix_256), one fresh input copy per call | SDK Emulation/GapBuiltins.h (__EMUL__ plain-C branch) | yes |
| k11_dotprod_i8 | 1024 int8 x int8 dot product (256 x v4s) | SDK Emulation/GapBuiltins.h (__EMUL__ plain-C branch) | yes |
| clip | clip_s8 + clipu_u8 on 1024 ints in [-400,400], one call each per element | hand-written builtin model (hostshim/pulp_emul.h) | yes |
| k12_packed_add8 | one call per element, 1024 random words (call-loop dominated) | plain C (no PULP builtins) | yes |
| k12_packed_add16 | one call per element, 1024 random words (call-loop dominated) | plain C (no PULP builtins) | yes |
| k12_packed_shift8 | one call per element, 1024 random words (call-loop dominated) | plain C (no PULP builtins) | yes |
| k12_packed_shift16 | one call per element, 1024 random words (call-loop dominated) | plain C (no PULP builtins) | yes |
| k12_packed_max8 | one call per element, 1024 random words (call-loop dominated) | hand-written builtin model (hostshim/pulp_emul.h) | yes |
| k12_dot8 | one call per element, 1024 random words (call-loop dominated) | hand-written builtin model (hostshim/pulp_emul.h) | yes |
| k12_dot16 | one call per element, 1024 random words (call-loop dominated) | hand-written builtin model (hostshim/pulp_emul.h) | yes |
| k12_bit_extract | one call per element, 1024 random words (call-loop dominated) | hand-written builtin model (hostshim/pulp_emul.h) | yes |
| k12_bit_count | one call per element, 1024 random words (call-loop dominated) | plain C (no PULP builtins) | yes |
| k12_mac | one call per element, 1024 random words (call-loop dominated) | plain C (no PULP builtins) | yes |
| k12_sum_loop | sum of 4096 uint32 | plain C (no PULP builtins) | yes |
| k12_copy_loop | d[i]=a[i]+7, 4096 uint32 | plain C (no PULP builtins) | yes |
| k12_dot8_loop | sdotsp4 over 1024 v4s | hand-written builtin model (hostshim/pulp_emul.h) | yes |
| k12_dot16_loop | sdotsp2 over 1024 v2s (int16 in [-2048,2047]) | hand-written builtin model (hostshim/pulp_emul.h) | yes |
| k12_packed_add8_loop | v4u add over 1024 words | plain C (no PULP builtins) | yes |

## Results: kernel x compiler x opt

Cell: `status cycles / instrs` per call. `WRONG` = ran, checksum differs from the GCC reference (cycles shown for information only, never compared). compile-fail/link-fail/sim-fail give the reason below the table.

| kernel | opt | ref18 | port19 | port20 | gcc | port20fix | port20fix2 |
|---|---|---|---|---|---|---|---|
| k01_fir_fix16 | O2 | compile-fail | compile-fail | compile-fail | ok 17074 / 14225 | compile-fail | ok 16015 / 14766 |
| k01_fir_fix16 | O3 | compile-fail | compile-fail | compile-fail | ok 17192 / 14355 | compile-fail | ok 16014 / 14765 |
| k02_fir_f32 | O2 | compile-fail | compile-fail | compile-fail | ok 42411 / 42122 | compile-fail | ok 39665 / 39499 |
| k02_fir_f32 | O3 | compile-fail | compile-fail | compile-fail | ok 37677 / 37388 | compile-fail | ok 39665 / 39499 |
| k03_matmul_worker_i16 | O2 | ok 159101 / 124186 | ok 159101 / 124186 | ok 159101 / 123162 | ok 146009 / 113178 | ok 159101 / 123162 | ok 159101 / 123162 |
| k03_matmul_worker_i16 | O3 | ok 159103 / 124187 | ok 159103 / 124187 | ok 159103 / 123163 | ok 145917 / 113085 | ok 159103 / 123163 | ok 159103 / 123163 |
| k04_matmul_simple_f32 | O2 | compile-fail | compile-fail | compile-fail | ok 143874 / 111044 | compile-fail | ok 175559 / 175520 |
| k04_matmul_simple_f32 | O3 | compile-fail | compile-fail | compile-fail | ok 143840 / 111010 | compile-fail | ok 174504 / 174437 |
| k05_matmul_dsp_fix16 | O2 | **WRONG** (44060 / 40883) | **WRONG** (75017 / 71240) | **WRONG** (43923 / 40626) | ok 42748 / 41313 | ok 43923 / 40626 | ok 43643 / 40370 |
| k05_matmul_dsp_fix16 | O3 | compile-fail | compile-fail | compile-fail | ok 42748 / 41313 | compile-fail | ok 43513 / 40495 |
| k06_matvect_dsp_f32 | O2 | ok 66737 / 66603 | ok 66737 / 66603 | ok 66737 / 66603 | ok 50290 / 50161 | ok 66737 / 66603 | ok 66737 / 66603 |
| k06_matvect_dsp_f32 | O3 | ok 66350 / 66346 | ok 66350 / 66346 | ok 66350 / 66346 | ok 50477 / 50222 | ok 66350 / 66346 | ok 66350 / 66346 |
| k07_matadd_dsp_fix16 | O2 | compile-fail | compile-fail | compile-fail | ok 7199 / 6174 | compile-fail | ok 7201 / 6174 |
| k07_matadd_dsp_fix16 | O3 | compile-fail | compile-fail | compile-fail | ok 7199 / 6174 | compile-fail | ok 7201 / 6174 |
| k08_preprocessing_fix | O2 | compile-fail | compile-fail | compile-fail | ok 11435 / 7961 | compile-fail | ok 11456 / 8624 |
| k08_preprocessing_fix | O3 | compile-fail | compile-fail | compile-fail | ok 11438 / 8472 | compile-fail | ok 11453 / 8622 |
| k09_cmplx_fix | O2 | compile-fail | compile-fail | ok 2073 / 1558 | ok 2067 / 1554 | ok 2073 / 1558 | ok 2073 / 1558 |
| k09_cmplx_fix | O3 | compile-fail | compile-fail | ok 2073 / 1558 | ok 2067 / 1554 | ok 2073 / 1558 | ok 2073 / 1558 |
| k10a_fft_radix2_scalar | O2 | compile-fail | compile-fail | compile-fail | ok 23069 / 23055 | compile-fail | ok 22800 / 22788 |
| k10a_fft_radix2_scalar | O3 | compile-fail | compile-fail | compile-fail | ok 21799 / 21657 | compile-fail | ok 22807 / 22795 |
| k11_dotprod_i8 | O2 | ok 1047 / 789 | ok 1047 / 788 | ok 1046 / 788 | ok 1046 / 789 | ok 1046 / 788 | ok 1046 / 788 |
| k11_dotprod_i8 | O3 | ok 1047 / 789 | ok 1047 / 788 | ok 1046 / 788 | ok 1046 / 789 | ok 1046 / 788 | ok 1046 / 788 |
| clip | O2 | **WRONG** (22558 / 14365) | **WRONG** (22558 / 14365) | **WRONG** (21535 / 13342) | ok 17437 / 11294 | ok 21535 / 13342 | ok 21535 / 13342 |
| clip | O3 | **WRONG** (22558 / 14365) | **WRONG** (22558 / 14365) | **WRONG** (21535 / 13342) | ok 17437 / 11294 | ok 21535 / 13342 | ok 21535 / 13342 |
| k12_packed_add8 | O2 | ok 14366 / 9245 | ok 14366 / 9245 | ok 13343 / 8222 | ok 11293 / 7198 | ok 13343 / 8222 | ok 13343 / 8222 |
| k12_packed_add8 | O3 | ok 14366 / 9245 | ok 14366 / 9245 | ok 13343 / 8222 | ok 11293 / 7198 | ok 13343 / 8222 | ok 13343 / 8222 |
| k12_packed_add16 | O2 | ok 14366 / 9245 | ok 14366 / 9245 | ok 13343 / 8222 | ok 11293 / 7198 | ok 13343 / 8222 | ok 13343 / 8222 |
| k12_packed_add16 | O3 | ok 14366 / 9245 | ok 14366 / 9245 | ok 13343 / 8222 | ok 11293 / 7198 | ok 13343 / 8222 | ok 13343 / 8222 |
| k12_packed_shift8 | O2 | ok 14362 / 9241 | ok 14362 / 9241 | ok 13339 / 8218 | ok 10265 / 6170 | ok 13339 / 8218 | ok 13339 / 8218 |
| k12_packed_shift8 | O3 | ok 14362 / 9241 | ok 14362 / 9241 | ok 13339 / 8218 | ok 10265 / 6170 | ok 13339 / 8218 | ok 13339 / 8218 |
| k12_packed_shift16 | O2 | ok 14362 / 9241 | ok 14362 / 9241 | ok 13339 / 8218 | ok 10265 / 6170 | ok 13339 / 8218 | ok 13339 / 8218 |
| k12_packed_shift16 | O3 | ok 14362 / 9241 | ok 14362 / 9241 | ok 13339 / 8218 | ok 10265 / 6170 | ok 13339 / 8218 | ok 13339 / 8218 |
| k12_packed_max8 | O2 | ok 14366 / 9245 | ok 14366 / 9245 | ok 13343 / 8222 | ok 11293 / 7198 | ok 13343 / 8222 | ok 13343 / 8222 |
| k12_packed_max8 | O3 | ok 14366 / 9245 | ok 14366 / 9245 | ok 13343 / 8222 | ok 11293 / 7198 | ok 13343 / 8222 | ok 13343 / 8222 |
| k12_dot8 | O2 | ok 16418 / 11297 | ok 16418 / 11297 | ok 15395 / 10274 | ok 13345 / 9250 | ok 15395 / 10274 | ok 15395 / 10274 |
| k12_dot8 | O3 | ok 16418 / 11297 | ok 16418 / 11297 | ok 15395 / 10274 | ok 13345 / 9250 | ok 15395 / 10274 | ok 15395 / 10274 |
| k12_dot16 | O2 | ok 19494 / 14373 | ok 19494 / 14373 | ok 18471 / 13350 | ok 16421 / 12326 | ok 18471 / 13350 | ok 18471 / 13350 |
| k12_dot16 | O3 | ok 19494 / 14373 | ok 19494 / 14373 | ok 18471 / 13350 | ok 16421 / 12326 | ok 18471 / 13350 | ok 18471 / 13350 |
| k12_bit_extract | O2 | **WRONG** (13338 / 8217) | **WRONG** (13338 / 8217) | **WRONG** (12315 / 7194) | ok 10265 / 6170 | ok 12315 / 7194 | ok 12315 / 7194 |
| k12_bit_extract | O3 | **WRONG** (13338 / 8217) | **WRONG** (13338 / 8217) | **WRONG** (12315 / 7194) | ok 10265 / 6170 | ok 12315 / 7194 | ok 12315 / 7194 |
| k12_bit_count | O2 | ok 13338 / 8217 | ok 13338 / 8217 | ok 12315 / 7194 | ok 10265 / 6170 | ok 12315 / 7194 | ok 12315 / 7194 |
| k12_bit_count | O3 | ok 13338 / 8217 | ok 13338 / 8217 | ok 12315 / 7194 | ok 10265 / 6170 | ok 12315 / 7194 | ok 12315 / 7194 |
| k12_mac | O2 | ok 16418 / 11297 | ok 16418 / 11297 | ok 15395 / 10274 | ok 13345 / 9250 | ok 15395 / 10274 | ok 15395 / 10274 |
| k12_mac | O3 | ok 16418 / 11297 | ok 16418 / 11297 | ok 15395 / 10274 | ok 13345 / 9250 | ok 15395 / 10274 | ok 15395 / 10274 |
| k12_sum_loop | O2 | compile-fail | compile-fail | ok 12310 / 8212 | ok 12308 / 8211 | ok 12310 / 8212 | ok 12310 / 8212 |
| k12_sum_loop | O3 | compile-fail | compile-fail | ok 12310 / 8212 | ok 12308 / 8211 | ok 12310 / 8212 | ok 12310 / 8212 |
| k12_copy_loop | O2 | compile-fail | compile-fail | ok 28688 / 16399 | ok 16402 / 12305 | ok 28688 / 16399 | ok 28688 / 16399 |
| k12_copy_loop | O3 | compile-fail | compile-fail | ok 28688 / 16399 | ok 16402 / 12305 | ok 28688 / 16399 | ok 28688 / 16399 |
| k12_dot8_loop | O2 | compile-fail | compile-fail | ok 4120 / 3093 | ok 4117 / 3092 | ok 4120 / 3093 | ok 4120 / 3093 |
| k12_dot8_loop | O3 | compile-fail | compile-fail | ok 4120 / 3093 | ok 4117 / 3092 | ok 4120 / 3093 | ok 4120 / 3093 |
| k12_dot16_loop | O2 | compile-fail | compile-fail | ok 4120 / 3093 | ok 4117 / 3092 | ok 4120 / 3093 | ok 4120 / 3093 |
| k12_dot16_loop | O3 | compile-fail | compile-fail | ok 4120 / 3093 | ok 4117 / 3092 | ok 4120 / 3093 | ok 4120 / 3093 |
| k12_packed_add8_loop | O2 | compile-fail | compile-fail | ok 8209 / 5136 | ok 5139 / 4114 | ok 8209 / 5136 | ok 8209 / 5136 |
| k12_packed_add8_loop | O3 | compile-fail | compile-fail | ok 8209 / 5136 | ok 5139 / 4114 | ok 8209 / 5136 | ok 8209 / 5136 |

- **compile-fail: assert: Assertion `!NodePtr->isKnownSentinel()' failed (pass 'PULP Hardware Loop Fixup' on @KerParMatMulDSP_Fix16)** — k05_matmul_dsp_fix16 port20fix O3
- **compile-fail: assert: Assertion `hasVInstructions() && "Tried to get vector length without Zve or V extension support!"' failed** — k01_fir_fix16 ref18 O3, k01_fir_fix16 port19 O3, k01_fir_fix16 port20 O3, k05_matmul_dsp_fix16 ref18 O3, k05_matmul_dsp_fix16 port19 O3, k05_matmul_dsp_fix16 port20 O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @CmplxMagSquared_Fix16** — k09_cmplx_fix ref18 O2, k09_cmplx_fix port19 O2, k09_cmplx_fix ref18 O3, k09_cmplx_fix port19 O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @KerFirSeq** — k01_fir_fix16 ref18 O2, k01_fir_fix16 port19 O2, k01_fir_fix16 port20 O2, k01_fir_fix16 port20fix O2, k01_fir_fix16 port20fix O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @KerFirSeqBaselinef32** — k02_fir_f32 ref18 O2, k02_fir_f32 port19 O2, k02_fir_f32 ref18 O3, k02_fir_f32 port19 O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @KerFirSeqf32** — k02_fir_f32 port20 O2, k02_fir_f32 port20fix O2, k02_fir_f32 port20 O3, k02_fir_f32 port20fix O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @KerParMatAdd_DSP_Fix16** — k07_matadd_dsp_fix16 ref18 O2, k07_matadd_dsp_fix16 port19 O2, k07_matadd_dsp_fix16 port20 O2, k07_matadd_dsp_fix16 port20fix O2, k07_matadd_dsp_fix16 ref18 O3, k07_matadd_dsp_fix16 port19 O3, k07_matadd_dsp_fix16 port20 O3, k07_matadd_dsp_fix16 port20fix O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @MatMulSimpleSeq** — k04_matmul_simple_f32 ref18 O2, k04_matmul_simple_f32 port19 O2, k04_matmul_simple_f32 port20 O2, k04_matmul_simple_f32 port20fix O2, k04_matmul_simple_f32 ref18 O3, k04_matmul_simple_f32 port19 O3, k04_matmul_simple_f32 port20 O3, k04_matmul_simple_f32 port20fix O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @Radix2FFT_DIF_Scalar** — k10a_fft_radix2_scalar ref18 O2, k10a_fft_radix2_scalar port19 O2, k10a_fft_radix2_scalar port20 O2, k10a_fft_radix2_scalar port20fix O2, k10a_fft_radix2_scalar ref18 O3, k10a_fft_radix2_scalar port19 O3, k10a_fft_radix2_scalar port20 O3, k10a_fft_radix2_scalar port20fix O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @WindowingReal2Cmplx_PadCenter_Fix32** — k08_preprocessing_fix port20fix O2, k08_preprocessing_fix port20fix O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @copy_loop** — k12_copy_loop ref18 O2, k12_copy_loop port19 O2, k12_copy_loop ref18 O3, k12_copy_loop port19 O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @dot16_loop** — k12_dot16_loop ref18 O2, k12_dot16_loop port19 O2, k12_dot16_loop ref18 O3, k12_dot16_loop port19 O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @dot8_loop** — k12_dot8_loop ref18 O2, k12_dot8_loop port19 O2, k12_dot8_loop ref18 O3, k12_dot8_loop port19 O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @packed_add8_loop** — k12_packed_add8_loop ref18 O2, k12_packed_add8_loop port19 O2, k12_packed_add8_loop ref18 O3, k12_packed_add8_loop port19 O3
- **compile-fail: crash: crash in pass 'PULP Hardware Loops' on @sum_loop** — k12_sum_loop ref18 O2, k12_sum_loop port19 O2, k12_sum_loop ref18 O3, k12_sum_loop port19 O3
- **compile-fail: error: $SDK/tools/autotiler_v3/BasicKernels/DSP_Libraries/WindowFunctions/PreProcessingFix.c:83:42: error: argument value 16384 is outside the valid range [-2147483648, -2147483648]** — k08_preprocessing_fix ref18 O2, k08_preprocessing_fix port19 O2, k08_preprocessing_fix port20 O2, k08_preprocessing_fix ref18 O3, k08_preprocessing_fix port19 O3, k08_preprocessing_fix port20 O3

## Cycle ratios vs ref18 (only where both builds ran and are correct)

| kernel | opt | ref18 cycles | port19/ref18 | port20/ref18 | port20fix/ref18 | port20fix2/ref18 | gcc/ref18 |
|---|---|---|---|---|---|---|---|
| k03_matmul_worker_i16 | O2 | 159101 | 1.000 | 1.000 | 1.000 | 1.000 | 0.918 |
| k03_matmul_worker_i16 | O3 | 159103 | 1.000 | 1.000 | 1.000 | 1.000 | 0.917 |
| k06_matvect_dsp_f32 | O2 | 66737 | 1.000 | 1.000 | 1.000 | 1.000 | 0.754 |
| k06_matvect_dsp_f32 | O3 | 66350 | 1.000 | 1.000 | 1.000 | 1.000 | 0.761 |
| k11_dotprod_i8 | O2 | 1047 | 1.000 | 0.999 | 0.999 | 0.999 | 0.999 |
| k11_dotprod_i8 | O3 | 1047 | 1.000 | 0.999 | 0.999 | 0.999 | 0.999 |
| k12_packed_add8 | O2 | 14366 | 1.000 | 0.929 | 0.929 | 0.929 | 0.786 |
| k12_packed_add8 | O3 | 14366 | 1.000 | 0.929 | 0.929 | 0.929 | 0.786 |
| k12_packed_add16 | O2 | 14366 | 1.000 | 0.929 | 0.929 | 0.929 | 0.786 |
| k12_packed_add16 | O3 | 14366 | 1.000 | 0.929 | 0.929 | 0.929 | 0.786 |
| k12_packed_shift8 | O2 | 14362 | 1.000 | 0.929 | 0.929 | 0.929 | 0.715 |
| k12_packed_shift8 | O3 | 14362 | 1.000 | 0.929 | 0.929 | 0.929 | 0.715 |
| k12_packed_shift16 | O2 | 14362 | 1.000 | 0.929 | 0.929 | 0.929 | 0.715 |
| k12_packed_shift16 | O3 | 14362 | 1.000 | 0.929 | 0.929 | 0.929 | 0.715 |
| k12_packed_max8 | O2 | 14366 | 1.000 | 0.929 | 0.929 | 0.929 | 0.786 |
| k12_packed_max8 | O3 | 14366 | 1.000 | 0.929 | 0.929 | 0.929 | 0.786 |
| k12_dot8 | O2 | 16418 | 1.000 | 0.938 | 0.938 | 0.938 | 0.813 |
| k12_dot8 | O3 | 16418 | 1.000 | 0.938 | 0.938 | 0.938 | 0.813 |
| k12_dot16 | O2 | 19494 | 1.000 | 0.948 | 0.948 | 0.948 | 0.842 |
| k12_dot16 | O3 | 19494 | 1.000 | 0.948 | 0.948 | 0.948 | 0.842 |
| k12_bit_count | O2 | 13338 | 1.000 | 0.923 | 0.923 | 0.923 | 0.770 |
| k12_bit_count | O3 | 13338 | 1.000 | 0.923 | 0.923 | 0.923 | 0.770 |
| k12_mac | O2 | 16418 | 1.000 | 0.938 | 0.938 | 0.938 | 0.813 |
| k12_mac | O3 | 16418 | 1.000 | 0.938 | 0.938 | 0.938 | 0.813 |

## Kernels without a correct ref18 baseline (compared with GCC only)

| kernel | opt | ref18 | port19 cycles | port20 cycles | port20fix cycles | port20fix2 cycles | gcc cycles | port19/gcc | port20/gcc | port20fix/gcc | port20fix2/gcc |
|---|---|---|---|---|---|---|---|---|---|---|---|
| k01_fir_fix16 | O2 | compile-fail | compile-fail | compile-fail | compile-fail | 16015 | 17074 |  |  |  | 0.938 |
| k01_fir_fix16 | O3 | compile-fail | compile-fail | compile-fail | compile-fail | 16014 | 17192 |  |  |  | 0.931 |
| k02_fir_f32 | O2 | compile-fail | compile-fail | compile-fail | compile-fail | 39665 | 42411 |  |  |  | 0.935 |
| k02_fir_f32 | O3 | compile-fail | compile-fail | compile-fail | compile-fail | 39665 | 37677 |  |  |  | 1.053 |
| k04_matmul_simple_f32 | O2 | compile-fail | compile-fail | compile-fail | compile-fail | 175559 | 143874 |  |  |  | 1.220 |
| k04_matmul_simple_f32 | O3 | compile-fail | compile-fail | compile-fail | compile-fail | 174504 | 143840 |  |  |  | 1.213 |
| k05_matmul_dsp_fix16 | O2 | WRONG RESULT | WRONG RESULT | WRONG RESULT | 43923 | 43643 | 42748 |  |  | 1.027 | 1.021 |
| k05_matmul_dsp_fix16 | O3 | compile-fail | compile-fail | compile-fail | compile-fail | 43513 | 42748 |  |  |  | 1.018 |
| k07_matadd_dsp_fix16 | O2 | compile-fail | compile-fail | compile-fail | compile-fail | 7201 | 7199 |  |  |  | 1.000 |
| k07_matadd_dsp_fix16 | O3 | compile-fail | compile-fail | compile-fail | compile-fail | 7201 | 7199 |  |  |  | 1.000 |
| k08_preprocessing_fix | O2 | compile-fail | compile-fail | compile-fail | compile-fail | 11456 | 11435 |  |  |  | 1.002 |
| k08_preprocessing_fix | O3 | compile-fail | compile-fail | compile-fail | compile-fail | 11453 | 11438 |  |  |  | 1.001 |
| k09_cmplx_fix | O2 | compile-fail | compile-fail | 2073 | 2073 | 2073 | 2067 |  | 1.003 | 1.003 | 1.003 |
| k09_cmplx_fix | O3 | compile-fail | compile-fail | 2073 | 2073 | 2073 | 2067 |  | 1.003 | 1.003 | 1.003 |
| k10a_fft_radix2_scalar | O2 | compile-fail | compile-fail | compile-fail | compile-fail | 22800 | 23069 |  |  |  | 0.988 |
| k10a_fft_radix2_scalar | O3 | compile-fail | compile-fail | compile-fail | compile-fail | 22807 | 21799 |  |  |  | 1.046 |
| clip | O2 | WRONG RESULT | WRONG RESULT | WRONG RESULT | 21535 | 21535 | 17437 |  |  | 1.235 | 1.235 |
| clip | O3 | WRONG RESULT | WRONG RESULT | WRONG RESULT | 21535 | 21535 | 17437 |  |  | 1.235 | 1.235 |
| k12_bit_extract | O2 | WRONG RESULT | WRONG RESULT | WRONG RESULT | 12315 | 12315 | 10265 |  |  | 1.200 | 1.200 |
| k12_bit_extract | O3 | WRONG RESULT | WRONG RESULT | WRONG RESULT | 12315 | 12315 | 10265 |  |  | 1.200 | 1.200 |
| k12_sum_loop | O2 | compile-fail | compile-fail | 12310 | 12310 | 12310 | 12308 |  | 1.000 | 1.000 | 1.000 |
| k12_sum_loop | O3 | compile-fail | compile-fail | 12310 | 12310 | 12310 | 12308 |  | 1.000 | 1.000 | 1.000 |
| k12_copy_loop | O2 | compile-fail | compile-fail | 28688 | 28688 | 28688 | 16402 |  | 1.749 | 1.749 | 1.749 |
| k12_copy_loop | O3 | compile-fail | compile-fail | 28688 | 28688 | 28688 | 16402 |  | 1.749 | 1.749 | 1.749 |
| k12_dot8_loop | O2 | compile-fail | compile-fail | 4120 | 4120 | 4120 | 4117 |  | 1.001 | 1.001 | 1.001 |
| k12_dot8_loop | O3 | compile-fail | compile-fail | 4120 | 4120 | 4120 | 4117 |  | 1.001 | 1.001 | 1.001 |
| k12_dot16_loop | O2 | compile-fail | compile-fail | 4120 | 4120 | 4120 | 4117 |  | 1.001 | 1.001 | 1.001 |
| k12_dot16_loop | O3 | compile-fail | compile-fail | 4120 | 4120 | 4120 | 4117 |  | 1.001 | 1.001 | 1.001 |
| k12_packed_add8_loop | O2 | compile-fail | compile-fail | 8209 | 8209 | 8209 | 5139 |  | 1.597 | 1.597 | 1.597 |
| k12_packed_add8_loop | O3 | compile-fail | compile-fail | 8209 | 8209 | 8209 | 5139 |  | 1.597 | 1.597 | 1.597 |

## Analysis

Written by hand after reading the numbers above and diffing the kernel disassembly (`build/<cc>/<opt>/<kernel>/kernel.dis`).
Per-PC profiles come from `pc_profile.py`, which uses a GVSoC instruction trace.

### What improved (port20 vs ref18)

- **Coverage.** port20 builds, runs and matches the reference on six kernels where ref18 and port19 crash in the
  "PULP Hardware Loops" pass: `k09_cmplx_fix`, `k12_sum_loop`, `k12_dot8_loop`, `k12_dot16_loop`, `k12_copy_loop`
  and `k12_packed_add8_loop`. Four of them are within 0.3% of GAP9 GCC. The other two, `copy_loop` and `packed_add8_loop`,
  take 1.75x and 1.60x GCC's cycles. port20 does not turn these two loops into hardware loops. After loop-strength reduction
  the only induction variable left is a pointer compared against an end pointer (`p.lw; addi; p.sw; bne a0,a2`), and
  the PULP hardware-loop pass leaves that form alone. The result is 7 cycles per element (taken-branch penalty plus load-use stall), against
  GCC's 4 (`lp.setup` with a 3-instruction body). There is no ref18 baseline for these, so they are a missed
  optimisation, not a regression.
- **Micro kernels (k12 per-element, clip): 5–8% fewer cycles. None of it comes from the kernel.** The kernel
  disassembly of all eleven of these TUs is identical for ref18, port19 and port20. The whole gain is in the
  driver's call loop, which is built by the same compiler. port20 (LLVM 20 loop-strength reduction) drops the separate
  down-counter and compares the post-incremented pointer against an end pointer. That saves 1 instruction and 1 cycle per call,
  so the 1024-call loops are 1023 cycles faster. The codegen change is real, but it is in the calling code, not in PULP kernel code. This is why the
  summary gives a second geomean without these kernels. On `k03`, `k06` and `k11` port20 matches ref18 within 0.1%.
- `k03_matmul_worker_i16`: port20 removes the padding `nop` that ref18 puts in front of the inner `lp.setup`. That is
  one fewer instruction per inner-loop entry, or 1024 per call (instret 124186 -> 123162, -0.8%). Cycles are identical
  (159101) because the rescheduled block ahead of the `lp.setup` picks up one stall cycle per entry (per-PC profile).
- `k11_dotprod_i8`: one fewer set-up instruction per call (1047 -> 1046 cycles).
- `k06_matvect_dsp_f32`: port20 changes a few registers and instructions but gives the same cycles as ref18. All three LLVM
  builds are bit-exact with GCC (the host build differs by up to 2.7e-5 relative, from x86 not fusing multiply-adds). All LLVM builds are 33% slower than GCC:
  the inner loop uses plain `lw` + `addi` pointer bumps (8 instructions per 2 MACs), where GCC uses
  post-increment `p.lw` (6). This is inherited from ref18.

### Regressions > 3%

- **port20 vs ref18: none** among builds that ran and produced the reference result, at O2 or O3.
- **port19 vs ref18: none** among correct builds. One large one is on a WRONG-RESULT kernel, so it gets no
  speed claim, but it was investigated because it is a hardware-loop miscompile.
  - **`k05_matmul_dsp_fix16` -O2, port19: 75017 cycles vs 44060 for ref18 (+70%).** The per-PC profile shows the
    8-accumulator dot-product block (the `Line` loop body) running 1240 times per run against 640 for ref18. That is
    31 iterations per output column instead of 16. The disassembly (`build/port19/O2/k05_matmul_dsp_fix16/prog.elf`,
    around 0x72c–0x8a4) shows why. port19 places `lp.setup x1` so that the hardware-loop body (0x730–0x8a2) holds the
    dot products but **not** the out-of-line block with the 8 `p.clip`/`sh` stores and the `Line` increment/exit test
    (0x78c–0x814, reached through `j 0x78c` at 0x8a4). The first 16 hardware-loop iterations therefore recompute row 0
    and store nothing. The loop then falls out, and the remaining 15 rows run as a software loop through those branches.
    The outputs are still identical to ref18 (and just as wrong, because of p.clip). The cost is about 2x work in the hottest
    loop. Code with a different store/exit layout could get wrong outputs from the same bug. port20 does not show it (43923
    cycles, 640 executions).
  - The static sweep flagged `KerParMatMulDSP_Fix16` p.mac 17 -> 15 for port19/port20. The two p.mac that ref18 has and
    the ports lack are index arithmetic (`p.mac a1,a5,a0` at obj 0x11e/0x148) ahead of the column copy loop. They run
    once per call (5 times per run), so they have no measurable effect. port20 as a whole is -0.3% cycles and -0.6%
    instructions against ref18 on this kernel, on a wrong-result build, so this is for information only.

### Correctness

- The reference is the GAP9 GCC -O2 checksum. GCC -O2, GCC -O3 and the host build agree on every integer kernel.
- **`clip` and `k05_matmul_dsp_fix16`: WRONG RESULT on ref18, port19 and port20**, as expected from the p.clip
  immediate bug (LLVM encodes log2(hi+1) where GCC and the hardware take log2(hi+1)+1). The error shows up in real SDK code, not only the probe:
  `gap_clip(x,15)` in `KerParMatMulDSP_Fix16` clamps to [-16384,16383] instead of int16. With the driver's data
  (normalisation 11), 283 of the 1024 outputs fall outside that range and come out wrong (35 of them genuinely saturate int16). k05 at -O3 does not compile on ref18/port19/port20 (RVV-VLEN assert) or port20fix (Hardware Loop Fixup assert); port20fix2 builds it and it is correct.
- **New: `k12_bit_extract` WRONG RESULT on ref18, port19 and port20: p.extractu size-field off-by-one.**
  `__builtin_pulp_bextractu(a, 8, 8)` should give `(a >> 8) & 0xff`: that is the SDK's own
  `Emulation/GapBuiltins.h` definition of `gap_bitextractu`, and GCC and the host build agree with it. All three LLVM compilers encode
  `p.extractu a0,a0,8,8` (word `d0851533`), where GCC encodes `p.extractu a0,a0,7,8` (`ce851533`). The instruction's field
  is size-1, so LLVM extracts a 9-bit field. The bug is inherited from ref18 and the static sweep could not see it. The other
  `p.extract`/`p.insert`/`p.bclr`/`p.bset` builtins, which share that immediate form, were not tested.
- `k06` (fp32): every LLVM and GCC build is bit-exact with GCC -O2. Tolerance checking is in place (1e-4 relative) but was not needed.

### What could not be measured

- **ref18/port19/port20 speed numbers for k05, clip and bit_extract.** Those builds give wrong results. port20fix and
  port20fix2 have the p.clip / p.extractu fixes, are correct, and are compared with GCC in the no-baseline table
  (k05 1.02x, clip 1.235x, bit_extract 1.20x GCC cycles).
- ref18/port19 on the six kernels above (HWLoops crash), and k05 at -O3 on every LLVM build except port20fix2.
- SDK kernels that no LLVM compiler builds: now only k10b (`Radix2FFT_DIF_Seq_Fix16`) and the whole-file `-file`
  variants. k01/k02/k04/k07/k08/k10a are built by port20fix2 and are measured (section below).
- The port20 `lp.setupi` object-emission crash did not trigger on any kernel TU here: all their hardware loops have
  runtime trip counts, and the kernel objects are the static sweep's objects. The drivers avoid constant trip counts on
  purpose. So no build needed `-pulp-loop-range-immediate=0`, and the script's `+wa` rows (added automatically when a
  kernel hits that crash) are empty. The port20 hardware-loop SIGSEGV (`sim/repro/hwloop_var_tripcount_crash.c`) was not hit either.
- Anything GVSoC does not model: GAP9 silicon cycle accuracy, L1/L2 memory latency and TCDM bank conflicts, the
  8-core cluster (all kernels run single-core, `gap_ncore()==1`), and DMA/tiling.

### New SDK kernels built by port20fix2 (k01, k02, k04, k07, k08, k10a)

port20fix2 (the step-20 port with all the fork-defect fixes) is the first LLVM build that compiles these six SDK units.
Every other LLVM build crashes in "PULP Hardware Loops" on them, or, for k08 on ref18/port19/port20, rejects the
`gap_mulsRN` rounding immediate. They now have drivers (`drivers/<kernel>.c`). Each driver calls the kernel TU exactly
as the static sweep compiles it, with the SDK's own argument conventions (workloads are in the Setup table). Details:

- k01 and k02 time `KerFirSeq` / `KerFirSeqf32` and run the `...Baseline` variant from the same TU once, untimed, as a
  cross-check. Both outputs go into the checksum.
- k02: the SDK's fp32 FIR declares its accumulators `int`, so every tap truncates to an integer, and data in [-1,1)
  gives all-zero outputs. The driver uses integer-valued samples and taps. That makes the arithmetic exact, so
  results are bit-identical whether or not a build fuses the multiply-add.
- k10a uses the SDK's `R2_Twiddles_fix_256` table, copied verbatim. It is in place, so every call gets a fresh copy of
  the input.

**Correctness.** All six are correct on port20fix2 at O2 and O3. The GCC and host checksums agree on the five
integer or exact kernels. On `k04` the host differs from GCC by at most 1.3e-5 relative, because x86 does not fuse
multiply-adds; port20fix2 is bit-exact with GCC. No wrong results and no hangs. Across all 27 kernels port20fix2
is 54/54 ok. It also fixes the three off-by-one wrong results seen on ref18/port19/port20 (`clip`, `k05`,
`k12_bit_extract`; port20fix already fixed those), and it compiles `k05` and `k01` at -O3 (the RVV-VLEN assert is
gone). `k05` -O3 is correct.

**Speed vs GCC** (port20fix2/gcc cycles, O2 / O3):

- `k01` 0.938 / 0.931. Faster than GCC: LLVM issues all eight loads of an unrolled step ahead of the four
  `pv.sdotsp.h`. GCC puts each load right before the sdotp that uses it (14225 instrs but 17074 cycles, against
  14766 / 16015 for LLVM).
- `k02` 0.935 / 1.053. GCC -O3 improves to 37677 cycles, LLVM stays at 39665.
- `k04` 1.220 / 1.213. This is the k06 pattern again. The fp32 inner loop is `lw; lw; addi; fmadd.s; addi`
  (5 instructions per MAC), where GCC uses post-increment `p.lw ...!` (3). GCC stalls more, so the gap in cycles is
  1.22x, not 1.6x.
- `k07` 1.000, `k08` 1.002 / 1.001.
- `k10a` 0.988 / 1.046. GCC -O3 improves, LLVM does not.
- Geomean over the six: 1.010 (O2), 1.037 (O3).

## Reproduce

`python3 run_runtime.py` (from any directory; about 10 s on 32 cores). It deletes and rebuilds `build/`, rewrites `runtime_results.json` and this report. Add a compiler without code changes: `python3 run_runtime.py --add port20fix=/path/to/bin/clang` (it becomes an extra column and ratio). `--compilers`, `--kernels` restrict the run; `--report-only` regenerates this file from the JSON. Per build: objects, `kernel.dis`, `build.log` (exact commands), `sim.log` in `build/<compiler>/<opt>/<kernel>/`. `pc_profile.py <elf> [function]` gives a per-PC execution profile from a GVSoC instruction trace (used for the regression analysis above). The analysis text comes from `notes.md`.
