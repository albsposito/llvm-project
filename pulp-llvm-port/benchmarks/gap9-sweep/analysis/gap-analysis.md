# GAP9 sweep: gap analysis for B25 (MatMul int16) and B26 (FIR f32 / FFT at -O3)

Date: 2026-09-28. Simulator: GVSoC2 `ri5ky_testbench`, slow timing mode (same caveats as
`../runtime/runtime_report.md`: instruction-accurate with a timing model, not silicon-exact).

## Summary

| kernel | opt | GCC | port-20fix2 | int-20 (F006+F008..F011) | gap int-20 vs GCC | top cause (share of the gap) |
|---|---|---|---|---|---|---|
| k03_matmul_worker_i16 | O2 | 146,009 / 113,178 | 159,101 / 123,162 | 159,101 / 123,162 | +13,092 (+9.0%) | `int32_t` is `long` in GAP9 GCC and `int` in clang. The `int32_t` store may therefore alias `w->n`/`w->k`: the middle loop is not a hardware loop, and the C address is recomputed every iteration (**92%**) |
| k03_matmul_worker_i16 | O3 | 145,917 / 113,085 | 159,103 / 123,163 | 159,103 / 123,163 | +13,186 | same |
| k02_fir_f32 | O2 | 42,411 / 42,122 | 39,665 / 39,499 | **39,505** / 39,339 | -2,906 (LLVM faster) | n/a |
| k02_fir_f32 | O3 | 37,677 / 37,388 | 39,665 / 39,499 | **39,505** / 39,339 | +1,828 (+4.9%) | GCC `-fpredictive-commoning` saves one load per inner iteration (**63%**). LSR skips outer loops, so the `Out[]` addresses are rebuilt from the index (**49%**). LLVM wins back 256 cycles in the loop head |
| k10a_fft_radix2_scalar | O2 | 23,069 / 23,055 | 22,800 / 22,788 | 22,800 / 22,788 | -269 (LLVM faster) | n/a |
| k10a_fft_radix2_scalar | O3 | 21,799 / 21,657 | 22,807 / 22,795 | 22,807 / 22,795 | +1,008 (+4.6%) | GCC -O3 SLP-vectorises the last FFT layer into `pv.add.h`/`pv.sub.h`. LLVM's SLP vectoriser is shut off on this target (**76%**). A 4-byte-alignment `nop` sits in front of each `lp.setup` (**26%**) |

Cells show cycles / retired instructions per call (warm-up + 4 timed calls, `bench_cycles()`).
All builds give the reference checksum. The GCC and port-20fix2 numbers match
`runtime_results.json` exactly.

**Effect of the newer fixes (int-20 vs port-20fix2):** k03 and k10a: none (identical code). k02:
-160 cycles/call. 31 of those come from F006: float `p.lw` post-increment in the delay-line copy
loop. The other ~128 are luck: the extra instruction that F006 removed moved the inner `lp.setup`
onto a 4-byte boundary, so the alignment `nop` in front of it disappeared (see cause D). F008
(clamps) does not touch these kernels.

**Why GCC gains at -O3 and LLVM does not (B26):** LLVM already does at -O2 what GCC only does at
-O3 or not at all:
- On the FIR, GVN merges the overlapping `In1[k+1]`/`In2[k]` loads. LLVM's -O2 inner loop therefore
  has 35 instructions against GCC -O2's 39, and LLVM -O2 is 6.9% faster than GCC -O2.
- On the FFT, the GCC -O2 last layer is 15 instructions against LLVM's 13.

The transformations that GCC 7 adds at -O3 are these:
- predictive commoning
- SLP vectorisation into the PULP `v2hi` mode
- unswitching the `iL > 0` test out of the FFT middle loop

LLVM either has no equivalent (predictive commoning) or has it disabled on this target (SLP, because
the vector register width is 0 without RVV). LLVM's -O3 pipeline is essentially its -O2 pipeline
here: -O2 and -O3 code is identical for both kernels.

## Method

