declare <2 x i16> @llvm.abs.v2i16(<2 x i16>, i1)
define <2 x i16> @f(<2 x i16> %a) {
  %r = call <2 x i16> @llvm.abs.v2i16(<2 x i16> %a, i1 false)
  ret <2 x i16> %r
}
