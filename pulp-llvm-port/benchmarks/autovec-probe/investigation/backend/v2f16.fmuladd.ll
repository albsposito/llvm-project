declare <2 x half> @llvm.fmuladd.v2f16(<2 x half>, <2 x half>, <2 x half>)
define <2 x half> @f(<2 x half> %a, <2 x half> %b, <2 x half> %c) {
  %r = call <2 x half> @llvm.fmuladd.v2f16(<2 x half> %a, <2 x half> %b, <2 x half> %c)
  ret <2 x half> %r
}
