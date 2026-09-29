//===-- RISCVInstrInfoXpulpfloat.td - GAP9 half-precision --*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// GAP9 half-precision float instructions that are not standard Zhinx, with
// their operands in the integer registers (Zfinx style):
//
//  - Xpulpf16alt: scalar bfloat16 ("float16alt", suffix .ah). Each op is
//    the Zfh .h instruction with the rounding-mode field (funct3) fixed to
//    0b101 (ALTF) for ops that round, and the .h funct3 with bit 2 set
//    (0b1xx) for ops that do not (sign injection, min/max, compares,
//    fclass). The .ah ops always round to nearest-even; they have no rm
//    operand. fcvt.h.ah is the one exception: its funct3 is a real rm.
//  - Xpulpfvec: packed 2 x binary16 (.h) and 2 x bfloat16 (.ah) in one GPR,
//    opcode OP, funct7 = 0b10 ++ op, funct3 = r ++ vfmt with vfmt 0b10 (.h)
//    or 0b01 (.ah). r = 1 selects the .r form, where rs2 is a scalar that is
//    replicated to both lanes.
//
// Encodings come from GVSoC (gvsoc2/core/models/cpu/iss/isa_gen/
// isa_smallfloats.py, classes Xf16alt and Xfvec) and were checked
// byte for byte against GAP9 GNU as (-march=rv32imcxgap9). GAP9 has no Xf8
// and no Xfaux, so there are no .b, vfdotp*, vfavg, fmulex or fmacex here.
// vfdiv/vfsqrt are modelled by GVSoC but rejected by GAP9 GNU as; they are
// defined with GVSoC's encoding.
//
// These are not the Snitch smallfloat instructions (RISCVInstrInfoXsmallfloat
// *.td, features xfalthalf/xfvec*): Snitch keeps operands in the F registers
// and encodes .ah exactly like .h (the format comes from a CSR). The two sets
// share mnemonics and some encodings, so this file uses its own decoder
// namespace and _INX record names, the way upstream separates Zhinx from Zfh.
//
// MC only: no selection patterns yet.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instruction classes
//===----------------------------------------------------------------------===//

// Scalar .ah fused multiply-add: R4 format with funct3 fixed to ALTF.
let hasSideEffects = 0, mayLoad = 0, mayStore = 0, mayRaiseFPException = 1 in
class XpulpFPFMA_AH<RISCVOpcode opcode, string opcodestr>
    : RVInstR4<0b10, 0b101, opcode, (outs FPR16INX:$rd),
               (ins FPR16INX:$rs1, FPR16INX:$rs2, FPR16INX:$rs3),
               opcodestr, "$rd, $rs1, $rs2, $rs3">, Sched<[]>;

// Packed ops: funct7 = 0b10 ++ op, funct3 = r ++ vfmt.
defvar XpulpVFmtH = 0b10;
defvar XpulpVFmtAH = 0b01;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, mayRaiseFPException = 1 in {
class XpulpVF_rr<bits<5> op, bit r, bits<2> vfmt, dag outs, dag ins,
                 string opcodestr>
    : RVInstR<{0b10, op}, {r, vfmt}, OPC_OP, outs, ins, opcodestr,
              "$rd, $rs1, $rs2">, Sched<[]>;

class XpulpVF_r<bits<5> op, bits<5> rs2val, bit r, bits<2> vfmt,
                DAGOperand rdty, DAGOperand rs1ty, string opcodestr>
    : RVInstR<{0b10, op}, {r, vfmt}, OPC_OP, (outs rdty:$rd), (ins rs1ty:$rs1),
              opcodestr, "$rd, $rs1">, Sched<[]> {
  let rs2 = rs2val;
}

// Ops that read rd (vfmac, vfmre, vfcpka): rd is tied, as in XCV cv.mac.
let Constraints = "$rd = $rd_wb" in
class XpulpVF_rrr<bits<5> op, bit r, bits<2> vfmt, DAGOperand rs1ty,
                  DAGOperand rs2ty, string opcodestr>
    : RVInstR<{0b10, op}, {r, vfmt}, OPC_OP, (outs GPR:$rd_wb),
              (ins GPR:$rd, rs1ty:$rs1, rs2ty:$rs2), opcodestr,
              "$rd, $rs1, $rs2">, Sched<[]>;
} // hasSideEffects = 0, mayLoad = 0, mayStore = 0, mayRaiseFPException = 1

