//===-- RISCVInstrInfoXsmallfloat.td - RISC-V smallfloat instructions ---*- tablegen -*-===//
//
// Copyright 2021 ETH Zurich, University of Bologna.
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Formats
//===----------------------------------------------------------------------===//

// vector float format
class RISCVVFFormat<bits<2> val> {
  bits<2> Value = val;
}
def VFMT_FP32     : RISCVVFFormat<0b00>;
def VFMT_FP16ALT  : RISCVVFFormat<0b01>;
def VFMT_FP16     : RISCVVFFormat<0b10>;
def VFMT_FP8      : RISCVVFFormat<0b11>;

//===----------------------------------------------------------------------===//
// Instruction formats
//===----------------------------------------------------------------------===//

class RVInstRVf<bits<2> funct2, bits<5> vecfltop, bits<1> r, RISCVVFFormat vfmt, RISCVOpcode opcode, dag outs, dag ins,
                 string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> rd;

  let Inst{31-30} = funct2;
  let Inst{29-25} = vecfltop;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14} = r;
  let Inst{13-12} = vfmt.Value;
  let Inst{11-7} = rd;
  let Inst{6-0} = opcode.Value;
}

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

include "RISCVInstrInfoXsmallfloatGen.td"

//===----------------------------------------------------------------------===//
// Assembler Pseudo Instructions
//===----------------------------------------------------------------------===//

// load/stores with zero offset
let Predicates = [HasExtXfalthalf] in {
def : InstAlias<"flah $rd, (${rs1})",  (FLH FPR16:$rd,  GPR:$rs1, 0), 0>;
def : InstAlias<"fsah $rs2, (${rs1})", (FSH FPR16:$rs2, GPR:$rs1, 0), 0>;
}
let Predicates = [HasExtXfquarter] in {
def : InstAlias<"flb $rd, (${rs1})",  (FLB FPR16:$rd,  GPR:$rs1, 0), 0>;
def : InstAlias<"fsb $rs2, (${rs1})", (FSB FPR16:$rs2, GPR:$rs1, 0), 0>;
}
let Predicates = [HasExtXfaltquarter] in {
def : InstAlias<"flab $rd, (${rs1})",  (FLB FPR16:$rd,  GPR:$rs1, 0), 0>;
def : InstAlias<"fsab $rs2, (${rs1})", (FSB FPR16:$rs2, GPR:$rs1, 0), 0>;
}

// fmv, fabs, fneg
// (the Xfalthalf ones are defined with the real fp16alt encodings in this
// file's scalar codegen section below)
let Predicates = [HasExtXfquarter] in {
def : InstAlias<"fmv.b $rd, $rs",  (FSGNJ_B  FPR16:$rd, FPR16:$rs, FPR16:$rs)>;
def : InstAlias<"fabs.b $rd, $rs", (FSGNJX_B FPR16:$rd, FPR16:$rs, FPR16:$rs)>;
def : InstAlias<"fneg.b $rd, $rs", (FSGNJN_B FPR16:$rd, FPR16:$rs, FPR16:$rs)>;
}
let Predicates = [HasExtXfaltquarter] in {
def : InstAlias<"fmv.ab $rd, $rs",  (FSGNJ_B  FPR16:$rd, FPR16:$rs, FPR16:$rs)>;
def : InstAlias<"fabs.ab $rd, $rs", (FSGNJX_B FPR16:$rd, FPR16:$rs, FPR16:$rs)>;
def : InstAlias<"fneg.ab $rd, $rs", (FSGNJN_B FPR16:$rd, FPR16:$rs, FPR16:$rs)>;
}

