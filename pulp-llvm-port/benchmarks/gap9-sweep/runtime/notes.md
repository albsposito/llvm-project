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