- `build.sh <label> <cc> <opt> <kernel> [flags]` rebuilds one kernel ELF with exactly the harness's
  commands (kernel TU flags from `../run.py`, driver, `rt_libc.c`, `crt0.S`, `link.ld`). It then runs it on
  GVSoC. `SRC=<file>` substitutes a variant kernel TU. Outputs go to `builds/<label>/<opt>/<kernel>/`
  (`kernel.dis`, `prog.elf`, `sim.log`). Nothing in `../runtime` was modified.
- Per-PC profiles come from `../runtime/pc_profile.py` (GVSoC `--trace=insn`) and are saved as
  `prof_*.txt`. `blocks.py` groups consecutive PCs with the same execution count into basic blocks
  and prints instructions and cycles per call. Profile counts cover all five calls and are divided
  by 5. The profiler charges a stall to the instruction *before* the stalled one.
- Disassembly: `llvm-objdump -d --mattr=+m,+xpulpv,+zfinx` (int-20 build).
- Compilers: GCC = `/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc` 7.1.1;
  fix2 = `toolchains/port-20fix2/bin/clang`; int20 = `build/int-20/bin/clang` (source `wt/int-20`).

---

## B25: k03_matmul_worker_i16 (+9.0%, +13,092 cycles, +9,984 instructions per call)

### Where the cycles go (per-PC profile, per call)

The function is a 32x32x32 triple loop: `r` (outer, 32), `c` (middle, 1,024 in total) and
`t` (inner, 32,768 in total).

| region | GCC instrs / cycles per exec | LLVM instrs / cycles per exec | execs/call | delta cycles/call |
|---|---|---|---|---|
| inner `t` loop (`p.lh; p.lh; p.mac`) | 3 / 4 | 3 / 4 | 32,768 | ~0 |
| middle `c` loop body outside the inner loop | 14 / 14 | 24 / 27 | 1,024 | **+13,345** |
| outer `r` loop + entry/exit | small | small | 32 | ~-250 |

The whole gap is in the middle loop. The inner loop is identical: both compilers produce a
3-instruction hardware loop with post-increment loads, including GCC's reg-reg post-increment
`p.lh a6, s2(a3!)` (LLVM: `p.lh s0, a2(a1!)`).

### Disassembly of the middle loop

GCC (`builds/gcc/O2/k03_matmul_worker_i16/kernel.dis`). The middle loop is hardware loop x0 and the
inner loop is x1. The store is a post-increment `p.sw`:
```
  46: lp.setup x0, a7, 0x19          # middle loop (c) = hardware loop
  4a: li   a2, 0x0
  4c: blez t5, .L7                   # k <= 0 ?   (t5 = w->k, loaded once per r)
  50: lw   a4, 0x0(a0)               # w->a
  52: lw   a3, 0x4(a0)               # w->b
  54: sub a5,s3,t4 / addi / srli / add a3 / add a4 / li a2 / addi a5
  64: lp.setup x1, a5, 0x6           # inner loop
  68: p.lh a1, 0x2(a4!) ; p.lh a6, s2(a3!) ; p.mac a2, a6, a1
  74: p.sw a2, 0x4(t3!)              # C[r*n+c] via post-incremented pointer
  78: addi t1, t1, 0x2
```
LLVM int-20 (`builds/int20/O2/k03_matmul_worker_i16/kernel.dis`). The *outer* loop is hardware loop
x1 and the inner loop is x0. The middle loop is a software loop (`bge` + taken `j`), and the store
address is rebuilt with `mul`:
```
  24: lp.setup x1, a6, 0x36          # OUTER loop (r) = hardware loop
  3c: mul  a1, t3, t2                # r * n          (n reloaded every iteration)
  40: slli a1,a1,2 / add a1,a1,t1 / slli a2,t5,2 / add a1,a1,a2
  4a: sw   a5, 0x0(a1)               # C[r*n+c]
  4c: lw   t3, 0x14(a0)              # reload w->n after the store
  50: addi t5,t5,1 / addi t4,t4,2
  54: bge  t5, t3, exit              # middle loop is a software loop
  58: lw   a2, 0x10(a0)              # reload w->k
  5a: blez a2, ...
  5e: li a5,0 / lw s1,0(a0) / lw a1,4(a0) / add / mv / p.mac / p.mac / sub / srli / slli
  7c: lp.setup x0, t6, 0x6           # inner loop
  80: p.lh a4, 0x2(a3!) ; p.lh s0, a2(a1!) ; p.mac a5, s0, a4
  8c: j    0x3c                      # taken jump back (2 cycles)
```
LLVM's middle loop costs 24 instructions and 27 cycles against 14 and 14. The extra 10
instructions break down as follows:
- store address rebuilt: `mul, slli, add, slli, add`, then `sw` instead of `p.sw` (+5)
- `w->n` and `w->k` reloaded (+2)
- software loop control: `addi` counter, `bge`, `j` (+3, plus a 2-cycle taken `j`)