// Plain and .r forms of a two-operand packed op. In the .r form rs2 is a
// scalar half (low 16 bits of the GPR).
multiclass XpulpVF_rr_m<bits<5> op, string mnemonic, DAGOperand rdty = GPR> {
  def _H_INX : XpulpVF_rr<op, 0, XpulpVFmtH, (outs rdty:$rd),
                          (ins GPR:$rs1, GPR:$rs2), mnemonic # ".h">;
  def _R_H_INX : XpulpVF_rr<op, 1, XpulpVFmtH, (outs rdty:$rd),
                            (ins GPR:$rs1, FPR16INX:$rs2), mnemonic # ".r.h">;
}
multiclass XpulpVF_rr_ah_m<bits<5> op, string mnemonic, DAGOperand rdty = GPR> {
  def _AH_INX : XpulpVF_rr<op, 0, XpulpVFmtAH, (outs rdty:$rd),
                           (ins GPR:$rs1, GPR:$rs2), mnemonic # ".ah">;
  def _R_AH_INX : XpulpVF_rr<op, 1, XpulpVFmtAH, (outs rdty:$rd),
                             (ins GPR:$rs1, FPR16INX:$rs2), mnemonic # ".r.ah">;
}

//===----------------------------------------------------------------------===//
// Xpulpf16alt: scalar bfloat16 in GPRs
//===----------------------------------------------------------------------===//

