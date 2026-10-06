# B90 design: GAP9 half-precision types `float16`, `float16alt`, `v2h`, `v2ah`

Status: design only. No LLVM file was changed. Written 2026-09-28 from public sources only (GAP SDK
incl. GVSoC2, GAP9 GCC 7.1.1 toolchain, upstream LLVM, the fork at `port/20` = `wt/int-20`
7459255b6120). Test programs and their outputs are in `tests/`; every claim below that says "measured"
comes from a run you can repeat with the commands given.

## 0. Summary

| SDK type | what it is on GAP9 | recommended clang type | LLVM IR / MVT | register | extension (new unless noted) |
|---|---|---|---|---|---|
| `float16` | IEEE binary16 (1/5/10) | `_Float16` | `half` / f16 | GPR (low 16 bits) | **Zhinx** (upstream, unchanged). GAP9 "Xf16" is byte-identical to Zhinx. |
| `float16alt` | bfloat16 (1/8/7) | `__bf16` | `bfloat` / bf16 | GPR (low 16 bits) | new `xpulpf16alt` (scalar ALTF ops in GPRs) |
| `v2h` | 2 x binary16 in one GPR | `_Float16 __attribute__((vector_size(4)))` | v2f16 | GPR | new `xpulpfvec` (+zhinx) |
| `v2ah` | 2 x bfloat16 in one GPR | `__bf16 __attribute__((vector_size(4)))` | v2bf16 | GPR | new `xpulpfvec` (+xpulpf16alt) |

- `float16alt` **is** bfloat16. GVSoC runs every `.ah` op with exponent 8 / mantissa 7
  (`gvsoc2/core/models/cpu/iss/include/isa/rvXf16alt.hpp:61`,
  `.../isa_lib/float_flexfloat.h:83-100`) and GCC encodes `(float16alt)3.14159f` as `0x4049`
  (`tests/gcc_scalar.s`, `.LC1: .half 16457`), which is the bfloat16 bit pattern. What is *not*
  right is upstream's bf16 *extension* (Zfbfmin: conversions only, F registers). So the IR type
  `bfloat` is correct; the instructions, register class and arithmetic legality must be new.
  The backlog line "not bf16" should read "not Zfbfmin".
- Bit-exact parity with GCC is reachable (measured, section 5): `_Float16` + Zhinx already matches
  GCC on every kernel of `tests/numeq.c` once `-ffp-contract=fast` is used. For `__bf16`, rounding
  after each op through f32 already matches GCC when GCC's FMA contraction is turned off, so the
  only remaining gaps are FMA contraction (needs native `fmadd.ah` lowering) and GCC's
  round-to-nearest `(int)` cast (a GCC/ISA quirk, open question Q1).
- Nothing in the fork can be reused for instructions: the fork's `Xfalthalf`/`Xfvec*` are the
  **Snitch** variants (F registers; `.ah` = same encoding as `.h`, chosen by a CSR). GAP9 puts
  operands in GPRs and encodes `.ah` differently (section 3.4).

## 1. How the SDK defines the types (for GCC)

- `float16` and `float16alt` are **GCC built-in type names**, not typedefs in any SDK header.
  GAP9 GCC predeclares them in every translation unit (`typedef short float16;` fails with
  "conflicting types for 'float16' ... previous declaration ... cc1"; `int float16 = 3;` as a local
  variable is accepted, so they behave like predeclared typedefs). They are not the same type
  (`__builtin_types_compatible_p(float16, float16alt)` = 0). GCC's RTL modes are `HF` (float16) and
  `OHF` (float16alt) (seen in the ICE `(reg:OHF 10 a0)` for `-march=rv32imc`). The names exist on
  every `-march`, but only `xgap9` has patterns: `rv32imc`, `rv32imfc`, `rv32imcxgap8` ICE in
  `extract_insn`. GCC rejects `_Float16` ("not supported on this target") and the `f16` literal suffix.
- `v2h`/`v2ah` are typedefs in `tools/autotiler_v3/Emulation/Gap.h:29-30`
  (`typedef float16 v2h __attribute__((vector_size (4)))`, same for `float16alt v2ah`), and
  `f16`/`f16a` in `Gap.h:34-35`.
- Without `__gap9__` (and without `__GAP10__`), or with `__EMUL__`, `Gap.h:14-27` takes the emulation
  path: `float16`/`float16alt` become `float` with `__FLOAT_EMUL__` (`v2h` = 2 x float, 8 bytes) and
  `short int` otherwise (`v2h` = `short` vector). So clang without `__gap9__` compiles the fp16
  kernels silently as **integer** code. `__gap9__` is task 20/F017 (B93).
- The kernel libraries pick the type with a macro:
  - DSP: `BasicKernels/DSP_Libraries/DspFloatType.h:26-33`: `float16` by default, `float16alt` with
    `-DF16_DSP_BFLOAT`.
  - CNN: `BasicKernels/CNN_Libraries_fp16/CNN_FloatType.h:21-28`: **`float16alt` by default**,
    `float16` only with `-DSTD_FLOAT`. So `float16alt` is the default CNN type, not an option.
- Operations the headers reach through builtins (`DSP_Libraries/FloatDefines.h:70-115`):
  `__builtin_pulp_f16{abs,max,min,sqrt}`, `f16{abs,max,min}2`, the `f16alt` versions of all of
  these, `__builtin_pulp_v2hftov2hi(_u)`, `v2ohftov2hi(_u)`, `v2hitov2hf(_u)`, `v2hitov2ohf(_u)`,
  `v2hftov2ohf`, `v2ohftov2hf`, plus the f32 ones (`f32abs/max/min/sqrt`, backlog B94). Call-site
  counts: `benchmarks/sdk-compile-survey/builtins.json` (f16max 256, f16altmax 253, f32max 88,
  f16max2 74, f16altmax2 67, ...). `gap_pack2f16(a)` is a vector literal (`Emulation/GapBuiltins.h:22-23`).
