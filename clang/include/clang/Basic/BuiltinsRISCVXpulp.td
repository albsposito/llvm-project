//==- BuiltinsRISCVXpulp.td - PULP RISC-V builtin database -*- tablegen -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the PULP-specific (Xpulpv, Xssr, Xdma) builtin function
// database. It is included from BuiltinsRISCV.td, following the layout
// upstream uses for the CORE-V builtins (BuiltinsRISCVXCV.td, LLVM 20).
//
// Converted from the fork's TARGET_BUILTIN entries in BuiltinsRISCV.def
// (LLVM 18). The spelling of every builtin is "__builtin_" # NAME, so the
// builtin IDs (RISCV::BI__builtin_pulp_*, ...) are unchanged.
//
//===----------------------------------------------------------------------===//

class PULPBuiltin<string prototype, string features = ""> : TargetBuiltin {
  let Spellings = ["__builtin_" # NAME];
  let Prototype = prototype;
  let Features = features;
}

//===----------------------------------------------------------------------===//
// SSR extension.
//===----------------------------------------------------------------------===//
let Attributes = [NoThrow] in {
def ssr_setup_1d_r : PULPBuiltin<"void(unsigned int, unsigned long int, unsigned long int, unsigned long int, void *)", "xssr">;
def ssr_setup_1d_w : PULPBuiltin<"void(unsigned int, unsigned long int, unsigned long int, unsigned long int, void *)", "xssr">;
def ssr_read : PULPBuiltin<"void(unsigned int, unsigned int, void *)", "xssr">;
def ssr_write : PULPBuiltin<"void(unsigned int, unsigned int, void *)", "xssr">;
def ssr_setup_bound_stride_1d : PULPBuiltin<"void(unsigned int, unsigned long int, unsigned long int)", "xssr">;
def ssr_setup_bound_stride_2d : PULPBuiltin<"void(unsigned int, unsigned long int, unsigned long int)", "xssr">;
def ssr_setup_bound_stride_3d : PULPBuiltin<"void(unsigned int, unsigned long int, unsigned long int)", "xssr">;
def ssr_setup_bound_stride_4d : PULPBuiltin<"void(unsigned int, unsigned long int, unsigned long int)", "xssr">;
def ssr_setup_repetition : PULPBuiltin<"void(unsigned int, unsigned long int)", "xssr">;
def ssr_push : PULPBuiltin<"void(unsigned int, double)", "xssr">;
def ssr_pop : PULPBuiltin<"double(unsigned int)", "xssr">;
def ssr_enable : PULPBuiltin<"void()", "xssr">;
def ssr_disable : PULPBuiltin<"void()", "xssr">;
def ssr_barrier : PULPBuiltin<"void(unsigned int)", "xssr">;
} // Attributes = [NoThrow]

//===----------------------------------------------------------------------===//
// SDMA extension.
//===----------------------------------------------------------------------===//
let Attributes = [NoThrow] in {
def sdma_start_oned : PULPBuiltin<"unsigned int(unsigned long long int, unsigned long long int, unsigned int, unsigned int)", "xdma">;
def sdma_start_twod : PULPBuiltin<"unsigned int(unsigned long long int, unsigned long long int, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int)", "xdma">;
def sdma_stat : PULPBuiltin<"unsigned int(unsigned int)", "xdma">;
def sdma_wait_for_idle : PULPBuiltin<"void()", "xdma">;
} // Attributes = [NoThrow]

//===----------------------------------------------------------------------===//
// PULP extension.
//===----------------------------------------------------------------------===//
let Attributes = [NoThrow, Const] in {
def bitinsert : PULPBuiltin<"int(int, int, _Constant unsigned int, _Constant unsigned int)", "xpulpv">; // NOTE: normal builtin in GCC
} // Attributes = [NoThrow, Const]
// Constexpr: fold to the -mPE=<N> value (N - 1 for _m1) when one is given
// (ExprConstant.cpp).
let Attributes = [NoThrow, Constexpr] in {
def pulp_CoreCount : PULPBuiltin<"int()", "xpulpv">;
def pulp_CoreCount_m1 : PULPBuiltin<"int()", "xpulpv">; // CoreCount() - 1, as GCC
} // Attributes = [NoThrow, Constexpr]
let Attributes = [NoThrow] in {
def pulp_CoreId : PULPBuiltin<"int()", "xpulpv">;
def pulp_ClusterId : PULPBuiltin<"int()", "xpulpv">;
def pulp_IsFc : PULPBuiltin<"int()", "xpulpv">;
def pulp_HasFc : PULPBuiltin<"int()", "xpulpv">;
} // Attributes = [NoThrow]
let Attributes = [NoThrow, Const] in {
def pulp_mac : PULPBuiltin<"int(int, int, int)", "xpulpv">;
def pulp_machhs : PULPBuiltin<"int(int, int, int)", "xpulpv">;
def pulp_machhu : PULPBuiltin<"unsigned int(unsigned int, unsigned int, int)", "xpulpv">;
def pulp_macs : PULPBuiltin<"int(int, int, int)", "xpulpv">;
def pulp_macu : PULPBuiltin<"unsigned int(unsigned int, unsigned int, int)", "xpulpv">;
def pulp_msu : PULPBuiltin<"int(int, int, int)", "xpulpv">;
def pulp_bset : PULPBuiltin<"int(int, unsigned _Constant int)", "xpulpv">;
def pulp_bset_r : PULPBuiltin<"int(int, unsigned int)", "xpulpv">;
def pulp_clb : PULPBuiltin<"int(int)", "xpulpv">;
def pulp_cnt : PULPBuiltin<"int(int)", "xpulpv">;
def pulp_ff1 : PULPBuiltin<"int(int)", "xpulpv">;
def pulp_fl1 : PULPBuiltin<"int(int)", "xpulpv">;
def pulp_parity : PULPBuiltin<"int(int)", "xpulpv">;
def pulp_rotr : PULPBuiltin<"int(int, int)", "xpulpv">;
} // Attributes = [NoThrow, Const]
let Attributes = [NoThrow] in {
def pulp_read_base_off : PULPBuiltin<"int(int *, int)", "xpulpv">;
def pulp_write_base_off : PULPBuiltin<"void(int, int *, int)", "xpulpv">;
def pulp_read_base_off_v : PULPBuiltin<"int(int *, int)", "xpulpv">;
def pulp_write_base_off_v : PULPBuiltin<"void(int, int *, int)", "xpulpv">;
def pulp_read_then_spr_bit_clr : PULPBuiltin<"int(_Constant int, _Constant int)", "xpulpv">;
def pulp_read_then_spr_bit_set : PULPBuiltin<"int(_Constant int, _Constant int)", "xpulpv">;
def pulp_read_then_spr_write : PULPBuiltin<"int(_Constant int, int)", "xpulpv">;
def pulp_spr_bit_clr : PULPBuiltin<"void(_Constant int, _Constant int)", "xpulpv">;
def pulp_spr_bit_set : PULPBuiltin<"void(_Constant int, _Constant int)", "xpulpv">;
def pulp_spr_read : PULPBuiltin<"int(_Constant int)", "xpulpv">;
def pulp_spr_read_vol : PULPBuiltin<"int(_Constant int)", "xpulpv">;
def pulp_spr_write : PULPBuiltin<"void(_Constant int, int)", "xpulpv">;
def pulp_event_unit_read : PULPBuiltin<"unsigned int(int *, unsigned int)", "xpulpv">;
} // Attributes = [NoThrow]
let Attributes = [NoThrow, Const] in {
def pulp_abs : PULPBuiltin<"unsigned int(int)", "xpulpv">;
def pulp_addN : PULPBuiltin<"int(int, int, unsigned _Constant int)", "xpulpv">;
def pulp_addN_r : PULPBuiltin<"int(int, int, unsigned int)", "xpulpv">;
def pulp_addRN : PULPBuiltin<"int(int, int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_addRN_r : PULPBuiltin<"unsigned int(int, int, unsigned int)", "xpulpv">;
def pulp_adduN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned _Constant int)", "xpulpv">;
def pulp_adduN_r : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned int)", "xpulpv">;
def pulp_adduRN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_adduRN_r : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned int)", "xpulpv">;
def pulp_clip : PULPBuiltin<"int(int, _Constant int, _Constant int)", "xpulpv">;
def pulp_clip_r : PULPBuiltin<"int(int, int)", "xpulpv">;
def pulp_clipu : PULPBuiltin<"unsigned int(int, _Constant int, _Constant int)", "xpulpv">;
def pulp_clipu_r : PULPBuiltin<"unsigned int(int, unsigned int)", "xpulpv">;
def pulp_maxsi : PULPBuiltin<"int(int, int)", "xpulpv">;
def pulp_machhsN : PULPBuiltin<"int(int, int, int, unsigned _Constant int)", "xpulpv">;
def pulp_machhsRN : PULPBuiltin<"int(int, int, int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_machhuN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, int, unsigned _Constant int)", "xpulpv">;
def pulp_machhuRN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_macsN : PULPBuiltin<"int(int, int, int, unsigned _Constant int)", "xpulpv">;
def pulp_macsRN : PULPBuiltin<"int(int, int, int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_macuN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, int, unsigned _Constant int)", "xpulpv">;
def pulp_macuRN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_maxusi : PULPBuiltin<"unsigned int(unsigned int, unsigned int)", "xpulpv">;
def pulp_minsi : PULPBuiltin<"int(int, int)", "xpulpv">;
def pulp_minusi : PULPBuiltin<"unsigned int(unsigned int, unsigned int)", "xpulpv">;
def pulp_mulhhs : PULPBuiltin<"int(int, int)", "xpulpv">;
def pulp_mulhhsN : PULPBuiltin<"int(int, int, unsigned _Constant int)", "xpulpv">;
def pulp_mulhhsRN : PULPBuiltin<"int(int, int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_mulhhu : PULPBuiltin<"unsigned int(unsigned int, unsigned int)", "xpulpv">;
def pulp_mulhhuN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned _Constant int)", "xpulpv">;
def pulp_mulhhuRN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_muls : PULPBuiltin<"int(int, int)", "xpulpv">;
def pulp_mulsN : PULPBuiltin<"int(int, int, unsigned _Constant int)", "xpulpv">;
def pulp_mulsRN : PULPBuiltin<"int(int, int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_mulu : PULPBuiltin<"unsigned int(unsigned int, unsigned int)", "xpulpv">;
def pulp_muluN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned _Constant int)", "xpulpv">;
def pulp_muluRN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_subN : PULPBuiltin<"int(int, int, unsigned _Constant int)", "xpulpv">;
def pulp_subN_r : PULPBuiltin<"int(int, int, unsigned int)", "xpulpv">;
def pulp_subRN : PULPBuiltin<"int(int, int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_subRN_r : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned int)", "xpulpv">;
def pulp_subuN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned _Constant int)", "xpulpv">;
def pulp_subuN_r : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned int)", "xpulpv">;
def pulp_subuRN : PULPBuiltin<"unsigned int(unsigned int, unsigned int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_subuRN_r : PULPBuiltin<"unsigned int(int, int, unsigned int)", "xpulpv">;
def pulp_bclr : PULPBuiltin<"int(int, unsigned _Constant int)", "xpulpv">;
def pulp_bclr_r : PULPBuiltin<"int(int, unsigned int)", "xpulpv">;
def pulp_bextract : PULPBuiltin<"int(int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_bextract_r : PULPBuiltin<"int(int, unsigned int)", "xpulpv">;
def pulp_bextractu : PULPBuiltin<"int(int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_bextractu_r : PULPBuiltin<"int(int, unsigned int)", "xpulpv">;
def pulp_binsert : PULPBuiltin<"int(int, unsigned _Constant int, int, unsigned _Constant int, unsigned _Constant int)", "xpulpv">;
def pulp_binsert_r : PULPBuiltin<"int(int, int, unsigned int)", "xpulpv">;
def pulp_dotsp2 : PULPBuiltin<"int(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_dotsp4 : PULPBuiltin<"int(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_dotspsc2 : PULPBuiltin<"int(_Vector<2, short>, int)", "xpulpv">;
def pulp_dotspsc4 : PULPBuiltin<"int(_Vector<4, char>, int)", "xpulpv">;
def pulp_dotup2 : PULPBuiltin<"unsigned int(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_dotup4 : PULPBuiltin<"unsigned int(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_dotupsc2 : PULPBuiltin<"unsigned int(_Vector<2, short>, unsigned int)", "xpulpv">;
def pulp_dotupsc4 : PULPBuiltin<"unsigned int(_Vector<4, char>, unsigned int)", "xpulpv">;
def pulp_dotusp2 : PULPBuiltin<"int(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_dotusp4 : PULPBuiltin<"int(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_dotuspsc2 : PULPBuiltin<"int(_Vector<2, short>, int)", "xpulpv">;
def pulp_dotuspsc4 : PULPBuiltin<"int(_Vector<4, char>, int)", "xpulpv">;
def pulp_sdotsp2 : PULPBuiltin<"int(_Vector<2, short>, _Vector<2, short>, int)", "xpulpv">;
def pulp_sdotsp4 : PULPBuiltin<"int(_Vector<4, char>, _Vector<4, char>, int)", "xpulpv">;
def pulp_sdotspsc2 : PULPBuiltin<"int(_Vector<2, short>, int, int)", "xpulpv">;
def pulp_sdotspsc4 : PULPBuiltin<"int(_Vector<4, char>, int, int)", "xpulpv">;
def pulp_sdotup2 : PULPBuiltin<"unsigned int(_Vector<2, short>, _Vector<2, short>, unsigned int)", "xpulpv">;
def pulp_sdotup4 : PULPBuiltin<"unsigned int(_Vector<4, char>, _Vector<4, char>, unsigned int)", "xpulpv">;
def pulp_sdotupsc2 : PULPBuiltin<"unsigned int(_Vector<2, short>, unsigned int, unsigned int)", "xpulpv">;
def pulp_sdotupsc4 : PULPBuiltin<"unsigned int(_Vector<4, char>, unsigned int, unsigned int)", "xpulpv">;
def pulp_sdotusp2 : PULPBuiltin<"int(_Vector<2, short>, _Vector<2, short>, int)", "xpulpv">;
def pulp_sdotusp4 : PULPBuiltin<"int(_Vector<4, char>, _Vector<4, char>, int)", "xpulpv">;
def pulp_sdotuspsc2 : PULPBuiltin<"int(_Vector<2, short>, int, int)", "xpulpv">;
def pulp_sdotuspsc4 : PULPBuiltin<"int(_Vector<4, char>, int, int)", "xpulpv">;
def pulp_abs2 : PULPBuiltin<"unsigned _Vector<2, short>(_Vector<2, short>)", "xpulpv">;
def pulp_abs4 : PULPBuiltin<"unsigned _Vector<4, char>(_Vector<4, char>)", "xpulpv">;
def pulp_add2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_add4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_and2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_and4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_avg2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_avg4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_avgu2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_avgu4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_exor2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_exor4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_max2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_max4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_maxu2 : PULPBuiltin<"unsigned _Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_maxu4 : PULPBuiltin<"unsigned _Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_min2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_min4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_minu2 : PULPBuiltin<"unsigned _Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_minu4 : PULPBuiltin<"unsigned _Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_neg2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>)", "xpulpv">;
def pulp_neg4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>)", "xpulpv">;
def pulp_or2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_or4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_sll2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_sll4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_sra2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_sra4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_srl2 : PULPBuiltin<"unsigned _Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_srl4 : PULPBuiltin<"unsigned _Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_sub2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_sub4 : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_pack2 : PULPBuiltin<"_Vector<2, short>(int, int)", "xpulpv">;
def pulp_pack4 : PULPBuiltin<"_Vector<4, char>(int, int, int, int)", "xpulpv">;
def pulp_pack4_hi : PULPBuiltin<"_Vector<4, char>(int, int, _Vector<4, char>)", "xpulpv">;
def pulp_pack4_lo : PULPBuiltin<"_Vector<4, char>(int, int, _Vector<4, char>)", "xpulpv">;
def pulp_shuffle2h : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_shuffle4b : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>, _Vector<4, char>)", "xpulpv">;
def pulp_shuffleh : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xpulpv">;
def pulp_shuffleb : PULPBuiltin<"_Vector<4, char>(_Vector<4, char>, _Vector<4, char>)", "xpulpv">;
} // Attributes = [NoThrow, Const]
let Attributes = [NoThrow] in {
def pulp_OffsetedRead : PULPBuiltin<"int(int *, int)", "xpulpv">;
def pulp_OffsetedReadByte : PULPBuiltin<"int(char *, int)", "xpulpv">;
def pulp_OffsetedReadHalf : PULPBuiltin<"int(short *, int)", "xpulpv">;
def pulp_OffsetedWrite : PULPBuiltin<"void(int, int *, int)", "xpulpv">;
def pulp_OffsetedWriteByte : PULPBuiltin<"void(int, char *, int)", "xpulpv">;
def pulp_OffsetedWriteHalf : PULPBuiltin<"void(int, short *, int)", "xpulpv">;
} // Attributes = [NoThrow]