// pack
let Predicates = [HasExtXfvecsingle] in {
def : InstAlias<"vfcpk.s.s.0 $rd, $rs1, $rs2", (VFCPKA_S_S FPR32:$rd, FPR32:$rs1, FPR32:$rs2)>;
def : InstAlias<"vfcpk.s.d.0 $rd, $rs1, $rs2", (VFCPKA_S_D FPR32:$rd, FPR64:$rs1, FPR64:$rs2)>;
}
let Predicates = [HasExtXfvechalf] in {
def : InstAlias<"vfcpk.h.s.0 $rd, $rs1, $rs2", (VFCPKA_H_S FPR16:$rd, FPR32:$rs1, FPR32:$rs2)>;
def : InstAlias<"vfcpk.h.s.1 $rd, $rs1, $rs2", (VFCPKB_H_S FPR16:$rd, FPR32:$rs1, FPR32:$rs2)>;
def : InstAlias<"vfcpk.h.d.0 $rd, $rs1, $rs2", (VFCPKA_H_D FPR16:$rd, FPR64:$rs1, FPR64:$rs2)>;
def : InstAlias<"vfcpk.h.d.1 $rd, $rs1, $rs2", (VFCPKB_H_D FPR16:$rd, FPR64:$rs1, FPR64:$rs2)>;
}
let Predicates = [HasExtXfvecalthalf] in {
def : InstAlias<"vfcpk.ah.s.0 $rd, $rs1, $rs2", (VFCPKA_H_S FPR16:$rd, FPR32:$rs1, FPR32:$rs2)>;
def : InstAlias<"vfcpk.ah.s.1 $rd, $rs1, $rs2", (VFCPKB_H_S FPR16:$rd, FPR32:$rs1, FPR32:$rs2)>;
def : InstAlias<"vfcpk.ah.d.0 $rd, $rs1, $rs2", (VFCPKA_H_D FPR16:$rd, FPR64:$rs1, FPR64:$rs2)>;
def : InstAlias<"vfcpk.ah.d.1 $rd, $rs1, $rs2", (VFCPKB_H_D FPR16:$rd, FPR64:$rs1, FPR64:$rs2)>;
}
let Predicates = [HasExtXfvecquarter] in {
def : InstAlias<"vfcpk.b.s.0 $rd, $rs1, $rs2", (VFCPKA_B_S FPR16:$rd, FPR32:$rs1, FPR32:$rs2)>;
def : InstAlias<"vfcpk.b.s.1 $rd, $rs1, $rs2", (VFCPKB_B_S FPR16:$rd, FPR32:$rs1, FPR32:$rs2)>;
def : InstAlias<"vfcpk.b.s.2 $rd, $rs1, $rs2", (VFCPKC_B_S FPR16:$rd, FPR32:$rs1, FPR32:$rs2)>;
def : InstAlias<"vfcpk.b.s.3 $rd, $rs1, $rs2", (VFCPKD_B_S FPR16:$rd, FPR32:$rs1, FPR32:$rs2)>;
def : InstAlias<"vfcpk.b.d.0 $rd, $rs1, $rs2", (VFCPKA_B_D FPR16:$rd, FPR64:$rs1, FPR64:$rs2)>;
def : InstAlias<"vfcpk.b.d.1 $rd, $rs1, $rs2", (VFCPKB_B_D FPR16:$rd, FPR64:$rs1, FPR64:$rs2)>;
def : InstAlias<"vfcpk.b.d.2 $rd, $rs1, $rs2", (VFCPKC_B_D FPR16:$rd, FPR64:$rs1, FPR64:$rs2)>;
def : InstAlias<"vfcpk.b.d.3 $rd, $rs1, $rs2", (VFCPKD_B_D FPR16:$rd, FPR64:$rs1, FPR64:$rs2)>;
}

//===----------------------------------------------------------------------===//
// Codegen patterns
//
// GAP9-style cores keep floats in GPRs (Zfinx/Zhinx), so v2f16/v2bf16 values
// live in the PulpV2F register class and scalars in GPRF16.
//===----------------------------------------------------------------------===//

