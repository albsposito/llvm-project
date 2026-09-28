# llvm-mc -mattr=+zfinx,+zhinx and GAP9 GNU as give byte-identical code for these GAP9 Xf16 instructions
fadd.h a0,a0,a1
fmul.h a0,a0,a1
fmadd.h a0,a0,a1,a2
fmsub.h a0,a1,a2,a0
fdiv.h a0,a0,a1
flt.h a0,a0,a1
fcvt.s.h a0,a0
fcvt.h.s a0,a0
fcvt.w.h a0,a0,rtz
fcvt.h.w a0,a0
fcvt.wu.h a0,a0,rtz
fneg.h a0,a0
fmax.h a0,a0,a1
fsqrt.h a0,a0