### Cause A: `int32_t` type mismatch defeats type-based alias analysis (92% of the gap)

- GAP9 GCC (newlib `newlib-stdint.h`): `#define __INT32_TYPE__ long int`.
- Our clang, `--target=riscv32-unknown-elf`: `#define __INT32_TYPE__ int`.

`w->c` is `int32_t *`, and `w->rows`/`w->k`/`w->n` are `int`. For GCC, a `long` store cannot alias
an `int` field under strict aliasing. `w->n` and `w->k` are therefore loop-invariant, and GCC
- keeps `n` in a register,
- makes the middle loop a hardware loop (its trip count is invariant),
- strength-reduces `&C[r*n+c]` into a post-incremented pointer.

For clang, `int32_t` is `int`, so the store may overwrite `w->n`. `n` must be reloaded after every
store, so:
1. The trip count of the middle loop is not invariant, and the PULP hardware-loop pass cannot
   convert it. The pass takes the outer loop instead, and the middle loop becomes a software loop.
2. `r*n` is not invariant, so the address is rebuilt with `mul`/`slli`/`add` and no pointer
   induction variable or post-increment forms.

Experiments, all on the same driver:

| build | cycles | instrs | vs GCC |
|---|---|---|---|
| GCC -O2 (reference) | 146,009 | 113,178 | - |
| GCC -O2 `-fno-strict-aliasing` | **161,933** | 126,093 | +10.9% (GCC gets *slower than LLVM*) |
| int-20 -O2 | 159,101 | 123,162 | +9.0% |
| int-20 -O2 `-U__INT32_TYPE__ -D__INT32_TYPE__="long int"` (same for UINT32) | **147,043** | 114,236 | **+0.7%** |

With `int32_t` as `long`, clang produces GCC's loop structure: the middle loop is hardware loop x1,
`n` stays in a register, and the store address comes from an incremented index (listing in
`builds/int20_long/O2/k03_matmul_worker_i16/kernel.dis`). **Share: 12,058 of the 13,092 cycles
(92%).**

Where it lives: clang's predefined integer typedefs.
- `clang/lib/Basic/Targets/RISCV.h` (`RISCV32TargetInfo`), and
  `TargetInfo::getIntTypeByWidth` as used by `clang/lib/Frontend/InitPreprocessor.cpp`
  (`DefineExactWidthIntType`).

GCC's riscv32 bare-metal (newlib) ABI uses `long` for `int32_t`/`uint32_t` (and `int_least32_t`,
`int_fast32_t`). Linux/glibc GCC uses `int`, which is what clang does for every RISC-V target. This
is an **ABI-visible decision**: C++ name mangling of `int32_t` changes (`l` vs `i`), and so does
`_Generic`/overload behaviour. It needs the owner. It is not a backend bug. Nothing like it is in
the backlog: this is new.

### Cause B: LSR does not handle non-innermost loops (remaining ~1,000 cycles, 8%)

