# Spec: missing `__builtin_pulp_*` builtins used by the GAP9 SDK

Written 2026-09-28 for the PULP LLVM port. This is a read-only specification task: nothing under the LLVM tree was changed. Machine-readable version: `spec.json` (same content, one record per builtin, plus GCC asm, encodings and every SDK source line that names the builtin). GCC reference tests: `gcc/<builtin>.c` and `gcc/<builtin>.s`; diagnostics probes: `gcc/diag/*.c` (+ `diag.json`); raw probe data: `gcc/gcc_prototypes_gap9.json`, `gcc/gcc_prototypes_gap8.json`, `gcc/encodings.json`.

## 1. Scope and how the list was derived

- **Baseline:** `build/int-20` (clang 20.1.8, fork commit `7459255b6120`, same as the integration head in the 20/F0xx tasks). Defined builtins: every `def` in `wt/int-20/clang/include/clang/Basic/BuiltinsRISCVXpulp.td` (the only `BuiltinsRISCV*.td` with PULP builtins).
- **SDK list:** the 212 names in `benchmarks/sdk-compile-survey/builtins.json`. Missing against int-20: **70** `__builtin_pulp_*` names (the survey's 71 includes `__builtin_shuffle`, which is task 20/F019). The re-derivation agrees with the survey exactly; nothing new landed on int-20 since.
- **Excluded here:** `OffsetedWritePtr` and `event_unit_read_fenced` (20/F016). `CoreCount` is already defined (its folding is 20/F018). That leaves **68** builtins, all specified below.
- **GCC reference:** `/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc` 7.1.1, `-march=rv32imcxgap9 -mPE=8 -mFC=1 -O2`. Builtins GAP9 GCC does not know were retried with `-march=rv32imcxgap8`. Prototypes were read from GCC's own diagnostics (pass a struct, read "expected 'T'"; assign the result to a struct, read "from type 'T'"), so they are GCC's exact types.
- **Fork instruction check:** every instruction GCC emitted was assembled with GAP9 gas (gives the reference encoding) and with int-20 `llvm-mc` under `+m,+c,+xpulpv`, `+m,+c,+zfinx,+zhinx,+xpulpv` and the Snitch smallfloat set; the GCC encoding was also disassembled with int-20. Result per instruction in `gcc/encodings.json`.
- **Semantics:** GVSoC (public GAP SDK): `gvsoc2/gap9/models/ips/gap/cpu/gap9_isa.py` (GAP9-only instructions), `gvsoc2/core/models/cpu/iss/include/isa/rvXgap9.hpp` + `isa_lib/int.h` (their semantics), `gvsoc2/core/models/cpu/iss/isa_gen/isa_smallfloats.py` + `include/isa/rv32Xfvec.hpp` (smallfloat), cross-checked with the SDK's own emulation fallbacks (`tools/autotiler_v3/Emulation/GapBuiltins.h:460-621`).

## 2. Findings that change the plan

1. **10 of the 68 are not GAP9 builtins at all** (batch X): `add4div2/4`, `sub4div2/4`, `cplxmuls`, `cplxmulsdiv2/4`, `vitmax2`, `vitsel2` exist only in GAP8 GCC (GAP9 GCC: "implicit declaration"), and `cplxmjrot2` exists in no GAP GCC target. Their SDK wrappers are dead code on GAP9 (no call sites, or behind `__GAP8__`/`__gap8__`). Do not implement them.
2. **23 builtins need no new instruction and no fp16** (batches A and C): the f32 builtins map to standard F/Zfinx instructions, and all 11 `mulf*`/`macf*` builtins are exact aliases of builtins we already have (`muls`, `mulsN`, `mulsRN`, `mulu`, `muluN`, `macs`, `macsN`, `macsRN`, `macu`, `macuN`, `macuRN`): GAP9 GCC emits the identical instruction for both spellings (`gcc/*.s`, plus a side-by-side check). `mul64h*` are the standard M `mulh/mulhu/mulhsu` (GCC prints them as `p.mulh...`, the encodings are the M ones), `trunch` is `p.exths`, `truncb` is `andi 0xff`.
3. **Batch B needs new instructions:** none of the GAP9 complex/divN instructions exist in the fork (llvm-mc: unknown mnemonic; disassembler: invalid encoding). They are GAP9 additions on top of PULPv2 (listed separately in GVSoC's `Gap9` ISA subset), so putting them under `xpulpv` would let clang emit them for RI5CY/PULPv2 cores that lack them. **Decision needed from the conductor:** a new extension name (GCC calls the arch `xgap9`) or accept `xpulpv`. Upstream CORE-V has the same operations as MC-only definitions (`RISCVInstrInfoXCV.td:467-491`, `cv.cplxmul.r/i`, `cv.subrotmj`, `cv.cplxconj`, `cv.add/sub.divN`) in a different opcode space; that is the rule-12 reference for the definitions.
4. **24 builtins depend on fp16 (B90)**: 4 (batch D: scalar `float16`) need only `float16 = _Float16` with Zhinx, since upstream Zhinx already has `fmax.h/fmin.h/fsqrt.h/fabs.h` with the GAP9 encodings (checked). The other 20 (batch E) also need **new GPR-register GAP9 smallfloat instructions**: the fork's `Xfalthalf`/`Xfvechalf` are the Snitch variants (FPR registers), and the fork's `fmax.ah` assembles to the `fmax.h` encoding (Snitch picks alt-half by a CSR; GAP9 encodes it in funct3=101: `fmax.ah` = `2cb55553`, `fmax.h` = `2cb51553`). This belongs to the B90 design.
5. **`CoreCount_m1`** is folded by GCC to `-mPE` minus 1 (7 with `-mPE=8`, usable in static initializers); without `-mPE` it is the run-time core count minus 1. It should be done inside 20/F018 with `CoreCount` (batch F).
6. **Unlock effect:** batches A-C are necessary but, apart from `libs/gap_lib/jpeg/dct.c` (batch C alone), every file that needs them also needs the float16 types (B90) and often `CoreCount`/`__builtin_shuffle`. Section 5 has the exact combinations.
7. **GCC defects found (for `benchmarks/gcc-bugs`, not for us to copy):**
   - `__builtin_pulp_macfs/macfu` make GCC print `p.macs a0,a0,a1,a2` (4 operands), which GAP9 gas rejects ("illegal operands"): any use fails to assemble with GCC. Clang should emit what `__builtin_pulp_macs/macu` emit.
   - `mulfsN`/`mulsN` with N=32 or N=-1: GCC internal compiler error (`extract_insn, recog.c:2311`). Clang must diagnose (existing range check 0..31).
   - GCC ignores the rounding argument of the `*RN` builtins (`mulfsRN(a,b,4,3)` emits `p.mulsRN ...,4`); our Sema requires it to equal 2^(N-1). Keep our check for consistency with the existing `mulsRN` (and see survey step 6 for the separate "accept what GCC accepts" question).
   - Non-constant N is an error in GCC too ("invalid argument to built-in function on arg 3") when it is not constant after optimization; the SDK files that pass a variable N work in GCC only because inlining makes it constant.

## 3. Batches (one worker task each)

| batch | builtins | needs new insn | blocked on | size | files touched |
|---|---|---|---|---|---|
| A | 7 f32 scalar | no | - | S | BuiltinsRISCVXpulp.td, IntrinsicsRISCVXpulp.td, RISCVISelLowering.cpp (or RISCVInstrInfoXpulp.td patterns), new tests |
| B | 10 complex/divN | yes (16 defs) | feature-name decision | M | RISCVFeatures.td (if new feature), RISCVInstrInfoXpulp.td, IntrinsicsRISCVXpulp.td, BuiltinsRISCVXpulp.td, new MC + codegen tests |
| C | 16 aliases, mul64h, trunc | no | - | S-M | BuiltinsRISCVXpulp.td, IntrinsicsRISCVXpulp.td, RISCVInstrInfoXpulp.td, SemaRISCV.cpp, RISCVISelLowering.cpp (trunch/truncb), new tests |
| D | 4 float16 scalar | no (Zhinx) | B90 type part | S | as A, with `_Float16` |
| E1 | 4 float16alt scalar | yes | B90 + GAP9 alt-half GPR insns | M | smallfloat td (GAP9 variant), intrinsics, builtins |
| E2 | 6 v2h/v2ah max/min/abs | yes | B90 + GAP9 GPR vector insns | M | same |
| E3 | 10 packed conversions | yes | B90 + GAP9 GPR vfcvt insns | M | same |
| F | CoreCount_m1 | no | fold with 20/F018 | XS | wherever F018 folds CoreCount |
| X | 10 GAP8-only / nonexistent | - | - | none | - |

A, B and C touch overlapping files (BuiltinsRISCVXpulp.td, IntrinsicsRISCVXpulp.td) but in disjoint, append-only places; they can run in parallel and be merged in any order (expect trivial textual conflicts at the end of each file). All three are independent of B90.

### Common implementation pattern (A, B, C)

How the fork adds a PULP builtin today (follow it; files already carry fork hunks):
- clang builtin: `def <name> : PULPBuiltin<"<prototype>", "<features>">;` in `clang/include/clang/Basic/BuiltinsRISCVXpulp.td` (spelling becomes `__builtin_<name>`, e.g. `def pulp_f32max`). Use `Attributes = [NoThrow, Const]` like the other pure builtins.
- IR intrinsic with `ClangBuiltin<"__builtin_pulp_<name>">` in `llvm/include/llvm/IR/IntrinsicsRISCVXpulp.td` (multiclass `PulpIntrinsic`, and ready-made `PulpBinary32`, `PulpTernary32`, `PulpBinaryV2`, `mul_mac_N_RN`). Clang's generic path (`CGBuiltin.cpp:6455`, `getIntrinsicForClangBuiltin`) then calls it; it only bitcasts arguments/results, so the intrinsic's types must match the C prototype exactly (i16/i8 for short/char returns).
- selection: `Pat<>` in `llvm/lib/Target/RISCV/RISCVInstrInfoXpulp.td` (see `PatGprGpr<int_riscv_pulp_muls, P_MULS>` at :1844, `int_mul_mac_N_RN` at :1150), or a case in `RISCVTargetLowering::LowerINTRINSIC_WO_CHAIN` (`RISCVISelLowering.cpp:9851`, already Custom for i32/Other) when the builtin equals a generic ISD node.
- immediates: `_Constant` in the prototype, `ImmArg<>` on the intrinsic, range checks in `SemaRISCV.cpp` (`NormArgNum`/`RoundArgNum` lists at :1403-1427).
- Rule-12 reference for "builtin = generic operation": upstream CORE-V emits generic IR for those from `EmitRISCVBuiltinExpr` (`CGBuiltin.cpp:23441`, `cv_alu_exths` = sext(trunc)). `CGBuiltin.cpp` is **not** fork-touched, so doing the same needs an `Upstream-File-Edit:` trailer (rule 11); the intrinsic + lowering route stays inside fork files. The conductor should pick one route for A and C; this spec gives the lowering for both.
- tests: new files only (rule 2 forbids editing existing tests): a clang CodeGen test (builtin -> IR) and an llc test (IR -> instruction) per batch; for B also an MC round-trip test with the GCC encodings from `gcc/encodings.json`; Sema diagnostics tests for the constant arguments.

### Batch A: f32 scalar builtins on existing F/Zfinx instructions (size S)

Builtins: `f32max`, `f32min`, `f32abs`, `f32sqrt`, `rintsf2`, `rdownsf2`, `rupsf2`. Features: `"xpulpv,f|zfinx"` (GAP9 is Zfinx; the survey's clang flags are `rv32imc_zfinx_xpulpv2`).

| builtin | prototype | lowering | instruction |
|---|---|---|---|
| f32max | `float(float, float)` | ISD::FMAXIMUMNUM (exact fmax.s semantics; Legal for F/Zfinx at LLVM 20, `RISCVInstrInfoF.td:629`) | `fmax.s` |
| f32min | `float(float, float)` | ISD::FMINIMUMNUM | `fmin.s` |
| f32abs | `float(float)` | ISD::FABS | `fabs.s` (= `fsgnjx.s rd,rs,rs`) |
| f32sqrt | `float(float)` | ISD::FSQRT | `fsqrt.s` (rm=dyn) |
| rintsf2 | `int(float)` | RISCVISD::FCVT_X, frm RMM (patterns exist for F and Zfinx, `RISCVInstrInfoF.td:731/751`) | `fcvt.w.s rd,rs,rmm` |
| rdownsf2 | `int(float)` | RISCVISD::FCVT_X, frm RDN | `fcvt.w.s rd,rs,rdn` |
| rupsf2 | `int(float)` | RISCVISD::FCVT_X, frm RUP | `fcvt.w.s rd,rs,rup` |

Checked on int-20 llc: `maxnum`, `fabs`, `sqrt`, `fptosi(round|floor|ceil)` and `lround` already select exactly these instructions with `+zfinx`; FCVT_X is preferred for the rounding builtins because it keeps the saturating fcvt.w.s behaviour (NaN -> 0x7fffffff) where `fptosi` is poison. GCC behaviour to match: int arguments are converted (`fcvt.s.w`), double arguments truncated to float; GCC folds f32max/min/abs of constants (DAG folding of the generic nodes does the same) but not f32sqrt or the conversions. Call sites: `FloatDefines.h:95-101` (`Absf32`, `Maxf32`, `Minf32`, `Sqrtf32`), `GapBuiltins.h:250-256` (`gap_f32*`), `at_api.h:126` (`AT_SCALEF`). Needed by 15/9/7/5/2 SDK files (f32max/min/abs/sqrt/rintsf2).

### Batch B: GAP9 complex / divN packed-SIMD builtins (size M)

New instructions (all `OP-V` 0x57, R-type, GPR operands, from `gap9_isa.py:75-98`; encodings confirmed with GAP9 gas):

| instruction | funct7 | funct3 | format | GVSoC semantics |
|---|---|---|---|---|
| pv.add.h.div2/div4/div8 | 0111010 | 010/100/110 | rd, rs1, rs2 | `VEC_OP_DIV{2,4,8}(ADD, int16)`: r[i] = (int16)(a[i]+b[i]) >> k |
| pv.sub.h.div2/div4/div8 | 0110010 | 010/100/110 | rd, rs1, rs2 | same with `-` |
| pv.subrotmj.h(.div2/4/8) | 0110110 | 000/010/100/110 | rd, rs1, rs2 | `lib_VEC_ADD_16_ROTMJ*`: re = a.im-b.im, im = b.re-a.re (then >>k) |
| pv.cplxconj.h | 0101110 | 000, rs2=00000 | rd, rs1 | re = a.re, im = -a.im |
| pv.cplxmul.h.r(.div2/4/8) | 0101010 | 000/010/100/110 | rd(read+write), rs1, rs2 | rd[15:0] = (a.re*b.re - a.im*b.im) >> (15+k); rd[31:16] kept |
| pv.cplxmul.h.i(.div2/4/8) | 0101011 | 000/010/100/110 | rd(read+write), rs1, rs2 | rd[31:16] = (a.re*b.im + a.im*b.re) >> (15+k); rd[15:0] kept |

(Also `pv.pack.h.h` and `p.bitrev` are in the GAP9 subset; no builtin in scope uses them.) The `.r/.i` pair reads rd (GVSoC `Format_RRRR`), so define them with the fork's `Pulp_ALU_rr_wb` class (tied `$rd = $rd_wb`), like upstream `CVSIMDRRWb`. Define all 16 (the `.div8`/`subrotmj.divN` ones have no builtin but are needed for inline asm and GCC-object disassembly).

Builtins (all `_Vector<2, short>` in and out, `cplx_conj` unary; element 0 = bits 15:0 = real):

| builtin | selection |
|---|---|
| add2div2, add2div4 | PV_ADD_H_DIV2 / _DIV4 |
| sub2div2, sub2div4 | PV_SUB_H_DIV2 / _DIV4 |
| sub2rotmj | PV_SUBROTMJ_H |
| cplx_conj | PV_CPLXCONJ_H |
| cplxmuls2, cplxmuls2div2/4/8 | `(PV_CPLXMUL_H_I[_DIVk] (PV_CPLXMUL_H_R[_DIVk] (IMPLICIT_DEF), a, b), a, b)`, exactly GCC's two-instruction sequence |

Optional extras GCC also has but the SDK never calls: `add2div8`, `sub2div8` (`gcc/extras_unused_by_sdk.s`). Intrinsics: `PulpBinaryV2`/`PulpUnaryV2`-style (`<2 x i16>`, `IntrNoMem`). GCC accepts any 4-byte vector argument (a `v4s` passes silently); clang's default lax integer-vector conversion gives the same. No constant folding in GCC. Semantic traps for the implementer and the reviewer: the divN sums wrap to 16 bits before the shift (not a widening average); products are 64-bit and truncated, no saturation; `-(-32768)` wraps. Only SDK user: `DSP_Libraries/TransformFunctions/FftLibraryFix.c` (via `gap_*` wrappers in `GapBuiltins.h:158-179`, which pick `cplxmuls2*` under `__GAP9__`; `pmsis_gcc.h:593-616` and `builtins_gap9.h:202-228` define the `__CPLX*`/`__ADD2*` spellings).

### Batch C: fractional aliases, 64-bit high multiply, truncations (size S-M)

| builtin | GCC prototype | same as | instruction | implementation |
|---|---|---|---|---|
| mulfs | int(int,int) | muls | p.muls | `defm mulfs : PulpBinary32` + `PatGprGpr<.., P_MULS>` |
| mulfu | int(int,int) | mulu | p.mulu | same with P_MULU |
| mulfsN, mulfsRN, macfsN, macfsRN | int(..., N[, R]) | mulsN, mulsRN, macsN, macsRN | p.mulsN, p.mulsRN, p.macsN, p.macsRN | `defm fs : mul_mac_N_RN;` (intrinsics) + `defm : int_mul_mac_N_RN<"fs", "S">;` (patterns) |
| mulfuN, macfuN, macfuRN | same | muluN, macuN, macuRN | p.muluN, p.macuN, p.macuRN | `defm fu : mul_mac_N_RN;` + `int_mul_mac_N_RN<"fu", "U">` (this also creates `mulfuRN`, which GAP9 GCC has too; define its builtin as well) |
| macfs, macfu | int(x, y, acc) | macs, macu | p.macs / p.macu rdacc,rs1,rs2 | `PulpTernary32` + the pattern at :1757-1758 |
| mul64hs | int(int,int) | - | mulh | pattern `(int_riscv_pulp_mul64hs a, b) -> (MULH a, b)` or ISD::MULHS |
| mul64hu | int(int,int) | - | mulhu | MULHU / ISD::MULHU |
| mul64hus | int(x,y) | - | mulhsu rd, y, x | `(MULHSU y, x)`: y is the signed operand and goes to rs1 (GCC: `p.mulhsu a0,a1,a0`) |
| trunch | short(int) | - | p.exths | intrinsic `i16 (i32)` + `ReplaceNodeResults`/`LowerINTRINSIC_WO_CHAIN` case -> ISD::TRUNCATE (the call's C result is short; the use site's sext selects p.exths, a store selects sh as in GCC) |
| truncb | char(int) | - | andi 0xff | same with i8; plain char is unsigned on RISC-V, as in GCC (the SDK emulation uses signed char; follow GCC) |

Argument positions for the new N/RN entries in Sema: mul*: N at 2, R at 3; mac*: N at 3, R at 4 (same as the existing lists). Features `"xpulpv"` (mul64h* also need `m`; GAP9 has it). Existing IR intrinsics reused: none for the new spellings (each ClangBuiltin name needs its own intrinsic), but all patterns and instruction definitions exist. Users: `libs/gap_lib/jpeg/dct.c` (11 `mulfsN` with constant Q11, 16 `trunch`; this file is unlocked by batch C alone), `FastFixedApprox.h:271-274` (`gap_mul64uh`, included by `MathFuncsFix.c`).

### Batch D: float16 scalar builtins (size S, blocked on B90 type part)

`f16max`, `f16min` (`_Float16(_Float16, _Float16)`), `f16abs`, `f16sqrt` (`_Float16(_Float16)`). GCC emits `fmax.h`/`fmin.h`/`fabs.h`/`fsqrt.h` on GPRs; upstream Zhinx has the same encodings (checked with llvm-mc `+zhinx`), and int-20 llc already selects them from `maxnum/fabs/sqrt.f16` with `+zhinx`. Implementation = batch A with f16 once `float16` maps to `_Float16` (features `"xpulpv,zhinx|zfh"`). Callers: `FloatDefines.h:74-76,99` (`Absf16`, `Maxf16`, `Minf16`, `Sqrtf16`), 9/6/0/1 files blocked.

### Batch E: float16alt and packed fp16 (blocked on B90 and on new instructions)

- E1 `f16altmax/min/abs/sqrt`: GAP9 alt-half (bfloat16 layout e8m7) in GPRs, encodings `fmax.ah 2cb55553`, `fmin.ah 2cb54553`, `fsgnjx.ah 24a56553`, `fsqrt.ah 5c055553` (funct3 101 marks "alt"). The fork's `fmax.ah` assembles to the Snitch/fp16 encoding, so the GAP9 variants must be new definitions.
- E2 `f16max2/min2/abs2`, `f16altmax2/min2/abs2`: `vfmax.h 8cb52533`, `vfmin.h 8ab52533`, `vfsgnjx.h 9ea52533`, `.ah` variants with funct3 001 (`8cb51533`, `8ab51533`, `9ea51533`), OP 0x33, GPR operands. Same encodings as the fork's `Xfvechalf`/`Xfvecalthalf` but with GPRs instead of FPRs.
- E3 conversions `v2hftov2hi(_u)`, `v2ohftov2hi(_u)`, `v2hitov2hf(_u)`, `v2hitov2ohf(_u)`, `v2hftov2ohf`, `v2ohftov2hf`: `vfcvt.{x,xu}.{h,ah}`, `vfcvt.{h,ah}.{x,xu}`, `vfcvt.ah.h`, `vfcvt.h.ah` (encodings in the table below). GVSoC rounds the float->int ones with the dynamic `frm`; GCC models them as truncation. Emit the instruction; do not add rounding-mode fixups.
- Callers: `FloatDefines.h:78-114` and the CNN fp16 headers (`MaxF16`, `Clipf16a`, ...); 14 files for `f16altmax` alone.

### Batch F: `CoreCount_m1` (XS)

`int()`; GAP9 GCC: `-mPE=N` -> constant N-1 (also in static initializers); no `-mPE` -> `CoreCount() - 1` at run time. Add to 20/F018 (same option, same folding code).

## 4. Per-builtin summary

Columns: batch; GCC prototype (exact GCC types); instruction GAP9 GCC emits; fork has the instruction; blocked on fp16; SDK files failing on it / C files calling it / call sites (survey).

| builtin | batch | GCC prototype | instruction | fork insn | fp16 | files fail/call/sites |
|---|---|---|---|---|---|---|
| `f32abs` | A | `float(float)` | fabs.s rd,rs1 | yes | no | 7/1/3 |
| `f32max` | A | `float(float, float)` | fmax.s rd,rs1,rs2 | yes | no | 15/8/88 |
| `f32min` | A | `float(float, float)` | fmin.s rd,rs1,rs2 | yes | no | 9/1/9 |
| `f32sqrt` | A | `float(float)` | fsqrt.s rd,rs1 | yes | no | 5/6/14 |
| `rdownsf2` | A | `int(float)` | fcvt.w.s rd,rs1,rdn | yes | no | 0/0/0 |
| `rintsf2` | A | `int(float)` | fcvt.w.s rd,rs1,rmm | yes | no | 2/2/32 |
| `rupsf2` | A | `int(float)` | fcvt.w.s rd,rs1,rup | yes | no | 0/0/0 |
| `add2div2` | B | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | pv.add.h.div2 rd,rs1,rs2 | NO | no | 1/1/5 |
| `add2div4` | B | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | pv.add.h.div4 | NO | no | 1/1/4 |
| `cplx_conj` | B | `__vector(2) short int(__vector(2) short int)` | pv.cplxconj.h rd,rs1 | NO | no | 1/1/10 |
| `cplxmuls2` | B | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | pv.cplxmul.h.r + pv.cplxmul.h.i | NO | no | 1/1/20 |
| `cplxmuls2div2` | B | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | pv.cplxmul.h.r.div2 + pv.cplxmul.h.i.div2 | NO | no | 1/1/8 |
| `cplxmuls2div4` | B | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | pv.cplxmul.h.r.div4 + pv.cplxmul.h.i.div4 | NO | no | 1/1/3 |
| `cplxmuls2div8` | B | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | pv.cplxmul.h.r.div8 + pv.cplxmul.h.i.div8 | NO | no | 0/0/0 |
| `sub2div2` | B | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | pv.sub.h.div2 | NO | no | 1/1/2 |
| `sub2div4` | B | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | pv.sub.h.div4 | NO | no | 0/0/0 |
| `sub2rotmj` | B | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | pv.subrotmj.h rd,rs1,rs2 | NO | no | 1/1/6 |
| `macfs` | C | `int(int, int, int)` | p.macs rdacc,rs1,rs2 (GCC output unassemblable) | yes | no | 0/0/0 |
| `macfsN` | C | `int(int, int, int, int)` | p.macsN rdacc,rs1,rs2,N | yes | no | 0/0/0 |
| `macfsRN` | C | `int(int, int, int, int, int)` | p.macsRN rdacc,rs1,rs2,N | yes | no | 0/0/0 |
| `macfu` | C | `int(int, int, int)` | p.macu rdacc,rs1,rs2 (GCC output unassemblable) | yes | no | 0/0/0 |
| `macfuN` | C | `int(int, int, int, int)` | p.macuN rdacc,rs1,rs2,N | yes | no | 0/0/0 |
| `macfuRN` | C | `int(int, int, int, int, int)` | p.macuRN rdacc,rs1,rs2,N | yes | no | 0/0/0 |
| `mul64hs` | C | `int(int, int)` | mulh rd,rs1,rs2 | yes | no | 0/0/0 |
| `mul64hu` | C | `int(int, int)` | mulhu rd,rs1,rs2 | yes | no | 1/0/4 |
| `mul64hus` | C | `int(int, int)` | mulhsu rd, rs1=y, rs2=x | yes | no | 0/0/0 |
| `mulfs` | C | `int(int, int)` | p.muls rd,rs1,rs2 | yes | no | 0/0/0 |
| `mulfsN` | C | `int(int, int, int)` | p.mulsN rd,rs1,rs2,N | yes | no | 1/1/11 |
| `mulfsRN` | C | `int(int, int, int, int)` | p.mulsRN rd,rs1,rs2,N | yes | no | 0/0/0 |
| `mulfu` | C | `int(int, int)` | p.mulu rd,rs1,rs2 | yes | no | 0/0/0 |
| `mulfuN` | C | `int(int, int, int)` | p.muluN rd,rs1,rs2,N | yes | no | 0/0/0 |
| `truncb` | C | `char(int)` | andi rd,rs1,0xff | yes | no | 0/0/0 |
| `trunch` | C | `short int(int)` | p.exths rd,rs1 | yes | no | 1/1/16 |
| `f16abs` | D | `float16(float16)` | fabs.h | yes | yes | 0/2/3 |
| `f16max` | D | `float16(float16, float16)` | fmax.h rd,rs1[,rs2] on GPRs | yes | yes | 8/13/256 |
| `f16min` | D | `float16(float16, float16)` | fmin.h rd,rs1[,rs2] on GPRs | yes | yes | 5/8/35 |
| `f16sqrt` | D | `float16(float16)` | fsqrt.h rd,rs1[,rs2] on GPRs | yes | yes | 1/1/2 |
| `f16altabs` | E1 | `float16alt(float16alt)` | fabs.ah = fsgnjx.ah | NO | yes | 0/2/3 |
| `f16altmax` | E1 | `float16alt(float16alt, float16alt)` | fmax.ah rd,rs1,rs2 | NO | yes | 14/12/253 |
| `f16altmin` | E1 | `float16alt(float16alt, float16alt)` | fmin.ah | NO | yes | 9/7/32 |
| `f16altsqrt` | E1 | `float16alt(float16alt)` | fsqrt.ah | NO | yes | 1/1/2 |
| `f16abs2` | E2 | `__vector(2) float16(__vector(2) float16)` | vfabs.h = vfsgnjx.h rd,rs1[,rs2] | NO | yes | 0/0/1 |
| `f16altabs2` | E2 | `__vector(2) float16alt(__vector(2) float16alt)` | vfabs.ah = vfsgnjx.ah | NO | yes | 0/0/1 |
| `f16altmax2` | E2 | `__vector(2) float16alt(__vector(2) float16alt, __vector(2) float16alt)` | vfmax.ah | NO | yes | 8/6/67 |
| `f16altmin2` | E2 | `__vector(2) float16alt(__vector(2) float16alt, __vector(2) float16alt)` | vfmin.ah | NO | yes | 3/1/21 |
| `f16max2` | E2 | `__vector(2) float16(__vector(2) float16, __vector(2) float16)` | vfmax.h rd,rs1[,rs2] | NO | yes | 6/7/74 |
| `f16min2` | E2 | `__vector(2) float16(__vector(2) float16, __vector(2) float16)` | vfmin.h rd,rs1[,rs2] | NO | yes | 3/2/28 |
| `v2hftov2hi` | E3 | `__vector(2) short int(__vector(2) float16)` | vfcvt.x.h rd,rs1 | NO | yes | 0/0/6 |
| `v2hftov2hi_u` | E3 | `__vector(2) short int(__vector(2) float16)` | vfcvt.xu.h rd,rs1 | NO | yes | 0/0/1 |
| `v2hftov2ohf` | E3 | `__vector(2) float16alt(__vector(2) float16)` | vfcvt.ah.h rd,rs1 | NO | yes | 1/1/9 |
| `v2hitov2hf` | E3 | `__vector(2) float16(__vector(2) short int)` | vfcvt.h.x rd,rs1 | NO | yes | 0/0/1 |
| `v2hitov2hf_u` | E3 | `__vector(2) float16(__vector(2) short int)` | vfcvt.h.xu rd,rs1 | NO | yes | 0/0/3 |
| `v2hitov2ohf` | E3 | `__vector(2) float16alt(__vector(2) short int)` | vfcvt.ah.x rd,rs1 | NO | yes | 0/0/0 |
| `v2hitov2ohf_u` | E3 | `__vector(2) float16alt(__vector(2) short int)` | vfcvt.ah.xu rd,rs1 | NO | yes | 0/0/0 |
| `v2ohftov2hf` | E3 | `__vector(2) float16(__vector(2) float16alt)` | vfcvt.h.ah rd,rs1 | NO | yes | 1/1/6 |
| `v2ohftov2hi` | E3 | `__vector(2) short int(__vector(2) float16alt)` | vfcvt.x.ah rd,rs1 | NO | yes | 0/0/0 |
| `v2ohftov2hi_u` | E3 | `__vector(2) short int(__vector(2) float16alt)` | vfcvt.xu.ah rd,rs1 | NO | yes | 0/0/0 |
| `CoreCount_m1` | F | `int()` | li rd,PE-1 | n/a | no | 0/0/0 |
| `add4div2` | X | `__vector(4) signed char(__vector(4) signed char, __vector(4) signed char)` | - | no | no | 0/0/0 |
| `add4div4` | X | `__vector(4) signed char(__vector(4) signed char, __vector(4) signed char)` | - | no | no | 0/0/0 |
| `cplxmjrot2` | X | `-` | - | no | no | 0/0/0 |
| `cplxmuls` | X | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | - | no | no | 0/1/20 |
| `cplxmulsdiv2` | X | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | - | no | no | 0/1/8 |
| `cplxmulsdiv4` | X | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | - | no | no | 0/1/3 |
| `sub4div2` | X | `__vector(4) signed char(__vector(4) signed char, __vector(4) signed char)` | - | no | no | 0/0/0 |
| `sub4div4` | X | `__vector(4) signed char(__vector(4) signed char, __vector(4) signed char)` | - | no | no | 0/0/0 |
| `vitmax2` | X | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | - | no | no | 0/0/0 |
| `vitsel2` | X | `__vector(2) short int(__vector(2) short int, __vector(2) short int)` | - | no | no | 0/0/0 |

Batch X details: GAP8 GCC emits `pv.add.b.div2/div4`, `pv.sub.b.div2/div4`, `pv.cplxmul.s(.div2/.div4)`, `pv.vitop.max/sel` for them (`gcc/<name>.s`, compiled with `-march=rv32imcxgap8`); none of these instructions is in GVSoC's GAP9 subset. The GCC prototype column shows the GAP8 prototype for these. The non-zero call-site counts of `cplxmuls*` come from the shared wrapper names `gap_cplxmuls*`, which expand to `cplxmuls2*` on GAP9.

## 5. Which files each batch unlocks (from the survey's `results.json`)

Files that compile with GCC, fail with int-20, and need at least one builtin from this spec (after 20/F016). "types" = float16/float16alt (B90), "gcc-only" = `CoreCount` in static initializers (F018) or `__builtin_shuffle` (F019), "argcheck" = our stricter mulsN/clip checks.

| needs | files | examples |
|---|---|---|
| A + types | 9 | fastmath/main.c, utils.c, decoding.c, RNN_BasicKernelsFScale_NE16.c, CmplxFunctionsf32.c, PiecewiseMathf32.c |
| A + types + gcc-only | 7 | CNN_Activation_SQ8.c, CNN_SoftMax_SQ8.c, CNN_*_fp32.c |
| E + types + gcc-only | 6 | CNN_Bias_Linear_Activation_fp16.c, CNN_MatAlgebra_f16a.c, ... |
| D + E + types + gcc-only | 3 | CNN_Pooling_SQ8.c, CNN_Bias_Linear_Activation_f16.c, CNN_MatAlgebra_f16.c |
| E + types | 3 | SSD_BasicKernels_f16a.c, SSD_BasicKernels_fp16.c, CmplxFunctionsf16a.c |
| E + types + argcheck + gcc-only | 2 | CNN_MatMul_Conv_f16a.c, CNN_MatMul_Conv_fp16.c |
| A + E + types + gcc-only | 2 | CNN_Pooling_BasicKernels_f16a.c, _fp16.c |
| D + types | 2 | SSD_BasicKernels_f16.c, CmplxFunctionsf16.c |
| **C only** | **1** | **libs/gap_lib/jpeg/dct.c** |
| C + types | 1 | MathFuncsFix.c |
| B + types | 1 | FftLibraryFix.c |
| other mixes (A/D/E + types + gcc-only/other) | 6 | CNN_Copy.c, PiecewiseMathf16(a).c, CNN_SoftMax_f16.c, ... |

## 6. GCC diagnostics and edge cases (probes in `gcc/diag/`)

| probe | GAP9 GCC | clang should |
|---|---|---|
| f32max_int | rc=0;  asm: fcvt.s.w a1,a1; fcvt.s.w a0,a0; fmax.s a0,a0,a1; ret | accept (implicit int->float conversion) |
| f32max_double | rc=0;  asm: add sp,sp,-16; sw ra,12(sp); sw s0,8(sp); sw s2,4(sp); sw s3,0(sp); mv s2,a2; mv s3,a3; ca | accept (double->float) |
| f32max_ptr | rc=1; error: incompatible type for argument 1 of '__builtin_pulp_f32max' / note: expected 'float' but argument is of type 'float *' / warning: control reach | error (incompatible type) |
| f32max_v2s | rc=1; error: incompatible type for argument 1 of '__builtin_pulp_f32max' / note: expected 'float' but argument is of type 'v2s {aka __vector(2) short int}'  | error |
| f32max_fold | rc=0;  asm: lui a5,%hi(.LC0); lw a0,%lo(.LC0)(a5); ret | fold is fine |
| f32min_nan | rc=0;  asm: lui a5,%hi(.LC0); lw a5,%lo(.LC0)(a5); fmin.s a0,a0,a5; ret | - |
| f32sqrt_int | rc=0;  asm: fcvt.s.w a0,a0; fsqrt.s a0,a0; ret | accept |
| f32sqrt_static_init | rc=1; error: initializer element is not constant | error (not a constant expression) - same |
| rintsf2_int | rc=0;  asm: fcvt.s.w a0,a0; fcvt.w.s a0,a0,rmm; ret | accept |
| rintsf2_double | rc=0;  asm: add sp,sp,-16; sw ra,12(sp); call __truncdfsf2; lw ra,12(sp); fcvt.w.s a0,a0,rmm; add sp,s | accept |
| add2div2_int | rc=1; error: incompatible type for argument 1 of '__builtin_pulp_add2div2' / note: expected '__vector(2) short int' but argument is of type 'int' / error: i | error |
| add2div2_v4s | rc=0;  asm: pv.add.h.div2  a0,a0,a1  # Add2>>1 Op Vect; ret | accept (lax integer vector conversion, clang default) |
| add2div2_const | rc=0;  asm: lui a5,%hi(.LC0); lw a0,%lo(.LC0)(a5); lui a5,%hi(.LC1); lw a5,%lo(.LC1)(a5); pv.add.h.div | - |
| cplxmuls2_int | rc=1; error: incompatible type for argument 1 of '__builtin_pulp_cplxmuls2' / note: expected '__vector(2) short int' but argument is of type 'int' / error:  | error |
| cplxmuls2_const | rc=0;  asm: lui a5,%hi(.LC0); lw a4,%lo(.LC0)(a5); lui a5,%hi(.LC1); lw a5,%lo(.LC1)(a5); pv.cplxmul.h | - |
| cplx_conj_v4s | rc=0;  asm: pv.cplxconj.h  a0,a0  # Complex conjugate; ret | accept |
| sub2rotmj_unsigned | rc=0;  asm: pv.subrotmj.h  a0,a0,a1; ret | accept |
| mulfsN_nonconst | rc=1; error: invalid argument to built-in function on arg 3, builtin arg mode: SI, actual arg mode: SI | error (argument must be a constant integer) as for mulsN |
| mulfsN_32 | rc=1; error: unrecognizable insn: / internal compiler error: in extract_insn, at recog.c:2311 | error: argument out of range 0..31 (GCC ICE) |
| mulfsN_neg | rc=1; error: unrecognizable insn: / internal compiler error: in extract_insn, at recog.c:2311 | error: out of range (GCC ICE) |
| mulfsN_0 | rc=0;  asm: p.mulsN  a0,a0,a1,0; ret | accept N=0 |
| mulsN_nonconst_existing | rc=1; error: invalid argument to built-in function on arg 3, builtin arg mode: SI, actual arg mode: SI | (existing builtin, same rule) |
| mulfsRN_badround | rc=0;  asm: p.mulsRN  a0,a0,a1,4; ret | error, as existing mulsRN (GCC silently ignores R) |
| mulfsRN_nonconst_round | rc=1; error: invalid argument to built-in function on arg 4, builtin arg mode: SI, actual arg mode: SI | error |
| mulfsRN_nonconst_both | rc=1; error: invalid argument to built-in function on arg 3, builtin arg mode: SI, actual arg mode: SI / error: invalid argument to built-in function on arg | error |
| macfsN_nonconst | rc=1; error: invalid argument to built-in function on arg 4, builtin arg mode: SI, actual arg mode: SI | error |
| macfuRN_nonconst | rc=1; error: invalid argument to built-in function on arg 4, builtin arg mode: SI, actual arg mode: SI / error: invalid argument to built-in function on arg | error |
| macfs_asm | rc=0;  asm: p.macs  a0,a0,a1,a2; ret | emit p.macs rdacc,rs1,rs2 (GCC output does not assemble) |
| mul64hu_ptr | rc=0; warning: passing argument 1 of '__builtin_pulp_mul64hu' makes integer from pointer without a cast [-Wint-conversion] / note: expected 'int' but argume asm: p.mulhu a0,a0,a1; ret | warning -Wint-conversion (clang: error by default in C99+ unless -Wno-error=int-conversion; survey step 5) |
| mul64hu_ll | rc=0;  asm: p.mulhu a0,a0,a2; ret | accept (truncate) |
| trunch_ll | rc=0;  asm: p.exths a0,a0; ret | accept |
| trunch_ptr | rc=0; warning: passing argument 1 of '__builtin_pulp_trunch' makes integer from pointer without a cast [-Wint-conversion] / note: expected 'int' but argumen asm: p.exths a0,a0; ret | warning int-conversion (see above) |
| truncb_sign | rc=0;  asm: and a0,a0,0xff; ret | andi 0xff (unsigned char) |
| f16max_float | rc=0;  asm: fcvt.h.s a1,a1; fcvt.h.s a0,a0; fmax.h a0,a0,a1; ret | accept (float->_Float16), after B90 |
| f16altmax_f16 | rc=0;  asm: fcvt.ah.h a1,a1; fcvt.ah.h a0,a0; fmax.ah a0,a0,a1; ret | accept (float16->float16alt conversion), after B90 |
| f16max2_v2ah | rc=0;  asm: vfmax.h  a0,a0,a1  # FVect Op FVect; ret | GCC accepts silently; clang will reject v2ah->v2h (float vectors are not lax-converted) - acceptable, no SDK use |
| v2hftov2ohf_v2s | rc=0;  asm: vfcvt.ah.h a0,a0; ret | GCC accepts; clang rejects int->float vector - acceptable |
| v2hitov2hf_v2h | rc=0;  asm: vfcvt.h.x a0,a0 # f16 Vect to short int vect; ret | GCC accepts; clang rejects - acceptable |
| CoreCount_m1_arg | rc=1; error: too many arguments to function '__builtin_pulp_CoreCount_m1' | error: too many arguments |

## 7. Instruction encodings (GAP9 gas) and int-20 status

`gcc/encodings.json` has, for every instruction line in `gcc/*.s`: the GAP9 gas encoding, what int-20 llvm-mc makes of the same text under three attribute sets, and what int-20 disassembles from the GCC encoding. Summary:

- identical encoding in int-20 today: `fmax.s fmin.s fabs.s fsqrt.s fcvt.w.s(rmm/rdn/rup) fmul.s` and `fmax.h fmin.h fabs.h fsqrt.h` (with `+zfinx,+zhinx`); `p.exths p.muls p.mulu p.mulsN p.mulsRN p.muluN p.macsN p.macsRN p.macuN p.macuRN` (with `+xpulpv`); `mulh mulhu mulhsu` (GCC's `p.mulh*` spelling is not accepted by llvm-mc, the encodings are the M ones).
- missing in int-20 (unknown mnemonic and invalid encoding): all `pv.add.h.divN`, `pv.sub.h.divN`, `pv.subrotmj.h`, `pv.cplxconj.h`, `pv.cplxmul.h.{r,i}[.divN]`; the GAP8 `pv.add/sub.b.divN`, `pv.cplxmul.s*`, `pv.vitop.*`; all `.ah` scalar ops in GAP9 encoding; all GPR `vf*` smallfloat ops.

## 8. Reproducing

- GCC tests: `cd gcc && riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S <name>.c` (GAP8-only ones: `-march=rv32imcxgap8`; the command is in each file's header comment).
- Scripts (take a work directory argument holding `todo.txt`, a copy of `gcc/todo.txt`): `gcc/probe2.py <dir> <march> <out.json>` (prototypes), `gcc/gen.py <dir>` (writes the tests and assembles them), `gcc/enc.py <dir>` (needs `<dir>/insns.txt`, the distinct instruction lines of `gcc/*.s`), `gcc/diag.py` (diagnostic probes).