multiclass PulpVFVecArithPats<ValueType VT, string Sfx> {
  def : Pat<(VT (fadd (VT PulpV2F:$rs1), (VT PulpV2F:$rs2))),
            (!cast<Instruction>("VFADD"#Sfx) PulpV2F:$rs1, PulpV2F:$rs2)>;
  def : Pat<(VT (fsub (VT PulpV2F:$rs1), (VT PulpV2F:$rs2))),
            (!cast<Instruction>("VFSUB"#Sfx) PulpV2F:$rs1, PulpV2F:$rs2)>;
  def : Pat<(VT (fmul (VT PulpV2F:$rs1), (VT PulpV2F:$rs2))),
            (!cast<Instruction>("VFMUL"#Sfx) PulpV2F:$rs1, PulpV2F:$rs2)>;
  def : Pat<(VT (fminnum (VT PulpV2F:$rs1), (VT PulpV2F:$rs2))),
            (!cast<Instruction>("VFMIN"#Sfx) PulpV2F:$rs1, PulpV2F:$rs2)>;
  def : Pat<(VT (fmaxnum (VT PulpV2F:$rs1), (VT PulpV2F:$rs2))),
            (!cast<Instruction>("VFMAX"#Sfx) PulpV2F:$rs1, PulpV2F:$rs2)>;
  // vfmac accumulates into rd: rd += rs1 * rs2.
  def : Pat<(VT (fma (VT PulpV2F:$rs1), (VT PulpV2F:$rs2), (VT PulpV2F:$rd))),
            (!cast<Instruction>("VFMAC"#Sfx) PulpV2F:$rd, PulpV2F:$rs1, PulpV2F:$rs2)>;
  def : Pat<(VT (fneg (VT PulpV2F:$rs1))),
            (!cast<Instruction>("VFSGNJN"#Sfx) PulpV2F:$rs1, PulpV2F:$rs1)>;
  def : Pat<(VT (fabs (VT PulpV2F:$rs1))),
            (!cast<Instruction>("VFSGNJX"#Sfx) PulpV2F:$rs1, PulpV2F:$rs1)>;
  def : Pat<(VT (fcopysign (VT PulpV2F:$rs1), (VT PulpV2F:$rs2))),
            (!cast<Instruction>("VFSGNJ"#Sfx) PulpV2F:$rs1, PulpV2F:$rs2)>;
  // fma with negated product: -(rs1 * rs2) + rd  ->  vfmre (multiply-reduce).
  def : Pat<(VT (fma (fneg (VT PulpV2F:$rs1)), (VT PulpV2F:$rs2), (VT PulpV2F:$rd))),
            (!cast<Instruction>("VFMRE"#Sfx) PulpV2F:$rd, PulpV2F:$rs1, PulpV2F:$rs2)>;
}

let Predicates = [HasExtXfvechalf] in
defm : PulpVFVecArithPats<v2f16, "_H">;
let Predicates = [HasExtXfvecalthalf] in
defm : PulpVFVecArithPats<v2bf16, "_AH">;

// Bitcasts are free: everything lives in GPRs.
multiclass PulpVFVecBitcastPats<ValueType VT> {
  def : Pat<(VT (bitconvert (i32 GPR:$rs1))), (VT (COPY_TO_REGCLASS GPR:$rs1, PulpV2F))>;
  def : Pat<(i32 (bitconvert (VT PulpV2F:$rs1))), (i32 (COPY_TO_REGCLASS PulpV2F:$rs1, GPR))>;
  def : Pat<(VT (bitconvert (v2i16 PulpV2:$rs1))), (VT (COPY_TO_REGCLASS PulpV2:$rs1, PulpV2F))>;
  def : Pat<(v2i16 (bitconvert (VT PulpV2F:$rs1))), (v2i16 (COPY_TO_REGCLASS PulpV2F:$rs1, PulpV2))>;
  def : Pat<(VT (bitconvert (v4i8 PulpV4:$rs1))), (VT (COPY_TO_REGCLASS PulpV4:$rs1, PulpV2F))>;
  def : Pat<(v4i8 (bitconvert (VT PulpV2F:$rs1))), (v4i8 (COPY_TO_REGCLASS PulpV2F:$rs1, PulpV4))>;
  def : Pat<(VT (bitconvert (f32 FPR32INX:$rs1))), (VT (COPY_TO_REGCLASS FPR32INX:$rs1, PulpV2F))>;
  def : Pat<(f32 (bitconvert (VT PulpV2F:$rs1))), (f32 (COPY_TO_REGCLASS PulpV2F:$rs1, GPRF32))>;
}

let Predicates = [HasExtXfvechalf, HasPULPExtV2] in
defm : PulpVFVecBitcastPats<v2f16>;
let Predicates = [HasExtXfvecalthalf, HasPULPExtV2] in
defm : PulpVFVecBitcastPats<v2bf16>;

let Predicates = [HasExtXfvechalf, HasExtXfvecalthalf] in {
def : Pat<(v2f16 (bitconvert (v2bf16 PulpV2F:$rs1))), (v2f16 PulpV2F:$rs1)>;
def : Pat<(v2bf16 (bitconvert (v2f16 PulpV2F:$rs1))), (v2bf16 PulpV2F:$rs1)>;
}

// Element insertion/extraction and splats reuse the Xpulpv2 integer
// pack/shuffle instructions (this is what GAP GCC emits as well).
let Predicates = [HasExtXfvechalf, HasPULPExtV2, HasStdExtZhinxmin] in {
def : Pat<(v2f16 (build_vector (f16 FPR16INX:$rs1), (f16 FPR16INX:$rs2))),
          (COPY_TO_REGCLASS (PV_PACK_H (COPY_TO_REGCLASS FPR16INX:$rs2, GPR),
                                       (COPY_TO_REGCLASS FPR16INX:$rs1, GPR)),
                            PulpV2F)>;
def : Pat<(v2f16 (splat_vector (f16 FPR16INX:$rs1))),
          (COPY_TO_REGCLASS (PV_PACK_H (COPY_TO_REGCLASS FPR16INX:$rs1, GPR),
                                       (COPY_TO_REGCLASS FPR16INX:$rs1, GPR)),
                            PulpV2F)>;
// Element 0 is the low half; Zhinx scalar ops only read the low 16 bits.
def : Pat<(f16 (vector_extract (v2f16 PulpV2F:$rs1), 0)),
          (COPY_TO_REGCLASS PulpV2F:$rs1, GPRF16)>;
def : Pat<(f16 (vector_extract (v2f16 PulpV2F:$rs1), 1)),
          (COPY_TO_REGCLASS (SRLI (COPY_TO_REGCLASS PulpV2F:$rs1, GPR), 16), GPRF16)>;
def : Pat<(f16 (vector_extract (v2f16 PulpV2F:$rs1), (i32 GPR:$idx))),
          (COPY_TO_REGCLASS (PV_SHUFFLE_H_GPR (COPY_TO_REGCLASS PulpV2F:$rs1, PulpV2),
                                              (i32 GPR:$idx)),
                            GPRF16)>;
}


//===----------------------------------------------------------------------===//
// Scalar fp16alt (bf16) instructions and codegen - Xfalthalf
//
// Only the Zfinx/Zhinx-style flavor (floats in GPRs, as on GAP9) is
// implemented for codegen. The fp16alt scalar operations reuse the fp16
// encodings with a modified funct3/rm field (verified against GAP GCC):
//   - computational ops (fadd/fsub/fmul/fdiv, fmadd/...):   funct3/rm = 0b101
//   - sign-injection, min/max, comparisons:                 funct3 | 0b100
//   - conversions with an ah destination:                   rm  = 0b101
//   - conversions with an ah source:                        rs2 = 0b00110
// There is no fsqrt.ah; sqrt (and rounding-mode dependent ops) are promoted
// to f32 by the lowering.
//===----------------------------------------------------------------------===//

def FPRAH16INX : RegisterOperand<GPRBF16> {
  let ParserMatchClass = GPRAsFPR;
  let DecoderMethod = "DecodeGPRRegisterClass";
}

// R4-type with a statically encoded funct3 (no dynamic rounding mode).
let hasSideEffects = 0, mayLoad = 0, mayStore = 0, mayRaiseFPException = 1 in
class FPFMAAH_rrr<RISCVOpcode opcode, string opcodestr, DAGOperand rty>
    : RVInstR4<0b10, 0b101, opcode, (outs rty:$rd),
               (ins rty:$rs1, rty:$rs2, rty:$rs3),
               opcodestr, "$rd, $rs1, $rs2, $rs3">;

let Predicates = [HasExtXfalthalf], DecoderNamespace = "Xfalthalf" in {
def FMADD_AH_INX  : FPFMAAH_rrr<OPC_MADD,  "fmadd.ah",  FPRAH16INX>;
def FMSUB_AH_INX  : FPFMAAH_rrr<OPC_MSUB,  "fmsub.ah",  FPRAH16INX>;
def FNMSUB_AH_INX : FPFMAAH_rrr<OPC_NMSUB, "fnmsub.ah", FPRAH16INX>;
def FNMADD_AH_INX : FPFMAAH_rrr<OPC_NMADD, "fnmadd.ah", FPRAH16INX>;

def FADD_AH_INX : FPALU_rr<0b0000010, 0b101, "fadd.ah", FPRAH16INX, Commutable=1>;
def FSUB_AH_INX : FPALU_rr<0b0000110, 0b101, "fsub.ah", FPRAH16INX, Commutable=0>;
def FMUL_AH_INX : FPALU_rr<0b0001010, 0b101, "fmul.ah", FPRAH16INX, Commutable=1>;
def FDIV_AH_INX : FPALU_rr<0b0001110, 0b101, "fdiv.ah", FPRAH16INX, Commutable=0>;

def FSGNJ_AH_INX  : FPALU_rr<0b0010010, 0b100, "fsgnj.ah",  FPRAH16INX, Commutable=0>;
def FSGNJN_AH_INX : FPALU_rr<0b0010010, 0b101, "fsgnjn.ah", FPRAH16INX, Commutable=0>;
def FSGNJX_AH_INX : FPALU_rr<0b0010010, 0b110, "fsgnjx.ah", FPRAH16INX, Commutable=0>;

def FMIN_AH_INX : FPALU_rr<0b0010110, 0b100, "fmin.ah", FPRAH16INX, Commutable=1>;
def FMAX_AH_INX : FPALU_rr<0b0010110, 0b101, "fmax.ah", FPRAH16INX, Commutable=1>;

def FEQ_AH_INX : FPCmp_rr<0b1010010, 0b110, "feq.ah", FPRAH16INX, Commutable=1>;
def FLT_AH_INX : FPCmp_rr<0b1010010, 0b101, "flt.ah", FPRAH16INX>;
def FLE_AH_INX : FPCmp_rr<0b1010010, 0b100, "fle.ah", FPRAH16INX>;

def FCVT_AH_S_INX : FPUnaryOp_r<0b0100010, 0b00000, 0b101, FPRAH16INX, FPR32INX,
                                "fcvt.ah.s">;
def FCVT_S_AH_INX : FPUnaryOp_r<0b0100000, 0b00110, 0b000, FPR32INX, FPRAH16INX,
                                "fcvt.s.ah">;

def FCVT_W_AH_INX  : FPUnaryOp_r<0b1100010, 0b00000, 0b101, GPR, FPRAH16INX,
                                 "fcvt.w.ah">;
def FCVT_WU_AH_INX : FPUnaryOp_r<0b1100010, 0b00001, 0b101, GPR, FPRAH16INX,
                                 "fcvt.wu.ah">;
def FCVT_AH_W_INX  : FPUnaryOp_r<0b1101010, 0b00000, 0b101, FPRAH16INX, GPR,
                                 "fcvt.ah.w">;
def FCVT_AH_WU_INX : FPUnaryOp_r<0b1101010, 0b00001, 0b101, FPRAH16INX, GPR,
                                 "fcvt.ah.wu">;
} // Predicates = [HasExtXfalthalf], DecoderNamespace = "Xfalthalf"

let Predicates = [HasExtXfalthalf] in {
def : InstAlias<"fmv.ah $rd, $rs",  (FSGNJ_AH_INX  FPRAH16INX:$rd, FPRAH16INX:$rs, FPRAH16INX:$rs)>;
def : InstAlias<"fabs.ah $rd, $rs", (FSGNJX_AH_INX FPRAH16INX:$rd, FPRAH16INX:$rs, FPRAH16INX:$rs)>;
def : InstAlias<"fneg.ah $rd, $rs", (FSGNJN_AH_INX FPRAH16INX:$rd, FPRAH16INX:$rs, FPRAH16INX:$rs)>;

defm Select_FPRAH16INX : SelectCC_GPR_rrirr<FPRAH16INX, bf16>;

/// Arithmetic

def : Pat<(bf16 (any_fadd FPRAH16INX:$rs1, FPRAH16INX:$rs2)),
          (FADD_AH_INX $rs1, $rs2)>;
def : Pat<(bf16 (any_fsub FPRAH16INX:$rs1, FPRAH16INX:$rs2)),
          (FSUB_AH_INX $rs1, $rs2)>;
def : Pat<(bf16 (any_fmul FPRAH16INX:$rs1, FPRAH16INX:$rs2)),
          (FMUL_AH_INX $rs1, $rs2)>;
def : Pat<(bf16 (any_fdiv FPRAH16INX:$rs1, FPRAH16INX:$rs2)),
          (FDIV_AH_INX $rs1, $rs2)>;

def : Pat<(bf16 (fneg FPRAH16INX:$rs1)), (FSGNJN_AH_INX $rs1, $rs1)>;
def : Pat<(bf16 (fabs FPRAH16INX:$rs1)), (FSGNJX_AH_INX $rs1, $rs1)>;

def : PatFprFpr<fcopysign, FSGNJ_AH_INX, FPRAH16INX, bf16>;
def : Pat<(bf16 (fcopysign FPRAH16INX:$rs1, (bf16 (fneg FPRAH16INX:$rs2)))),
          (FSGNJN_AH_INX $rs1, $rs2)>;

// fmadd: rs1 * rs2 + rs3
def : Pat<(bf16 (any_fma FPRAH16INX:$rs1, FPRAH16INX:$rs2, FPRAH16INX:$rs3)),
          (FMADD_AH_INX $rs1, $rs2, $rs3)>;
// fmsub: rs1 * rs2 - rs3
def : Pat<(bf16 (any_fma FPRAH16INX:$rs1, FPRAH16INX:$rs2, (fneg FPRAH16INX:$rs3))),
          (FMSUB_AH_INX $rs1, $rs2, $rs3)>;
// fnmsub: -rs1 * rs2 + rs3
def : Pat<(bf16 (any_fma (fneg FPRAH16INX:$rs1), FPRAH16INX:$rs2, FPRAH16INX:$rs3)),
          (FNMSUB_AH_INX $rs1, $rs2, $rs3)>;
// fnmadd: -rs1 * rs2 - rs3
def : Pat<(bf16 (any_fma (fneg FPRAH16INX:$rs1), FPRAH16INX:$rs2, (fneg FPRAH16INX:$rs3))),
          (FNMADD_AH_INX $rs1, $rs2, $rs3)>;
// fnmadd: -(rs1 * rs2 + rs3) (the nsz flag on the FMA)
def : Pat<(bf16 (fneg (any_fma_nsz FPRAH16INX:$rs1, FPRAH16INX:$rs2, FPRAH16INX:$rs3))),
          (FNMADD_AH_INX $rs1, $rs2, $rs3)>;

def : PatFprFpr<fminnum, FMIN_AH_INX, FPRAH16INX, bf16>;
def : PatFprFpr<fmaxnum, FMAX_AH_INX, FPRAH16INX, bf16>;
def : PatFprFpr<riscv_fmin, FMIN_AH_INX, FPRAH16INX, bf16>;
def : PatFprFpr<riscv_fmax, FMAX_AH_INX, FPRAH16INX, bf16>;

/// Setcc

def : PatSetCC<FPRAH16INX, any_fsetcc,  SETEQ,  FEQ_AH_INX, bf16>;
def : PatSetCC<FPRAH16INX, any_fsetcc,  SETOEQ, FEQ_AH_INX, bf16>;
def : PatSetCC<FPRAH16INX, any_fsetccs, SETLT,  FLT_AH_INX, bf16>;
def : PatSetCC<FPRAH16INX, any_fsetccs, SETOLT, FLT_AH_INX, bf16>;
def : PatSetCC<FPRAH16INX, any_fsetccs, SETLE,  FLE_AH_INX, bf16>;
def : PatSetCC<FPRAH16INX, any_fsetccs, SETOLE, FLE_AH_INX, bf16>;

/// Loads/stores (bf16 lives in the low 16 bits of a GPR)

def : Pat<(bf16 (load (AddrRegImm (XLenVT GPR:$rs1), simm12:$imm12))),
          (COPY_TO_REGCLASS (LH GPR:$rs1, simm12:$imm12), GPRBF16)>;
def : Pat<(store (bf16 FPRAH16INX:$rs2),
                 (AddrRegImm (XLenVT GPR:$rs1), simm12:$imm12)),
          (SH (COPY_TO_REGCLASS FPRAH16INX:$rs2, GPR), GPR:$rs1, simm12:$imm12)>;

/// Moves (no conversion)

def : Pat<(bf16 (riscv_fmv_h_x GPR:$src)), (COPY_TO_REGCLASS GPR:$src, GPRBF16)>;
def : Pat<(riscv_fmv_x_anyexth (bf16 FPRAH16INX:$src)),
          (COPY_TO_REGCLASS FPRAH16INX:$src, GPR)>;
def : Pat<(riscv_fmv_x_signexth (bf16 FPRAH16INX:$src)),
          (COPY_TO_REGCLASS FPRAH16INX:$src, GPR)>;

/// Conversions f32 <-> bf16

def : Pat<(bf16 (any_fpround FPR32INX:$rs1)), (FCVT_AH_S_INX FPR32INX:$rs1)>;
def : Pat<(f32 (any_fpextend (bf16 FPRAH16INX:$rs1))),
          (FCVT_S_AH_INX FPRAH16INX:$rs1)>;

def : Pat<(f32 (fcopysign FPR32INX:$rs1, (bf16 FPRAH16INX:$rs2))),
          (FSGNJ_S_INX $rs1, (FCVT_S_AH_INX $rs2))>;
def : Pat<(bf16 (fcopysign FPRAH16INX:$rs1, FPR32INX:$rs2)),
          (FSGNJ_AH_INX $rs1, (FCVT_AH_S_INX $rs2))>;
} // Predicates = [HasExtXfalthalf]

let Predicates = [HasExtXfalthalf, IsRV32] in {
// bf16 -> [u]int32 (the fixed 0b101 rm field encodes the alternate format;
// the conversion itself truncates like GCC's fcvt.w.ah)
def : Pat<(i32 (any_fp_to_sint (bf16 FPRAH16INX:$rs1))), (FCVT_W_AH_INX $rs1)>;
def : Pat<(i32 (any_fp_to_uint (bf16 FPRAH16INX:$rs1))), (FCVT_WU_AH_INX $rs1)>;

// [u]int32 -> bf16
def : Pat<(bf16 (any_sint_to_fp (i32 GPR:$rs1))), (FCVT_AH_W_INX GPR:$rs1)>;
def : Pat<(bf16 (any_uint_to_fp (i32 GPR:$rs1))), (FCVT_AH_WU_INX GPR:$rs1)>;
} // Predicates = [HasExtXfalthalf, IsRV32]

// Post-increment stores (loads are handled in RISCVISelDAGToDAG).
let Predicates = [HasExtXfalthalf, IsRV32, HasPULPExtV2] in {
def : Pat<(post_store (bf16 FPRAH16INX:$val), (i32 GPR:$base), simm12:$offset),
    (P_SH_ri_PostIncrement (COPY_TO_REGCLASS FPRAH16INX:$val, GPR),
                           (i32 GPR:$base), simm12:$offset)>;
def : Pat<(post_store (bf16 FPRAH16INX:$val), (i32 GPR:$base), (i32 GPR:$offset)),
    (P_SH_rr_PostIncrement (COPY_TO_REGCLASS FPRAH16INX:$val, GPR),
                           (i32 GPR:$base), (i32 GPR:$offset))>;
}

// v2bf16 element insertion/extraction and splats (mirrors the v2f16 ones).
let Predicates = [HasExtXfvecalthalf, HasPULPExtV2, HasExtXfalthalf] in {
def : Pat<(v2bf16 (build_vector (bf16 FPRAH16INX:$rs1), (bf16 FPRAH16INX:$rs2))),
          (COPY_TO_REGCLASS (PV_PACK_H (COPY_TO_REGCLASS FPRAH16INX:$rs2, GPR),
                                       (COPY_TO_REGCLASS FPRAH16INX:$rs1, GPR)),
                            PulpV2F)>;
def : Pat<(v2bf16 (splat_vector (bf16 FPRAH16INX:$rs1))),
          (COPY_TO_REGCLASS (PV_PACK_H (COPY_TO_REGCLASS FPRAH16INX:$rs1, GPR),
                                       (COPY_TO_REGCLASS FPRAH16INX:$rs1, GPR)),
                            PulpV2F)>;
// Element 0 is the low half; fp16alt scalar ops only read the low 16 bits.
def : Pat<(bf16 (vector_extract (v2bf16 PulpV2F:$rs1), 0)),
          (COPY_TO_REGCLASS PulpV2F:$rs1, GPRBF16)>;
def : Pat<(bf16 (vector_extract (v2bf16 PulpV2F:$rs1), 1)),
          (COPY_TO_REGCLASS (SRLI (COPY_TO_REGCLASS PulpV2F:$rs1, GPR), 16), GPRBF16)>;
def : Pat<(bf16 (vector_extract (v2bf16 PulpV2F:$rs1), (i32 GPR:$idx))),
          (COPY_TO_REGCLASS (PV_SHUFFLE_H_GPR (COPY_TO_REGCLASS PulpV2F:$rs1, PulpV2),
                                              (i32 GPR:$idx)),
                            GPRBF16)>;
}