With cause A removed, LLVM's middle loop has 15 instructions against GCC's 14. The C store is
still `slli a1,s2,2; addi s2,s2,1; add a1,a1,t4; sw a3,0(a1)`, not `p.sw a2,4(t3!)`. The middle
loop is not innermost, and `LoopStrengthReduce.cpp:6207-6211` returns early for such loops:
```
  // Skip nested loops until we can model them better with formulae.
  if (!L->isInnermost()) {
    LLVM_DEBUG(dbgs() << "LSR skipping outer loop " << *L << "\n");
```
Addresses used in an outer loop of a nest therefore never get a pointer induction variable or
post-increment. GCC's IVOPTS handles every loop level. The same cause shows up in k02 (cause B'
below, with more weight). New backlog item. It is related to B20 but separate: B20 is about
streams inside one innermost loop.

A third, minor item: one alignment `nop` per call before the outer `lp.setup` (cause D). Only 1
cycle per call here. ref18 had one per inner-loop entry, 1,024 per call.

---

## B26a: k02_fir_f32 at -O3 (+1,828 cycles/call with int-20; +1,988 with port-20fix2)

Hot function `KerFirSeqf32`, per call: GCC -O3 37,665 cycles, int-20 -O3 39,490 cycles, gap
1,825. The rest of the timed region is equal.

| region (per call) | GCC -O2 | GCC -O3 | int-20 -O3 | int-20 - GCC-O3 |
|---|---|---|---|---|
| inner 4-tap loop, 1,024 iterations: instrs/iteration | 39 | **34** | 35 | +1,152 cycles |
| outer loop head, 128 iterations (cycles per iteration) | 11 | 13 | 11 | -256 |
| outer loop tail (`Out[2i]`, `Out[2i+1]`), 128 iterations (cycles per iteration) | 8 | 9 | **16** | +896 |
| delay-line shift, 31 iterations (cycles per iteration) | 3 | 3 | 4 | +31 |
| entry/exit | 66 | 68 | 70 | +2 |
| **function total** | 42,399 | 37,665 | 39,490 | **+1,825** |

The inner loop is stall-free in both (LLVM: 35 instructions, 35.0 cycles).

### Cause A': no predictive commoning (loop-carried load reuse), 1,152 cycles (63%)

`In2 = In1 + 1`, so `In2[4j+k] == In1[4j+k+1]`, and `In1[4j+4]` is the next iteration's
`In1[4j+0]`. Load counts per inner iteration:
- GCC -O2: 12 loads (4 In1 + 4 In2 + 4 Coeffs, no reuse), 39 instructions.
- LLVM -O2/-O3: 9 loads. GVN merges the overlapping In1/In2 loads within one iteration:
  5 DelayLine + 4 Coeffs.
- GCC -O3: 8 loads. `-fpredictive-commoning` (enabled at -O3 in GCC 7) also carries `In1[4j+4]`
  into the next iteration:
```
GCC -O3:   140: p.lw t5, 0x4(t3!)        # preheader: first In2[0] (= In1[1])
           ...inner body (0x158-0x1d4): 7 lw + ...
           194: p.lw t5, 0x10(t6!)       # loads In1[4j+4] for the NEXT iteration
           1d0: fmadd.s a5, a5, t5, a2   # ...and uses the carried value
int-20:    150: lw s7,-0x8(s1); lw s10,-0x4(s1); lw s8,0(s1); lw s9,4(s1)   # In1[0..3]
           17c: lw s5, 0x8(s1)           # In1[4] loaded again every iteration
           160: lw a5,-8(s0); lw s11,-4(s0); lw ra,0(s0); lw a6,4(s0)       # Coeffs
```
LLVM has no predictive-commoning pass. `LoopLoadElimination` only forwards a store to a later load
across iterations, not a load to a later load. **Share: 1 instruction x 1,024 = 1,152 cycles/call
in the profile (63% of the gap).**

