declare <2 x i16> @llvm.usub.sat.v2i16(<2 x i16>, <2 x i16>)
define <2 x i16> @f(<2 x i16> %a, <2 x i16> %b) {
  %r = call <2 x i16> @llvm.usub.sat.v2i16(<2 x i16> %a, <2 x i16> %b)
  ret <2 x i16> %r
}