// GAP9 PMSIS memory builtins (task 20/F016). Prototypes are the ones GAP9 GCC
// declares for the same builtins (void * base, int offset):
//  - event_unit_read_fenced: p.elw, event-unit load that sleeps the core until
//    the event unit answers; a full compiler memory barrier (PMSIS evt_read32).
//  - OffsetedWritePtr: store of a pointer at base + offset (sw / p.sw) that
//    is never removed as a dead store (PMSIS GAP_WRITE_PTR).
let Attributes = [NoThrow] in {
def pulp_event_unit_read_fenced : PULPBuiltin<"int(void *, int)", "xpulpv">;
def pulp_OffsetedWritePtr : PULPBuiltin<"void(void *, void *, int)", "xpulpv">;
} // Attributes = [NoThrow]

//===----------------------------------------------------------------------===//
// GCC's generic vector permute, __builtin_shuffle(v, mask) and
// __builtin_shuffle(v1, v2, mask), which the GAP9 SDK kernels use on the
// packed SIMD types. Type-checked in SemaRISCV.cpp; lowered in CGBuiltin.cpp
// to shufflevector (constant mask), to the Xpulpv shuffle intrinsics (run-time
// mask on 4 x 8-bit / 2 x 16-bit vectors), or to an element-wise sequence.
//===----------------------------------------------------------------------===//
let Attributes = [NoThrow, Const, CustomTypeChecking] in {
def shuffle : PULPBuiltin<"void(...)">;
} // Attributes = [NoThrow, Const, CustomTypeChecking]