Variant check (`variants/k02_pcout.c`: `In1[4j+4]` carried by hand in a local, plus an `Out`
pointer). LLVM's inner loop still has 35 instructions. The load is gone, but the register
allocator adds a `mv s5, ra` copy of the carried value at the end of the loop body: the scheduler
hoists the next load above the last use of the old value. A pass that performs this reuse must
therefore also avoid the copy, for example by unrolling by 2 or by placing the load after the last
use as GCC does. The achievable gain is ~1,024-1,152 cycles/call (2.7%).

### Cause B': outer-loop addresses not strength-reduced (LSR skips outer loops), 896 cycles (49%)

The outer `i` loop is not innermost, so LSR skips it (same source line as in k03). The two output
stores are then addressed from `i` every iteration:
```
GCC -O3 (tail, 7 instrs / 9 cycles):
   aba: fcvt.s.w a6,t0 ; fcvt.s.w a2,a5
   ac2: bge  s11, a3, 0xb08             # skip remainder loop (taken, 4 cycles)
   b08: p.sw a6, 0x8(s7!)               # Out[2i]   post-increment
   b0c: p.sw a2, 0x8(s6!)               # Out[2i+1] post-increment
   b10: addi s3,s3,8 ; addi s4,s4,8
int-20 -O3 (tail, 15 instrs / 16 cycles):
   86c: blt  t2, a3, ... ; j 0x8aa      # skip remainder loop (2 branches)
   8aa: slli a1,s3,1 ; fcvt.s.w a5,s6 ; fcvt.s.w s1,s5 ; addi s3,s3,1 ; addi a7,a7,8
   8ba: addi s0,a1,1 ; slli a1,a1,2 ; add a1,a1,a2 ; slli s0,s0,2 ; add s0,s0,a2
   8c6: sw a5,0(a1) ; sw s1,0(s0) ; addi t6,t6,8
```
LLVM spends 7 instructions on `Out` addressing plus an `i` counter, where GCC spends 0 (two
post-increment stores). The IR after `loop-reduce` still has
`getelementptr float, ptr %Out, i32 %mul` / `%add`
(`scratch/k02_lsr.ll`, `-mllvm -print-after=loop-reduce`).

Variant check: with `*O++ = Acc1; *O++ = Acc2;` the tail drops to 13 cycles (-384 cycles/call). It
is still `sw; sw; addi`, not two `p.sw`, because f32 post-increment stores are deliberately not
enabled (F006/B21 enabled only float loads). Full parity (9 cycles) needs both an outer-loop
pointer induction variable and float post-increment stores. **Share: 896 cycles/call (49%).**

### Smaller items

- The loop head is cheaper in LLVM by 2 cycles per iteration (-256/call): GCC -O3 pays for its
  `p.lw` prologue and trip-count computation there.
- Delay-line copy: `p.lw a2,4(a7!); sw a2,0(a0); addi a0,a0,4` against GCC's `p.lw; p.sw` (+31
  cycles/call). This is also the missing float post-increment store.
- Alignment nop (cause D): not executed in the int-20 build, but executed 128 times per call in
  port-20fix2 (a `nop` before the inner `lp.setup`). That is most of the int-20 vs fix2 difference.

---

## B26b: k10a_fft_radix2_scalar at -O3 (+1,008 cycles/call)

Hot function `Radix2FFT_DIF_Scalar`, per call: GCC -O3 21,788, int-20 -O3 22,794, gap 1,006.

| region (per call) | GCC -O2 | GCC -O3 | int-20 -O3 | int-20 - GCC-O3 |
|---|---|---|---|---|
| butterfly loop (`iCnt3`), 896 iterations, 20 instructions | 17,666 | 17,666 | 17,666 | 0 |
| `iCnt2` loop head (254 iterations) + tail | 2,286 + 1,009 | 2,032 + 1,009 | 2,540 + 762 | +261 |
| outer `iCnt1` loop (7 iterations) + entry | 177 | 185 | 162 | -23 |
| **last layer** (128 iterations): instrs / cycles per iteration | 15 / 15 | **6 / 7** | 13 / 13 | **+768** |
| **total** | 23,058 | 21,788 | 22,794 | **+1,006** |