- The kernels also mix the two types: `CNN_Defines_fp16.h:77` passes `(f16)1.0f` (a `float16`)
  where `F16` is `float16alt`. Mixed arithmetic follows GCC's rule in section 2.4.

## 2. What GAP9 GCC accepts and emits

Command: `riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S`. Sources and full output:
`tests/gcc_scalar.{c,s}`, `tests/gcc_vector.{c,s}`, `tests/gcc_promotions.{c,s}`.

### 2.1 Options

`-march=rv32imcxgap9` turns on `-mf16`, `-mf16alt`, `-mfdiv`, `-mfpint` (floats in integer
registers) (`-Q --help=target`). `-mfvec` shows "[disabled]" but vector code is emitted anyway
(`vfadd.h`), so `xgap9` enables it internally. `-mfaux` is off, and GAP9 GCC never emits Xfaux
(`vfdotpex`, `fmacex`) instructions. Predefined: `__gap9__ __pulp__ __riscv__ _pulp __pulp _riscv`,
`__riscv_float_abi_soft`, `__riscv_flen 32`. There are no fp16 feature macros.

### 2.2 Scalar code (operands always in x registers: Zfinx style)

| C | float16 | float16alt |
|---|---|---|
| `a+b`, `a*b`, `a/b` | `fadd.h/fmul.h/fdiv.h a0,a0,a1` (rm=dyn) | `fadd.ah/fmul.ah/fdiv.ah` (rm field = 101) |
| `a*b+c`, `(a+b)*c-a` | `fmadd.h`, `fadd.h`+`fmsub.h` (contracts across statements too: default `-ffp-contract=fast`) | `fmadd.ah`, `fmsub.ah` |
| `a<b` | `flt.h` | `flt.ah` |
| `-a`, abs builtin | `fneg.h`, `fabs.h` | `fneg.ah`, `fabs.ah` |
| to/from float | `fcvt.s.h`, `fcvt.h.s` | `fcvt.s.ah`, `fcvt.ah.s` |
| between the two | `fcvt.ah.h`, `fcvt.h.ah` | |
| `(int)x` | `fcvt.w.h a0,a0,rtz` | **`fcvt.w.ah a0,a0` (no rtz: the rm field is taken, so it rounds to nearest; see Q1)** |
| `(T)i` | `fcvt.h.w` | `fcvt.ah.w` |
| to/from double | `__extendhfdf2` / `__truncdfhf2` (libgcc) | `__extendohfdf2` / `__truncdfohf2` (libgcc) |
| load/store, constants | `lhu`/`sh`, `p.lhu rd,2(rs!)`/`p.sh` post-increment; constants loaded from `.half` pool | same |

Encodings (from `objdump` of GCC objects): `fadd.h 04b57553`, `fadd.ah 04b55553`,
`fcvt.w.ah c4055553`, `fcvt.s.ah 40650553`, `fcvt.ah.s 44055553`, `fcvt.ah.h 44255553`,
`fcvt.h.ah 44657553`.

### 2.3 ABI

- `float16`/`float16alt` go in `a0`-`a7` like `int` and come back in `a0`; the 9th and later
  arguments go on the stack in **4-byte slots** (`many` in `gcc_scalar.s`: `lhu a5,4(sp)`,
  `lhu a5,0(sp)`). `sizeof` = `_Alignof` = 2 for both.
- GCC writes arguments with `lhu` (upper 16 bits zero) and ignores the upper bits it receives;
  GVSoC also ignores them: `flexfloat_pack_bits` masks the inputs
  (`gvsoc2/core/models/cpu/iss/flexfloat/flexfloat.c:83-87`).
- `v2h`/`v2ah` travel as one 32-bit GPR (`call_v`: `tail ext_v` with the vector still in `a0`).
- Variadic: both are **promoted to double** (`call_var`: `__extendhfdf2`; `g` in
  `gcc_promotions.s`: `__extendohfdf2`).
- Clang today (`tests/clang_abi.s`, with `_Float16`/`__bf16`) uses the same registers, stack slots
  and offsets, and vectors are coerced to i32 in `a0`. It sets the upper bits of a `__bf16` argument
  to ones (`lui a2,1048560; or`) and stores stack halves with `sh`. Both are harmless, because both
  compilers ignore the upper bits. Clang passes variadic `_Float16`/`__bf16` **unpromoted**
  (`tests/clang_frontend.ll`, `@f9`), which is an ABI difference (Q4).

### 2.4 Mixed types and promotions

- `float16 + float16alt`: GCC converts the `float16` to `float16alt` and computes in `float16alt`
  (`mix_ha`: `fcvt.ah.h; fadd.ah; fcvt.h.ah`; `sizeof(a+b)`=2 and its type is `float16alt`).
  Clang computes `_Float16 + __bf16` in **`_Float16`** (`clang_frontend.ll`, `@f2`: bfloat to float
  to half). The results differ (Q3).
- `float16 * float` is computed in float (`fcvt.s.h; fmul.s`). `float16 * 2.5` is computed in
  **double** (soft-float `__muldf3`), exactly as in C. Clang does the same.

### 2.5 Vector code (`v2h`/`v2ah` in one GPR)