// GAP9 complex / divide-by-N builtins (task 20/F038). Prototypes are GAP9
// GCC's (all __vector(2) short). They need the GAP9 extension (xgap9, target
// feature "xgap"): their instructions are GAP9 additions that PULPv2 cores
// lack. Element 0 (bits 15:0) is the real part, element 1 the imaginary part.
let Attributes = [NoThrow, Const] in {
def pulp_add2div2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xgap">;
def pulp_add2div4 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xgap">;
def pulp_sub2div2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xgap">;
def pulp_sub2div4 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xgap">;
def pulp_sub2rotmj : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xgap">;
def pulp_cplx_conj : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>)", "xgap">;
def pulp_cplxmuls2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xgap">;
def pulp_cplxmuls2div2 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xgap">;
def pulp_cplxmuls2div4 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xgap">;
def pulp_cplxmuls2div8 : PULPBuiltin<"_Vector<2, short>(_Vector<2, short>, _Vector<2, short>)", "xgap">;
} // Attributes = [NoThrow, Const]

// GAP9 f32 scalar builtins (task 20/F036, backlog B97 batch A). Prototypes
// are GAP9 GCC's. They map to standard F/Zfinx instructions (GAP9 is Zfinx):
//  - f32max/f32min: fmax.s/fmin.s (IEEE 754-2019 maximumNumber/minimumNumber:
//    a NaN operand yields the other operand, -0.0 < +0.0)
//  - f32abs: fabs.s; f32sqrt: fsqrt.s (dynamic rounding mode)
//  - rintsf2/rdownsf2/rupsf2: fcvt.w.s with rounding mode rmm/rdn/rup
//    (saturating: NaN and too large give INT_MAX, too small gives INT_MIN)
let Attributes = [NoThrow, Const] in {
def pulp_f32max : PULPBuiltin<"float(float, float)", "xpulpv,(f|zfinx)">;
def pulp_f32min : PULPBuiltin<"float(float, float)", "xpulpv,(f|zfinx)">;
def pulp_f32abs : PULPBuiltin<"float(float)", "xpulpv,(f|zfinx)">;
def pulp_f32sqrt : PULPBuiltin<"float(float)", "xpulpv,(f|zfinx)">;
def pulp_rintsf2 : PULPBuiltin<"int(float)", "xpulpv,(f|zfinx)">;
def pulp_rdownsf2 : PULPBuiltin<"int(float)", "xpulpv,(f|zfinx)">;
def pulp_rupsf2 : PULPBuiltin<"int(float)", "xpulpv,(f|zfinx)">;
} // Attributes = [NoThrow, Const]

//===----------------------------------------------------------------------===//
// GAP9 half-precision absolute value (task 20/F041). Prototypes are GAP9
// GCC's: float16 is _Float16 (IEEE half), float16alt is __bf16 (bfloat16),
// v2h / v2ah are GCC vectors of two of them in one 32-bit register. Each one
// clears the sign bit of every lane and nothing else (GCC: fabs.h, fabs.ah,
// vfabs.h, vfabs.ah). Lowered in CGBuiltin.cpp (EmitRISCVBuiltinExpr).
//===----------------------------------------------------------------------===//
let Attributes = [NoThrow, Const] in {
def pulp_f16abs : PULPBuiltin<"_Float16(_Float16)", "xpulpv,(zhinx|zfh)">;
def pulp_f16altabs : PULPBuiltin<"__bf16(__bf16)", "xpulpv,xpulpf16alt">;
def pulp_f16abs2 : PULPBuiltin<"_Vector<2, _Float16>(_Vector<2, _Float16>)", "xpulpfvec,zhinx">;
def pulp_f16altabs2 : PULPBuiltin<"_Vector<2, __bf16>(_Vector<2, __bf16>)", "xpulpfvec,xpulpf16alt">;
} // Attributes = [NoThrow, Const]