### Cause C: no SLP vectorisation into Xpulpv2 packed SIMD, 768 cycles (76%)

GCC 7 -O3 enables `-ftree-slp-vectorize`, which vectorises the last layer's pairs of `short`
(re, im) operations into the PULP `v2hi` mode:
```
GCC -O3 (6 instrs / 7 cycles per iteration):
   934: lw a5, 0x0(a0) ; lw a4, 0x0(a2)
   938: pv.add.h a1, a4, a5
   93c: p.sw a1, 0x8(a0!)
   940: pv.sub.h a5, a5, a4
   944: p.sw a5, 0x8(a2!)
int-20 -O3 (13 instrs / 13 cycles per iteration):
   6d0: lh a2,-4(a0) ; lh a3,-2(a0) ; lh a4,0(a0) ; lh a5,2(a0)
   6e0: sub s1,a2,a4 ; sub s0,a3,a5 ; add a2,a2,a4 ; add a3,a3,a5
   6ec: sh a2,-4(a0) ; sh a3,-2(a0) ; sh s1,0(a0) ; sh s0,2(a0)
   6fc: addi a0,a0,8
```
LLVM runs the SLP vectoriser at -O2 and -O3 too, but it never fires on this target:
- `RISCVTTIImpl::getRegisterBitWidth(RGK_FixedWidthVector)` returns 0 unless RVV is used for
  fixed-length vectors (`RISCVTargetTransformInfo.cpp:324-326`).
- `getNumberOfRegisters(VRRC)` returns 0 without V (`RISCVTargetTransformInfo.h:381-386`).

Yet the fork's ISel already treats `v2i16`/`v4i8` in GPRs as legal: post-increment loads and
stores are marked legal for them (`RISCVISelLowering.cpp:723-729`), and the `pv.*` patterns
exist.

Variant check (`variants/k10a_simd.c`: last layer written with `short __attribute__((vector_size(4)))`):
LLVM emits `lw; lw; pv.add.h; pv.sub.h; sw; sw; addi` (7 instructions), and the kernel drops to
**22,167 cycles (-640/call)**. GCC is unchanged at 21,799. The remaining one-instruction difference
is the B20 pattern: one pointer with two offsets plus an `addi`, against two post-incremented
pointers. **Share: 768 cycles/call (76%)**, of which 640 are available from vectorisation alone.

### Cause D: alignment `nop` in front of every `lp.setup`, 261 cycles (26%)

```
int-20:  658: mv s0,t5 ; mv s1,t6 ; mv a5,t2
         65e: nop                          # executed 254 times/call
         660: lp.setup x0, t2, 0x27
         642: nop                          # executed 7 times/call (outer lp.setup)
GCC:     8b6: lp.setup x1, t1, 0x26        # at a 2-mod-4 address, no padding
```
`PULPFixupHwLoops::runOnMachineFunction` (`llvm/lib/Target/RISCV/PULP/PULPFixupHwLoops.cpp:173-187`)
splits every `lp.setup` that is not first in its block into a new block with `setAlignment(Align(4))`.
With RVC, the padding is a `c.nop` whenever the code in front ends at a 2-mod-4 address. The `nop`
runs on every loop entry. For an inner loop that means once per outer iteration.

GCC never pads: its `lp.setup` in this kernel and in k03 sits at 2-mod-4 addresses, and GVSoC runs
it correctly. Whether silicon RI5CY/GAP9 needs 4-byte-aligned loop starts or loop bodies still has
to be confirmed; I found no such requirement in GCC's output. Execution counts are exact: 254 + 7
= 261 `nop` per call, 1 cycle each. **Share: 26%.**

It also explains two earlier observations:
- port-20 vs ref18 on k03: ref18's `nop` per inner-loop entry (1,024/call). The port removed it by
  chance and gained a stall instead.
- The 128-cycle k02 difference between port-20fix2 and int-20.