let Predicates = [HasVendorXpulpf16alt], DecoderNamespace = "Xpulpfloat" in {
def FMADD_AH_INX  : XpulpFPFMA_AH<OPC_MADD,  "fmadd.ah">;
def FMSUB_AH_INX  : XpulpFPFMA_AH<OPC_MSUB,  "fmsub.ah">;
def FNMSUB_AH_INX : XpulpFPFMA_AH<OPC_NMSUB, "fnmsub.ah">;
def FNMADD_AH_INX : XpulpFPFMA_AH<OPC_NMADD, "fnmadd.ah">;

def FADD_AH_INX : FPALU_rr<0b0000010, 0b101, "fadd.ah", FPR16INX, Commutable=1>,
                  Sched<[]>;
def FSUB_AH_INX : FPALU_rr<0b0000110, 0b101, "fsub.ah", FPR16INX, Commutable=0>,
                  Sched<[]>;
def FMUL_AH_INX : FPALU_rr<0b0001010, 0b101, "fmul.ah", FPR16INX, Commutable=1>,
                  Sched<[]>;
def FDIV_AH_INX : FPALU_rr<0b0001110, 0b101, "fdiv.ah", FPR16INX, Commutable=0>,
                  Sched<[]>;
def FSQRT_AH_INX : FPUnaryOp_r<0b0101110, 0b00000, 0b101, FPR16INX, FPR16INX,
                               "fsqrt.ah">, Sched<[]>;

let mayRaiseFPException = 0 in {
def FSGNJ_AH_INX  : FPALU_rr<0b0010010, 0b100, "fsgnj.ah",  FPR16INX,
                             Commutable=0>, Sched<[]>;
def FSGNJN_AH_INX : FPALU_rr<0b0010010, 0b101, "fsgnjn.ah", FPR16INX,
                             Commutable=0>, Sched<[]>;
def FSGNJX_AH_INX : FPALU_rr<0b0010010, 0b110, "fsgnjx.ah", FPR16INX,
                             Commutable=0>, Sched<[]>;
}
def FMIN_AH_INX : FPALU_rr<0b0010110, 0b100, "fmin.ah", FPR16INX, Commutable=1>,
                  Sched<[]>;
def FMAX_AH_INX : FPALU_rr<0b0010110, 0b101, "fmax.ah", FPR16INX, Commutable=1>,
                  Sched<[]>;

def FEQ_AH_INX : FPCmp_rr<0b1010010, 0b110, "feq.ah", FPR16INX, Commutable=1>,
                 Sched<[]>;
def FLT_AH_INX : FPCmp_rr<0b1010010, 0b101, "flt.ah", FPR16INX>, Sched<[]>;
def FLE_AH_INX : FPCmp_rr<0b1010010, 0b100, "fle.ah", FPR16INX>, Sched<[]>;

def FCVT_W_AH_INX  : FPUnaryOp_r<0b1100010, 0b00000, 0b101, GPR, FPR16INX,
                                 "fcvt.w.ah">, Sched<[]>;
def FCVT_WU_AH_INX : FPUnaryOp_r<0b1100010, 0b00001, 0b101, GPR, FPR16INX,
                                 "fcvt.wu.ah">, Sched<[]>;
def FCVT_AH_W_INX  : FPUnaryOp_r<0b1101010, 0b00000, 0b101, FPR16INX, GPR,
                                 "fcvt.ah.w">, Sched<[]>;
def FCVT_AH_WU_INX : FPUnaryOp_r<0b1101010, 0b00001, 0b101, FPR16INX, GPR,
                                 "fcvt.ah.wu">, Sched<[]>;

let mayRaiseFPException = 0 in
def FCLASS_AH_INX : FPUnaryOp_r<0b1110010, 0b00000, 0b101, GPR, FPR16INX,
                                "fclass.ah">, Sched<[]>;

// bfloat16 <-> float. fcvt.s.ah is exact and has funct3 000 (the encoding of
// Zfbfmin's fcvt.s.bf16); fcvt.ah.s rounds and has funct3 ALTF with rs2 = 0
// (unlike Zfbfmin's fcvt.bf16.s, rs2 = 01000).
def FCVT_S_AH_INX : FPUnaryOp_r<0b0100000, 0b00110, 0b000, FPR32INX, FPR16INX,
                                "fcvt.s.ah">, Sched<[]>;
def FCVT_AH_S_INX : FPUnaryOp_r<0b0100010, 0b00000, 0b101, FPR16INX, FPR32INX,
                                "fcvt.ah.s">, Sched<[]>;
} // Predicates = [HasVendorXpulpf16alt], DecoderNamespace = "Xpulpfloat"

// bfloat16 <-> binary16. fcvt.h.ah rounds to binary16 and takes a real rm
// (dynamic by default); fcvt.ah.h rounds to bfloat16 with funct3 ALTF.
let Predicates = [HasVendorXpulpf16alt, HasStdExtZhinx],
    DecoderNamespace = "Xpulpfloat" in {
def FCVT_H_AH_INX : FPUnaryOp_r_frm<0b0100010, 0b00110, FPR16INX, FPR16INX,
                                    "fcvt.h.ah">, Sched<[]>;
def FCVT_AH_H_INX : FPUnaryOp_r<0b0100010, 0b00010, 0b101, FPR16INX, FPR16INX,
                                "fcvt.ah.h">, Sched<[]>;
}

// Assembler-only aliases accepted by GAP9 GNU as. GNU objdump prints the
// underlying instruction, so these are never used for printing.
let Predicates = [HasVendorXpulpf16alt] in {
def : InstAlias<"fabs.ah $rd, $rs",
                (FSGNJX_AH_INX FPR16INX:$rd, FPR16INX:$rs, FPR16INX:$rs), 0>;
def : InstAlias<"fneg.ah $rd, $rs",
                (FSGNJN_AH_INX FPR16INX:$rd, FPR16INX:$rs, FPR16INX:$rs), 0>;
def : InstAlias<"fgt.ah $rd, $rs, $rt",
                (FLT_AH_INX GPR:$rd, FPR16INX:$rt, FPR16INX:$rs), 0>;
def : InstAlias<"fge.ah $rd, $rs, $rt",
                (FLE_AH_INX GPR:$rd, FPR16INX:$rt, FPR16INX:$rs), 0>;
}