| C | GCC |
|---|---|
| `a+b`, `a-b`, `a*b` | `vfadd.h`, `vfsub.h`, `vfmul.h` (`.ah` for v2ah) |
| `a*b+c` | `vfmac.h rd,rs1,rs2` (rd is the accumulator) |
| `a*s` with scalar `s`, or `a*(v2h){s,s}` | `vfmul.r.h` (the `.r` form replicates rs2's low half) |
| `a/b` | **scalarized**: 4 x `pv.extract.h`, 2 x `fdiv.h`, `pv.pack.h`. GCC never uses `vfdiv.h`/`vfsqrt.h`. |
| `(v2h){x,y}` from float16 values | `pv.pack.h` |
| `(v2h){(float16)f, (float16)g}` from floats | `vfcpka.h.s` |
| `a[0]`, `a[1]`, `a[1]=x` | nothing, `pv.extract.h ..,1`, `pv.insert.h ..,1` |
| `-a` | `vfneg.h` (= `vfsgnjn.h a,a`) |
| `a<b` (result `v2s`) | `vflt.h` (see 3.5: GVSoC gives 0/1 lanes) |
| `__builtin_shuffle` | `pv.shuffle2.h`, `pv.shuffle.sci.h` (B92, task F019) |
| max/min/abs builtins | `vfmax.h`, `vfmin.h`, `vfsgnjx.h`; `.ah` versions |
| `v2hftov2hi`, `v2hitov2hf`, `v2hftov2ohf` | `vfcvt.x.h`, `vfcvt.h.x`, `vfcvt.ah.h` |
| vector load/store | `lw`/`sw`, `p.lw rd,4(rs!)` post-increment |

Encodings: `vfadd.h 82b52533`, `vfadd.ah 82b51533`, `vfmac.h 90b52633`, `vflt.h a4b52533`.

## 3. The instruction set (GVSoC2 model)

### 3.1 Where it is defined

- `gvsoc2/core/models/cpu/iss/isa_gen/isa_smallfloats.py`: `class Xf16` (line 21), `class Xf16alt`
  (line 82), `class Xf8` (147), `class Xfvec` (231), `class Xfaux` (556).
- The GAP9 cluster and FC cores are `Ri5ky` with `isa='rv32imafc_zfinx'`
  (`gvsoc2/gap9/models/chips/gap/gap9/soc_config.py:277`, `fc_subsystem.py:28`). `Ri5ky` always adds
  `Xf16(), Xf16alt(), Xfvec()` (`gvsoc2/pulp/pulp/cpu/iss/ri5ky.py:95-96`). There is **no Xf8 and no
  Xfaux** on GAP9, so the compiler must not emit `.b`, `vfdotp*`, `fmulex`, `fmacex` or `vfavg`.
- Operands live in the integer register file. With `zfinx`, `FREG_GET/SET` are integer-register
  accesses (`gvsoc2/core/models/cpu/iss_v2/include/isa_lib/macros.h:64-67` and
  `iss_v2/include/regfile.hpp:280-288`). Results are written zero-extended from 16 bits
  (`flexfloat_get_bits`).

### 3.2 Formats

- `.h`: exponent 5, mantissa 10 (`rvXf16.hpp:76`: `lib_flexfloat_add_round(..., 5, 10, UIM_GET(0))`).
- `.ah`: exponent 8, mantissa 7 (`rvXf16alt.hpp:61`: `..., 8, 7, ...`), i.e. **bfloat16**,
  subnormals included (flexfloat handles them).

### 3.3 Scalar ops

- Xf16 (rv32 part): `fmadd/fmsub/fnmsub/fnmadd/fadd/fsub/fmul/fdiv/fsqrt/fsgnj/fsgnjn/fsgnjx/fmin/
  fmax/feq/flt/fle/fcvt.w/fcvt.wu/fcvt.h.w/fcvt.h.wu/fclass.h` plus `fcvt.s.h/fcvt.h.s`. These are
  the standard Zfh encodings. **Measured**: `llvm-mc -mattr=+zfinx,+zhinx` and GAP9 GNU `as` give
  byte-identical code for 14 representative instructions (`tests/xf16_equals_zhinx.s`). So
  GAP9 Xf16 = Zhinx, and `float16` needs no new instructions.
- Xf16alt: the same list with `.ah`, encoded as the `.h` instruction with **funct3 (the rm field)
  = 101** (`isa_smallfloats.py:86-111`, e.g. line 90 `fadd.ah`). Conversions: `fcvt.s.ah`
  (`0100000 00110 .. 000`, line 118: the same encoding as Zfbfmin's `fcvt.s.bf16`), `fcvt.ah.s`
  (`0100010 00000 .. 101`, line 119: *not* Zfbfmin's `fcvt.bf16.s`, which is rs2=01000),
  `fcvt.h.ah` (rm usable) and `fcvt.ah.h` (rm=101) (lines 126-127).

### 3.4 The ALTF rounding-mode encoding

- Because funct3 carries the format, `.ah` arithmetic and conversions have **no rounding-mode
  field**. In GVSoC their `UIM_GET(0)` is never filled (the `Insn` has no `ui12_3`), so they always
  run round-to-nearest-even. **Measured** (`tests/altfrm.c`, `out/altfrm.txt`): with `frm` set to
  RTZ or RDN, `fdiv.h` (rm=dyn) follows `frm` (`5/3` gives 0x3eab, then 0x3eaa), but `fdiv.ah` and
  `fcvt.w.ah` do not (0x3eab and 3 every time). `setFFRoundingMode`
  (`gvsoc2/core/models/cpu/iss/include/isa_lib/int.h:1704-1749`) maps 0 to RNE and 7 to `frm`.
- **Measured** (`tests/altround.c`, 2000 random pairs): `fadd.ah`, `fmul.ah` and `fcvt.ah.s` equal
  float arithmetic followed by RNE rounding to bfloat16 in 2000/2000 cases.
- The fork's Snitch definitions encode `fadd.ah` as `FADD_H` with rm=`0b111`
  (`wt/int-20/llvm/lib/Target/RISCV/RISCVInstrInfoXsmallfloatGen.td:51-52`; the format comes from
  a CSR in Snitch), and `vfadd.ah` as `VFADD_H` (vfmt=10, `...Gen.td:800`). GAP9 needs funct3=101
  for scalar `.ah` and **vfmt=01** for vector `.ah` (`82b51533` vs `.h` `82b52533`). So the Snitch
  definitions give wrong encodings for GAP9 and cannot be reused.

### 3.5 Packed ops (Xfvec, opcode OP 0110011, funct7 = `10`+vecfltop, funct3 = r:vfmt)

- vfmt: `00` = .s, `10` = .h, `01` = .ah, `11` = .b. `r=1` selects the `.r` form (rs2 is a scalar
  that is replicated). Listing: `isa_smallfloats.py:294-345` (.h), 350-406 (.ah).
- Ops, each in `.h`/`.ah` and in plain/`.r` form: `vfadd, vfsub, vfmul, vfdiv, vfmin, vfmax, vfmac,
  vfmre, vfsgnj, vfsgnjn, vfsgnjx, vfeq, vfne, vflt, vfge, vfle, vfgt`. Also `vfsqrt`,
  `vfclass`, `vfmv.x.*`/`vfmv.*.x`, `vfcvt.x.* / xu.* / *.x / *.xu`, `vfcpka.*.s`, `vfcpkb.*.s`,
  `vfcvt.h.ah`, `vfcvt.ah.h` (lines 405-406).
- Semantics that matter for lowering (`gvsoc2/core/models/cpu/iss/include/isa/rv32Xfvec.hpp`):
  - `vfmac`/`vfmre` read rd (accumulator), so rd is a tied operand (`FA_FFF`, `VF_OP3`, lines 108-146).
  - `vfcpka.h.s` writes the low half of rd and keeps the high half; `vfcpkb` writes the high half
    (`VF_CPK`, line 236). rd is tied.
  - `vfcvt.x.h` rounds with `frm` (rm 7, line 350), not by truncation.
  - **Compares return 0 or 1 per 16-bit lane on RI5KY** (`VF_CMP` under `CONFIG_GVSOC_ISS_RI5KY`,
    lines 164-198). **Measured** (`tests/vcmp.c`): `vflt.h {1,3} < {2,2}` = `0x00000001`. GCC
    assumes 0/-1 lanes, so GCC's select `(a & m) | (b & ~m)` gives the wrong answer on GVSoC
    (`0x40004000` instead of `0x40003c00`). See Q2.

### 3.6 Does `ri5ky_testbench` model them?

Yes. The testbench core is `ips.gap.cpu.ri5ky.Ri5ky`
(`gvsoc2/pulp/pulp/ri5ky/ri5ky_testbench.py:25,41`), a subclass of the PULP `Ri5ky` that adds
Xf16/Xf16alt/Xfvec, with `isa='rv32imafc_zfinx'` (`ri5ky_testbench_config.py:118`). Every GCC test
in `tests/` that uses `.h`, `.ah` and `vf*.h` runs on `benchmarks/gap9-sweep/sim/run_sim.sh`.
The harness can therefore check every worker task against GCC on GVSoC.

## 4. What exists in the fork and upstream

### 4.1 Fork (`port/20`)

- Smallfloat instructions: `RISCVInstrInfoXsmallfloat.td` (110 lines: `RVInstRVf` format, lines
  26-41) and `RISCVInstrInfoXsmallfloatGen.td` (1583 lines, generated from Snitch riscv-opcodes).
  The features (`xfalthalf`, `xfquarter`, `xfvec{single,half,althalf,quarter,altquarter}`,
  `xfaux*`, `xfexpaux*`) are defined in that .td file (e.g. `...Gen.td:8-14`) and used only by
  `-mcpu=snitch` (`RISCVProcessors.td:606-640`, which also needs F, D and Zfh). **All operands are
  FPR16/FPR32/FPR64. There are no ISel patterns and no lowering: these are MC-only definitions.**
- Packed integer SIMD: `GPRAV2` [v2i16] and `GPRAV4` [v4i8], which hold the GPRs
  (`RISCVRegisterInfo.td:442-464`), registered at `RISCVISelLowering.cpp:140-143`, with operations
  at 651-706 and post-increment at 719-742. The comment calls them a bridge to upstream's
  GPR-held packed types (upstream P extension at `release/23.x`
  `RISCVISelLowering.cpp:327-338`, which puts v2i16/v4i8 in plain `GPRRegClass`).
- f16/bf16 on PULP: nothing. `bf16` gets FPR16 only with Zfbfmin (`RISCVISelLowering.cpp:123-124`).
  f16 gets GPRF16 with Zhinxmin (`:129-130`).
- Clang: no fp16 builtins in `BuiltinsRISCVXpulp.td`, no `float16` names, no `__gap9__` (F017).
- `RISCVTargetLowering::allowsMisalignedMemoryAccesses`: task 20/F021 (B89, done on work/20/F021,
  commit 1bb87a707e0e) found that the fork reported v2i16/v4i8 as fast at 2-byte alignment, and the
  combiner looped forever. Any new packed FP type must get the same i32 answer.

### 4.2 Upstream LLVM 20 and what can be reused

| upstream piece | reuse for |
|---|---|
| Zhinx/Zhinxmin: `GPRF16` (`RISCVRegisterInfo.td:471`), `RISCVInstrInfoZfh.td` `*_INX` instructions and patterns, CC (`RISCVCallingConv.cpp:397-402`) | **all of `float16`, unchanged**: arithmetic, FMA, compares, conversions incl. `fcvt.w.h rtz`, min/max, abs/neg. Measured in `tests/clang_probe.s`: `fadd.h`, `fmadd.h`, `fmsub.h`, `fcvt.w.h ..,rtz`. |
| clang `HasLegalHalfType` for zhinx (`clang/lib/Basic/Targets/RISCV.cpp:354-355`) | `_Float16` already computed natively, with no excess precision. |
| IR type `bfloat`, clang `__bf16` arithmetic, `HasFullBFloat16` switch (precedent: `clang/lib/Basic/Targets/ARM.cpp:611`, `X86.cpp:309`) | `float16alt`: set `HasFullBFloat16` when `xpulpf16alt` is on, so clang emits `fadd bfloat` with no fpext/fptrunc. |
| `-ffloat16-excess-precision`, `-Xclang -fbfloat16-excess-precision=none` (clang 20 driver has no `-fbfloat16-excess-precision`) | fallback and experiments only (section 5). |
| Zfbfmin (`RISCVInstrInfoZfbfmin.td`) | nothing directly (FPR, conversions only). Its lowering code (bf16 ops Promote to f32, `RISCVISelLowering.cpp:457-465`) is the template for the ops Xf16alt lacks. |
| upstream FPR16 holds `[f16, bf16]` (`release/23.x RISCVRegisterInfo.td:540`) | precedent for adding bf16 to `GPRF16`'s type list. |
| upstream Zfinx `ExtInfo` multiclasses and separate `RVZfinx` decoder namespace (`RISCVInstrInfoF.td`, `RISCVDisassembler.cpp`) | how to define GPR-operand twins of FPR instructions with the same encodings as Snitch's `vf*.h`. |
| P extension packed types in GPR (release/23.x) | the long-term home of v2f16/v2bf16 (step 21-23 porting). |

Runtime-library gap: GAP9 libgcc has `__extendhfdf2 __truncdfhf2 __extendohfdf2 __truncdfohf2`
only. It has **no** `__truncsfbf2`/`__truncdfbf2`, which clang's soft bf16 path calls (see
`tests/clang_probe.s` `a_add`), so today a clang `__bf16` program does not link against GAP9 libgcc.
`tests/run_numeq.sh` links compiler-rt's `truncsfbf2.c` for that reason.

Clang crash found on the way: `__builtin_convertvector(v2h, v2ah)` asserts "Invalid cast!" in
`VisitConvertVectorExpr` (half to bfloat is not an fptrunc/fpext in IR). This is upstream behaviour.
The SDK does not use it (GCC 7 has no `__builtin_convertvector`). Q6.

## 5. Numeric equivalence (measured on GVSoC)

`tests/numeq.c` fills arrays with random 16-bit values (|x| in about [2^-3, 2^3)) and runs 9 kernels.
It prints a hash per kernel. `tests/run_numeq.sh` builds it with GAP9 GCC (`float16`,
`float16alt`, with and without `-ffp-contract=off`) and with port-20 clang (`_Float16` with
`-march=rv32imc_zfinx_zhinx_xpulpv2`, `__bf16` default / `-Xclang -fbfloat16-excess-precision=none`,
`-ffp-contract=fast`), runs everything on `ri5ky_testbench` and prints `out/table.txt`:

```
kernel        gcc-f16     gcc-f16-nocontract  cl-f16      cl-f16-fast  gcc-f16alt  gcc-f16alt-nocontract  cl-bf16     cl-bf16-none  cl-bf16-none-fast
expr          0xc99577d9  0xb2486732          0xc99577d9  0xc99577d9   0x676d8c08  0x9443f78d             0x9ab74ce8  0x9443f78d    0x9443f78d
div           0x0a273cc2  0x3d8aec32          0x0a273cc2  0x0a273cc2   0x40948dbe  0x5ffbddba             0xda3b245f  0x5ffbddba    0x5ffbddba
dot           0x00005432  0x00005431          0x00005432  0x00005432   0x000042c7  0x000042c8             0x000042c7  0x000042c8    0x000042c8
dot_sep       0x00005432  0x00005431          0x00005431  0x00005432   0x000042c7  0x000042c8             0x000042c8  0x000042c8    0x000042c8
toint         0x5437ab32  0x5437ab32          0x5437ab32  0x5437ab32   0x5ad0dbb3  0x5ad0dbb3             0x6349826d  0x6349826d    0x6349826d
fromf         0xa41c2a74  0xa41c2a74          0xa41c2a74  0xa41c2a74   0x57d8d5f6  0x57d8d5f6             0x57d8d5f6  0x57d8d5f6    0x57d8d5f6
fromi         0x2b7eef91  0x2b7eef91          0x2b7eef91  0x2b7eef91   0x41664580  0x41664580             0x41664580  0x41664580    0x41664580
tof           0x8a3c9bb0  0x8a3c9bb0          0x8a3c9bb0  0x8a3c9bb0   0xedf18600  0xedf18600             0xedf18600  0xedf18600    0xedf18600
cmp           138         138                 138         138          136         136                    136         136           136
toint(2.75)   2           2                   2           2            3           3                      2           2             2
toint(-2.75)  -2          -2                  -2          -2           -3          -3                     -2          -2            -2
toint(2.5)    2           2                   2           2            2           2                      2           2             2
```

What the table shows:

1. **`float16`: clang with Zhinx matches GCC bit for bit** once `-ffp-contract=fast` is used
   (`cl-f16-fast` equals `gcc-f16` on every line). With clang's default `-ffp-contract=on`, only
   `dot_sep` differs (`t = a*b; acc = acc + t;`): GCC fuses across statements and clang does not.
2. **`float16alt`, clang default (`cl-bf16`)**: excess precision. `(a+b)*c-a` is computed in float
   and rounded once (`fadd.s`, `fmsub.s`, one `__truncsfbf2`), while GCC rounds after every op
   (`fadd.ah`, `fmsub.ah`). The results differ (expr, div, dot_sep).
3. **`float16alt` with `-fbfloat16-excess-precision=none`**: clang rounds after every op (through
   f32, then RNE; exact, because 24 >= 2*8+2). It then equals GCC with **`-ffp-contract=off`** on
   every arithmetic line (expr, div, dot, dot_sep). The remaining gap to default GCC is FMA
   contraction only. The promoted path cannot fuse (`llvm.fmuladd.bf16` is expanded into separate
   rounded ops), and `-ffp-contract=fast` does not help (`cl-bf16-none-fast` = `cl-bf16-none`).
   **Native `fmadd.ah`/`fmsub.ah` lowering (task T3) closes it.**
4. **`toint`**: GCC's `(int)float16alt` uses `fcvt.w.ah`, which cannot encode RTZ and rounds to
   nearest (2.75 gives 3, -2.75 gives -3). That breaks the C rule (truncation). Clang truncates.
   This difference will stay unless we deliberately copy GCC (Q1).
5. `fromf`, `fromi` (including 32-bit ints, where i32 to f32 to bf16 could double-round), `tof`
   and `cmp` agree everywhere.

**Recommended to make clang match GCC bit for bit**: native lowering (float16 already has it;
float16alt through T3), `HasFullBFloat16` for `xpulpf16alt` (so no excess precision, T4), and
`-ffp-contract=fast` in the clang SDK flags (Q5). Everything else in the table then matches, except
the `(int)float16alt` cast (Q1).

## 6. Recommended mapping and design decisions

1. **`float16` = `_Float16`, Zhinx.** GAP9 `-march` for clang gains `_zhinx`. There is nothing new
   in the backend. `HasLegalHalfType` is already set.
2. **`float16alt` = `__bf16` = IR `bfloat`, new extension `xpulpf16alt`** (name to confirm, Q7;
   implies `zfinx`). The GPR operands use the existing `GPRF16` class with `bf16` added to its type
   list (upstream precedent FPR16 = [f16, bf16]). Legal: fadd/fsub/fmul/fdiv/fsqrt/fma, fminnum/
   fmaxnum, fneg/fabs/fcopysign, setcc (feq/flt/fle), fp_extend to f32 (`fcvt.s.ah`), fp_round from
   f32 (`fcvt.ah.s`), bf16 <-> f16 (`fcvt.ah.h`/`fcvt.h.ah`, via a combine on
   `fp_round(fp_extend x)`), sint/uint_to_fp (`fcvt.ah.w[u]`), and lrint/lround-to-int with
   `fcvt.w.ah` (RNE). **fp_to_sint/uint = promote to f32** (`fcvt.s.ah` + `fcvt.w.s rtz`), because
   `fcvt.w.ah` cannot truncate (Q1). f64 conversions are libcalls. For GAP9, set the libcall names
   to libgcc's `__extendohfdf2`/`__truncdfohf2` (or extend through f32, which is exact, and truncate
   with `__truncdfohf2`), so programs link against GAP9 libgcc.
3. **`v2h` = v2f16, `v2ah` = v2bf16 in GPR, new extension `xpulpfvec`** (implies xpulpv2; the `.h`
   half is predicated on zhinx, the `.ah` half on xpulpf16alt). Add both types to `GPRAV2`'s type
   list (or to plain GPR once the port reaches upstream P). Legal: fadd/fsub/fmul/fma (`vfmac`,
   tied), fminnum/fmaxnum, fneg/fabs/fcopysign (vfsgnj*), sint/uint_to_fp from v2i16 (`vfcvt.h.x`),
   build_vector (`pv.pack.h`; `vfcpka.h.s` when both elements are f32 truncations),
   extract/insert_vector_elt (subregister / `pv.extract.h` / `pv.insert.h`), vector_shuffle (the
   v2i16 lowering, through a bitcast), load/store promoted to i32 with post-increment. The splat
   operand folds to the `.r` form. **fdiv/fsqrt: Expand (scalarize) like GCC.** setcc: Custom,
   because GVSoC lanes are 0/1 while PULP BooleanVectorContents is 0/-1: emit `vf<cmp>` + `pv.sub.h`
   from zero, or `vfne`-style tricks (Q2). fp_to_sint: Expand (`vfcvt.x.h` rounds with `frm`).
   `allowsMisalignedMemoryAccesses` must give v2f16/v2bf16 the i32 answer (F021).
4. **Type names in clang**: when the GAP9 fp16 extensions are on, predefine
   `#define float16 _Float16` and `#define float16alt __bf16` in
   `clang/lib/Basic/Targets/RISCV.cpp` (a fork file, clang-driver cluster). A Sema implicit typedef
   (`ASTContext::buildImplicitTypedef` in `Sema::Initialize`) is closer to GCC (it can be shadowed)
   but edits an upstream file the fork does not touch (rule 11). A grep of the SDK found no use of
   `float16`/`float16alt` as an identifier or in `#if(n)def`, so the macro is safe for the SDK.
5. **Builtins**: `__builtin_pulp_f16*`, `f16alt*`, `*2`, and the `v2*to*` conversions. Scalar
   abs/max/min/sqrt and vector abs/max/min lower to the generic nodes (FABS/FMAXNUM/FMINNUM/FSQRT)
   through target intrinsics. The `v2hftov2hi(_u)`/`v2ohftov2hi(_u)` rounding conversions become
   target intrinsics selecting `vfcvt.x[u].h/.ah` (dynamic rounding, not fptosi).
   `v2hftov2ohf`/`v2ohftov2hf` become intrinsics selecting `vfcvt.ah.h`/`vfcvt.h.ah`.

## 7. Worker tasks (dependency order)

Prerequisites: 20/F021 (B89 misaligned v2i16, done, must be landed), 20/F017 (`__gap9__` and the
GAP9 key), 20/F019 (`__builtin_shuffle`, needed by the f16 MatMul/FFT kernels), 20/F018 (CoreCount,
needed by the CNN kernels). The GVSoC check for every task: build the same C test with GAP9 GCC and
with the task's clang, run both on `ri5ky_testbench` (`benchmarks/gap9-sweep/sim/run_sim.sh`), and
require identical output. `tests/run_numeq.sh` is the template (set `CLBIN=` to the worker build).

| # | task | owner cluster(s) and files | size | depends on | verification |
|---|---|---|---|---|---|
| T0 | **GAP9 -march uses Zhinx for `float16`**: nothing in LLVM. Confirm that `_zhinx` is accepted next to `xpulpv2` everywhere (driver, `-mcpu` from F017 if it adds a GAP9 CPU: add `FeatureStdExtZhinx` to it), plus `f16` post-increment loads (`setIndexedLoadAction(POST_INC, f16)` under Zhinx+Xpulpv2, mirroring the fork's f32/Zfinx line `RISCVISelLowering.cpp:736-737`) | registration (`RISCVProcessors.td`, only if F017 adds a CPU); codegen-core (`RISCVISelLowering.cpp`) | S (~10 lines) | F017 | `tests/run_numeq.sh`: `cl-f16-fast` = `gcc-f16` (already true today); `h_axpy` of `gcc_scalar.c` gets `p.lh ..,2(a1!)` like GCC; GAP9 sweep assembly for non-fp16 kernels unchanged |
| T1 | **Register `xpulpf16alt` and `xpulpfvec`** (RISCVExtension, implications on zfinx/xpulpv2, Subtarget getters, ISA-string round trip) | registration (`RISCVFeatures.td`, `RISCVSubtarget.h`, `RISCVISAInfoTest.cpp`) | S (~60 lines) | — | `llc -mattr=+xpulpf16alt,+xpulpfvec`; `clang -march=rv32imc_zfinx_zhinx_xpulpv2_xpulpf16alt_xpulpfvec -###`; RISCVISAInfo unit test; `.riscv.attributes` string |
| T2 | **MC: GPR-operand GAP9 instructions**: scalar `.ah` (the 24 rv32 Xf16alt ops plus `fcvt.s.ah/ah.s/h.ah/ah.h`, rm fixed 101 where the encoding says so) and Xfvec `.h`/`.ah` (plain and `.r` forms of `vfadd..vfgt`, `vfsqrt`, `vfclass`, `vfmv`, `vfcvt.*`, `vfcpka/b.*.s`, `vfcvt.h.ah/ah.h`), with a GAP9 decoder namespace separate from Snitch's FPR twins. Suggest generating the .td from `isa_smallfloats.py` with a small script kept in the harness | insn-tablegen (new `RISCVInstrInfoXpulpfloat.td` (matches `RISCVInstrInfoX(pulp...)`), include in `RISCVInstrInfo.td`); mc (`Disassembler/RISCVDisassembler.cpp` namespace; AsmParser only if operand parsing needs it) | M-L (~350 lines td, ~20 C++) | T1 | assemble `tests/gcc_scalar.s` and `tests/gcc_vector.s` with `llvm-mc` and GNU `as -march=rv32imcxgap9`: `.text` byte-identical; `llvm-objdump -d` of GCC objects prints the same mnemonics; Snitch MC tests unchanged |
| T3 | **Scalar bf16 codegen in GPRs** (decision 6.2): `GPRF16` gets bf16; `addRegisterClass(bf16, GPRF16)`; operation actions; ISel patterns (in T2's .td); CC like Zhinx f16 (`RISCVCallingConv.cpp:397`); lh/sh load/store and post-increment; constant materialization; libcall names for f64 | codegen-core (`RISCVRegisterInfo.td`, `RISCVISelLowering.cpp`, `RISCVCallingConv.cpp`, `RISCVInstrInfo.cpp` if copies need it); insn-tablegen (patterns); tests (new lit tests) | L (~300 lines) | T1, T2, F021 | lit (new `xpulpf16alt-*.ll`); `tests/run_numeq.sh` with T4 or `-Xclang -fbfloat16-excess-precision=none`: every line except `toint` equals `gcc-f16alt` (FMA now fused); `tests/altround.c` rebuilt with clang gives 2000/2000; links against GAP9 libgcc without compiler-rt |
| T4 | **Clang front end for GAP9 fp16**: `HasFullBFloat16` when xpulpf16alt is on; `float16`/`float16alt` macros (decision 6.4) when zhinx+xpulpf16alt (+GAP9 key from F017) | clang-driver (`clang/lib/Basic/Targets/RISCV.cpp`); tests | S (~20 lines) | T3 (without it `__bf16` needs `__truncsfbf2`, missing from libgcc), F017 | SDK `Gap.h` compiles on the `__gap9__` path; `-emit-llvm` shows `fadd bfloat` with no fpext/fptrunc; `tests/numeq.c` compiled with `-DT=float16alt` (no `-DT=__bf16`) reproduces the T3 table |
| T5 | **Packed v2f16/v2bf16 codegen** (decision 6.3) incl. setcc lane fix, splat to `.r`, `vfmac` tied accumulator, `vfcpka.h.s` build_vector, post-increment, misaligned rule | codegen-core (`RISCVRegisterInfo.td` GPRAV2 type list, `RISCVISelLowering.cpp`, `RISCVISelDAGToDAG.cpp` if the tied `vfmac`/`vfcpka` need manual selection); insn-tablegen (patterns); tests | L (~400 lines) | T2, T3, T0, F021 | lit; a new `tests/vnumeq.c` (vector version of numeq: add/mul/mac/splat-mul/pack/extract/div, v2h and v2ah) GCC vs clang on GVSoC bit-exact; assembly of `tests/gcc_vector.c` compiled by clang uses the same instruction classes as `gcc_vector.s`; integer SIMD sweep kernels byte-identical |
| T6 | **fp16 builtins** (section 1 list, 26 names) | clang-builtins (`BuiltinsRISCVXpulp.td`, `SemaRISCV.cpp` if checks are needed); intrinsics (`IntrinsicsRISCVXpulp.td`); codegen-core (lowering intrinsics to FMAXNUM etc.); insn-tablegen (patterns for vfcvt intrinsics); tests | M (~200 lines) | T3, T5 | one GVSoC test per builtin, GCC vs clang, including NaN, -0.0, +-inf and rounding-boundary inputs; `DSP_Libraries/FloatDefines.h` users compile (survey) |
| T7 | **GCC-compatibility Sema rules**, only if the owner accepts the upstream-file edit (Q3, Q4): `float16 op float16alt` computed in float16alt; variadic promotion of `_Float16`/`__bf16` to double for GAP9 | Sema (`clang/lib/Sema/SemaExpr.cpp`, not a fork file: needs an `Upstream-File-Edit:` trailer; reviewer decides) | S-M | T4 | GVSoC: `mix_ha`-style expressions and a varargs callee compiled by GCC called from clang code (and the reverse) |
| T8 | **End-to-end acceptance** (conductor/benchmark): rerun the SDK compile survey without the fp16probe shim; bit-exact GVSoC runs of 3 SDK kernels vs GCC: `CNN_MatMul_Conv_fp16.c` (default = float16alt, and `-DSTD_FLOAT`), `DSP_Libraries/MatrixFunctions/MatMulDSP.c` (float16), `DftLibraryf16a.c` (FFT, also the B89 reproducer) | benchmarks only | M | T0-T6, F018, F019 | survey report delta (the fix ranking predicts about +38 files for "float16/float16alt/v2h/v2ah"); byte-identical output buffers GCC vs clang on GVSoC; instruction mix (count of `vfmac.h`, `fmadd.ah`, `p.lw` post-increment) near GCC's |

Suggested landing order: T0, T1, T2 (can run in parallel with T0), T3, T4, T5, T6, then T7 if
approved, then T8. T3 and T5 are the large ones. Splitting T5 into arithmetic (T5a) and
shuffles/build/extract/setcc (T5b) keeps each under one root cause.

## 8. Open questions

- **Q1 `(int)float16alt`.** GCC emits `fcvt.w.ah` without RTZ, and it rounds to nearest (measured:
  2.75 gives 3). Does RTL use `frm` (dynamic) or a fixed RNE for ALTF ops? GVSoC uses fixed RNE,
  ignoring `frm` (measured). Recommendation: clang follows C (truncate through f32, 2 instructions)
  and we document the GCC deviation. Copying GCC would be a non-conforming option, and any kernel
  whose output depends on it is already GCC-specific.
- **Q2 vector compare lanes.** GVSoC's RI5KY model returns 0/1 per lane, and GCC generates code
  that assumes 0/-1 (GCC's select is wrong on GVSoC, `tests/vcmp.c`). Which one matches the
  silicon? The LLVM lowering depends on the answer (add a `pv.sub.h` negate, or not). Until it is
  answered, follow GVSoC (the only oracle we run).
- **Q3 mixed `float16`/`float16alt` arithmetic.** GCC computes in float16alt, clang in _Float16.
  The SDK does mix them (`CNN_Defines_fp16.h:77`, `swish_lut_f16a(__x, (f16)1.0f)`). Is an upstream Sema edit acceptable (T7), or do
  we accept the difference? Either way, measure how many SDK expressions are affected first (add a
  temporary warning in a probe build).
- **Q4 varargs.** GCC promotes float16/float16alt to double in `...` calls; clang (C23 rules) does
  not. It only matters for printf-like calls with fp16 arguments. Same upstream-file question as Q3.
- **Q5 `-ffp-contract`.** GAP9 GCC fuses across statements (fast), clang's default is `on`. For
  bit-exact parity, SDK builds with clang should pass `-ffp-contract=fast`. Should the GAP9 driver
  default change instead (clang-driver cluster)? Recommendation: flag in the SDK rules, no default
  change.
- **Q6 `__builtin_convertvector(v2h, v2ah)` crash** in clang 20 (upstream). Not used by the SDK.
  Report upstream or leave it alone.
- **Q7 names.** `xpulpf16alt`/`xpulpfvec` follow the fork's `xpulpv` style and avoid clashing with
  Snitch's `xfalthalf`/`xfvechalf` (different encodings and register files). Owner to confirm, and
  to say whether `-mcpu=gap9` (F017) should imply them.
- **Q8 FC vs cluster.** GVSoC gives the FC the same smallfloat ISA as the cluster PEs
  (`fc_subsystem.py:28`), and GCC has no separate FC fp16 switch. Assume both have it.
- **Q9 `vfdiv`/`vfsqrt`.** GVSoC models them, but GCC never uses them. Follow GCC (scalarize) unless
  GreenWaves documentation says the hardware has them.

## 9. Files in this directory

| file | what |
|---|---|
| `tests/gcc_scalar.{c,s}`, `tests/gcc_vector.{c,s}`, `tests/gcc_promotions.{c,s}`, `tests/gcc_vcmp_codegen.c` | GAP9 GCC code generation probes (section 2) |
| `tests/numeq.c`, `tests/run_numeq.sh`, `tests/out/table.txt` and `*.txt` | numeric-equivalence experiment (section 5); rerun with `CLBIN=<build>/bin tests/run_numeq.sh` |
| `tests/altround.c`, `out/altround.txt` | `.ah` ops are RNE (2000/2000) |
| `tests/altfrm.c`, `out/altfrm.txt` | `.ah` ops ignore `frm`; `.h` ops follow it |
| `tests/vcmp.c`, `out/vcmp.txt` | vector compare lanes are 0/1 on GVSoC |
| `tests/clang_probe.{c,s}`, `tests/clang_abi.{c,s}`, `tests/clang_frontend.{c,ll}` | current port-20 clang behaviour for `_Float16`/`__bf16` and vectors |
| `tests/xf16_equals_zhinx.s` | GAP9 Xf16 = Zhinx encodings (llvm-mc vs GNU as, byte-identical) |


> **Review notes for T3/T5 (2026-09-29, from the 20/F040 review):** `vfcpka.h.s` overwrites the whole 32-bit rd in GVSoC (`VF_CPK`: rs1 -> lane 0, rs2 -> lane 1), so it does NOT keep the high half of rd — drop the rd tie in T5 and correct any text saying otherwise. Packed rounding ops use the dynamic rounding mode, so all rounding `vf*` instructions need `Uses = [FRM]`. The GPR half-precision register class accepts only f16: T3 must add bf16 before `.ah` patterns. GVSoC swaps vfsgnj.ah / vfsgnj.r.ah (backlog B127).


> **Correction (2026-09-29, board-pack probe t3):** on both GVSoC models the packed fp16 compares write a bitmask (lane i true sets bit i; e.g. only lane 1 true gives 0x00000002), not 0/1 per lane as Q2 states. The earlier test only had lane 0 true. The silicon answer comes from benchmarks/board-pack t3.


## Board finding 2026-10-06: vfmre sign (B151)

On GAP9 silicon `vfmre.h` and `vfmre.ah` compute `a*b - rd` (rs1*rs2 minus the accumulator), on both the cluster and the FC core; `vfmac.h`/`.ah` compute `rd + a*b`. GVSoC computes `rd - a*b` for vfmre, which is wrong (board-pack test `t8_vfmre_sign_b151`). T5 patterns must select vfmre for `a*b - c` (as GAP9 GCC does), and GVSoC runs of code using vfmre must not be used as the oracle until the simulator is patched.