The `iCnt2` loop has 9 instructions in LLVM against 8 in GCC, and the one extra is exactly this
`nop`. LLVM's twiddle address (`slli; add` from `iQ`, again an outer loop that LSR skips) costs
the same instruction count as GCC's two twiddle pointer bumps. It is not a loss here.

---

## Proposed backlog entries

Ids B65-B69 are proposals: B54, B55 and B60-B64 are taken in `BACKLOG.md` on 2026-09-28. Renumber freely.

| id (proposed) | title | priority | expected gain (measured or estimated) | where in the compiler | relation to existing items |
|---|---|---|---|---|---|
| **B25 -> close** | Analysis done (this file). Split into B65 and B66 | - | - | - | - |
| **B26 -> close** | Analysis done. Split into B67, B68, B69, plus the B66 and B20 updates | - | - | - | - |
| **B65 (new)** | **`int32_t`/`uint32_t` are `int` in clang but `long int` in GAP9 GCC (newlib).** Stores through `int32_t*` then alias `int` fields for LLVM but not for GCC. In k03 this forces reloads of the loop bounds, a lost middle-level hardware loop, and a `mul`-based store address. Options: (a) match GCC in the fork (bare-metal riscv32 `getIntTypeByWidth(32)` returns `long`, plus the least/fast types). This changes C++ mangling and `_Generic`, so it is an ABI decision for the owner. (b) Document it as a known difference. The `-D__INT32_TYPE__="long int"` workaround in this file is for measurement only | **high** (owner decision) | k03: **-12,058 cycles/call (-7.6%)**, gap 9.0% -> 0.7%. Likely wider: any SDK kernel that stores `int32_t` while reading `int` arguments or struct fields | `clang/lib/Basic/Targets/RISCV.h` (`RISCV32TargetInfo`), `clang/lib/Basic/TargetInfo.cpp` `getIntTypeByWidth`, `clang/lib/Frontend/InitPreprocessor.cpp` | new. Not B22: the missed middle hardware loop in k03 is a consequence of this, not of the hardware-loop pass |
| **B66 (new)** | **LSR skips every non-innermost loop** (`LoopStrengthReduce.cpp:6207`), so addresses used in an outer loop of a nest never get a pointer induction variable or post-increment. Instead they are rebuilt from the index (`slli/add` per access). Seen in the k02 `Out[2i]`/`Out[2i+1]` stores, the k03 C store, and the k10a twiddle loads. Fix options: a PULP IR pass before ISel that forms pointer induction variables for strided accesses in outer loops (only when every use is a load/store address), or relax the LSR bail-out for loops whose sub-loops do not use the induction variable | medium | k02: up to **-896 cycles/call (-2.3%)** (-384 measured with a pointer alone; the rest needs f32 post-increment stores). k03 after B65: ~-1,000 cycles/call (-0.7%) | `llvm/lib/Transforms/Scalar/LoopStrengthReduce.cpp` (LSRInstance ctor), or a new pass under `llvm/lib/Target/RISCV/PULP/` | new. Related to B20 (B20 = several streams in one innermost loop) |
| **B67 (new)** | **SLP (and loop) vectorisation into Xpulpv2 packed SIMD is disabled.** `RISCVTTIImpl::getRegisterBitWidth(RGK_FixedWidthVector)` = 0 and `getNumberOfRegisters(VRRC)` = 0 without RVV, so the vectorisers never form `v2i16`/`v4i8` even though ISel supports them (`pv.add.h`, `pv.sub.h`, ...). Needs a 32-bit fixed-width "vector register" in the GPR class when `hasPULPExtV2()`, with legal element types i16x2/i8x4, and cost-model entries that make unsupported ops (e.g. `mul` on v2i16) expensive. GCC -O3 does this in SDK code | medium-high | k10a: **-640 cycles/call measured (-2.8%)** with a hand-vectorised variant, -768 with post-increment stores. Any SDK kernel with paired re/im or int8/int16 element-wise code at -O3 | `llvm/lib/Target/RISCV/RISCVTargetTransformInfo.{h,cpp}` (register width, register count, arithmetic and memory-op costs for v2i16/v4i8) | new (B28 covers missing builtins, not auto-vectorisation) |
| **B68 (new)** | **Alignment `nop` before every `lp.setup`**: `PULPFixupHwLoops.cpp:173-187` splits `lp.setup` into a block with `Align(4)`. The `c.nop` padding then runs on every loop entry (inner loops: once per outer iteration). GCC never aligns. First confirm that GAP9/RI5CY has no alignment requirement for the setup or the body (GCC output and GVSoC say none), then drop the `setAlignment` or apply it only when needed. Also makes cycle counts depend on unrelated code-size changes (k02: -128 cycles by accident in int-20) | medium (easy) | k10a: **-261 cycles/call (-1.1%)**. k02 fix2: -128. k03: -5 (ref18-like layouts: -1,024). Every nested hardware loop whose setup lands at 2 mod 4 | `llvm/lib/Target/RISCV/PULP/PULPFixupHwLoops.cpp` | new |
| **B69 (new)** | **No predictive commoning (load reuse across iterations)** for sliding-window loops (FIR): GCC -O3 carries `In1[4j+4]` into the next iteration, LLVM reloads it. A hand-carried variant shows the register-allocation copy problem (`mv` added in the loop body), so the transform must also keep the carried value copy-free (unroll x2 or sink the load below its last use) | low-medium | k02: **-1,024 to -1,152 cycles/call (-2.6 to -2.9%)**. Other SDK FIRs (k01 fix16 likewise) | new IR pass or an extension of `LoopLoadElimination` (`llvm/lib/Transforms/Scalar/LoopLoadElimination.cpp`), enabled for PULP at -O3 | new |
| **B20 (update)** | Add these observations: (1) the vectorised FFT last layer (after B67) uses one pointer with two offsets plus `addi` where GCC uses two `p.sw` post-increment pointers (+128 cycles/call); (2) **f32 post-increment stores** are still off (B21/F006 enabled loads only): k02 delay-line copy +31 cycles/call, and the k02 `Out` stores need them to reach parity after B66 | medium (unchanged) | k10a +128, k02 +31 (+~512 after B66) | `RISCVISelLowering.cpp` `setIndexedStoreAction(POST_INC, f32)` under Zfinx, plus LSR stream splitting (as already in B20) | update |
| B22 (note) | k03's missing middle-level hardware loop is caused by B65 (bound reloaded after an aliasing store), not by the hardware-loop pass. With `int32_t` as `long`, LLVM nests middle + inner exactly like GCC | - | - | - | note only |