//===----------------------------------------------------------------------===//
// Xpulpfvec: packed 2 x binary16 / 2 x bfloat16 in one GPR
//===----------------------------------------------------------------------===//

// .h lanes are binary16 (needs Zhinx), .ah lanes are bfloat16 (needs
// Xpulpf16alt), as GVSoC's f16vec / f16altvec tags.
multiclass XpulpVFArith_m<bits<5> op, string mnemonic> {
  let Predicates = [HasVendorXpulpfvec, HasStdExtZhinx] in
  defm NAME : XpulpVF_rr_m<op, mnemonic>;
  let Predicates = [HasVendorXpulpfvec, HasVendorXpulpf16alt] in
  defm NAME : XpulpVF_rr_ah_m<op, mnemonic>;
}
// vfmac/vfmre: rd += / -= rs1 * rs2 lane-wise; rd is read.
multiclass XpulpVFMac_m<bits<5> op, string mnemonic> {
  let Predicates = [HasVendorXpulpfvec, HasStdExtZhinx] in {
  def _H_INX   : XpulpVF_rrr<op, 0, XpulpVFmtH, GPR, GPR, mnemonic # ".h">;
  def _R_H_INX : XpulpVF_rrr<op, 1, XpulpVFmtH, GPR, FPR16INX,
                             mnemonic # ".r.h">;
  }
  let Predicates = [HasVendorXpulpfvec, HasVendorXpulpf16alt] in {
  def _AH_INX   : XpulpVF_rrr<op, 0, XpulpVFmtAH, GPR, GPR, mnemonic # ".ah">;
  def _R_AH_INX : XpulpVF_rrr<op, 1, XpulpVFmtAH, GPR, FPR16INX,
                              mnemonic # ".r.ah">;
  }
}