Priority order by gain on these three kernels: B65 (12k cycles on k03) > B66 ≈ B69 (k02) >
B67 (k10a) > B68 (k10a, trivial) > B20 update.

## Files

- `build.sh`: rebuild and simulate one kernel with any compiler (`SRC=` for variants).
- `blocks.py`: per-basic-block summary of a `pc_profile.py` output.
- `prof_k03_{gcc,int20}_O2.txt`, `prof_k02_{gcc_O2,gcc_O3,int20_O3,int20_pcout}.txt`,
  `prof_k10a_{gcc_O2,gcc_O3,int20_O3}.txt`: per-PC profiles.
- `builds/<label>/<opt>/<kernel>/`, where label is one of: gcc, fix2, int20, gcc_nosa (GCC
  `-fno-strict-aliasing`), int20_long (`int32_t` = `long`), int20_{pc,pcout,out} / gcc_{pc,pcout,out}
  (k02 variants), int20_simd / gcc_simd (k10a variant).
- `variants/k02_{pc,pcout,out}.c`, `variants/k10a_simd.c`: hand-modified kernel TUs that model one
  transformation each. They are not SDK code, and each checksum equals the reference.
- `scratch/k02_lsr.ll`: IR after `loop-reduce` for `KerFirSeqf32` (int-20 -O3).