let DecoderNamespace = "Xpulpfloat" in {
defm VFADD  : XpulpVFArith_m<0b00001, "vfadd">;
defm VFSUB  : XpulpVFArith_m<0b00010, "vfsub">;
defm VFMUL  : XpulpVFArith_m<0b00011, "vfmul">;
defm VFDIV  : XpulpVFArith_m<0b00100, "vfdiv">;
defm VFMIN  : XpulpVFArith_m<0b00101, "vfmin">;
defm VFMAX  : XpulpVFArith_m<0b00110, "vfmax">;
defm VFMAC  : XpulpVFMac_m<0b01000, "vfmac">;
defm VFMRE  : XpulpVFMac_m<0b01001, "vfmre">;
let mayRaiseFPException = 0 in {
defm VFSGNJ  : XpulpVFArith_m<0b01101, "vfsgnj">;
defm VFSGNJN : XpulpVFArith_m<0b01110, "vfsgnjn">;
defm VFSGNJX : XpulpVFArith_m<0b01111, "vfsgnjx">;
}
// Compares write a lane mask to rd.
defm VFEQ : XpulpVFArith_m<0b10000, "vfeq">;
defm VFNE : XpulpVFArith_m<0b10001, "vfne">;
defm VFLT : XpulpVFArith_m<0b10010, "vflt">;
defm VFGE : XpulpVFArith_m<0b10011, "vfge">;
defm VFLE : XpulpVFArith_m<0b10100, "vfle">;
defm VFGT : XpulpVFArith_m<0b10101, "vfgt">;

let Predicates = [HasVendorXpulpfvec, HasStdExtZhinx] in {
def VFSQRT_H_INX  : XpulpVF_r<0b00111, 0b00000, 0, XpulpVFmtH, GPR, GPR,
                              "vfsqrt.h">;
let mayRaiseFPException = 0 in
def VFCLASS_H_INX : XpulpVF_r<0b01100, 0b00001, 0, XpulpVFmtH, GPR, GPR,
                              "vfclass.h">;
// Lane-wise binary16 <-> 16-bit integer; the r bit selects unsigned.
def VFCVT_X_H_INX  : XpulpVF_r<0b01100, 0b00010, 0, XpulpVFmtH, GPR, GPR,
                               "vfcvt.x.h">;
def VFCVT_XU_H_INX : XpulpVF_r<0b01100, 0b00010, 1, XpulpVFmtH, GPR, GPR,
                               "vfcvt.xu.h">;
def VFCVT_H_X_INX  : XpulpVF_r<0b01100, 0b00011, 0, XpulpVFmtH, GPR, GPR,
                               "vfcvt.h.x">;
def VFCVT_H_XU_INX : XpulpVF_r<0b01100, 0b00011, 1, XpulpVFmtH, GPR, GPR,
                               "vfcvt.h.xu">;
// Rounds two floats to binary16 into the low lane of rd; the high lane of rd
// is kept.
def VFCPKA_H_S_INX : XpulpVF_rrr<0b11000, 0, XpulpVFmtH, FPR32INX, FPR32INX,
                                 "vfcpka.h.s">;
}

let Predicates = [HasVendorXpulpfvec, HasVendorXpulpf16alt] in {
def VFSQRT_AH_INX  : XpulpVF_r<0b00111, 0b00000, 0, XpulpVFmtAH, GPR, GPR,
                               "vfsqrt.ah">;
let mayRaiseFPException = 0 in
def VFCLASS_AH_INX : XpulpVF_r<0b01100, 0b00001, 0, XpulpVFmtAH, GPR, GPR,
                               "vfclass.ah">;
def VFCVT_X_AH_INX  : XpulpVF_r<0b01100, 0b00010, 0, XpulpVFmtAH, GPR, GPR,
                                "vfcvt.x.ah">;
def VFCVT_XU_AH_INX : XpulpVF_r<0b01100, 0b00010, 1, XpulpVFmtAH, GPR, GPR,
                                "vfcvt.xu.ah">;
def VFCVT_AH_X_INX  : XpulpVF_r<0b01100, 0b00011, 0, XpulpVFmtAH, GPR, GPR,
                                "vfcvt.ah.x">;
def VFCVT_AH_XU_INX : XpulpVF_r<0b01100, 0b00011, 1, XpulpVFmtAH, GPR, GPR,
                                "vfcvt.ah.xu">;
def VFCPKA_AH_S_INX : XpulpVF_rrr<0b11000, 0, XpulpVFmtAH, FPR32INX, FPR32INX,
                                  "vfcpka.ah.s">;
}

// Lane-wise binary16 <-> bfloat16. The vfmt field names the destination
// format.
let Predicates = [HasVendorXpulpfvec, HasStdExtZhinx, HasVendorXpulpf16alt] in {
def VFCVT_H_AH_INX : XpulpVF_r<0b01100, 0b00101, 0, XpulpVFmtH, GPR, GPR,
                               "vfcvt.h.ah">;
def VFCVT_AH_H_INX : XpulpVF_r<0b01100, 0b00110, 0, XpulpVFmtAH, GPR, GPR,
                               "vfcvt.ah.h">;
}
} // DecoderNamespace = "Xpulpfloat"

// Assembler-only aliases accepted by GAP9 GNU as (see above).
let Predicates = [HasVendorXpulpfvec, HasStdExtZhinx] in {
def : InstAlias<"vfabs.h $rd, $rs", (VFSGNJX_H_INX GPR:$rd, GPR:$rs, GPR:$rs), 0>;
def : InstAlias<"vfneg.h $rd, $rs", (VFSGNJN_H_INX GPR:$rd, GPR:$rs, GPR:$rs), 0>;
}
let Predicates = [HasVendorXpulpfvec, HasVendorXpulpf16alt] in {
def : InstAlias<"vfabs.ah $rd, $rs", (VFSGNJX_AH_INX GPR:$rd, GPR:$rs, GPR:$rs), 0>;
def : InstAlias<"vfneg.ah $rd, $rs", (VFSGNJN_AH_INX GPR:$rd, GPR:$rs, GPR:$rs), 0>;
}
