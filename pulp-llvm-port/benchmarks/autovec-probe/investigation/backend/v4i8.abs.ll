declare <4 x i8> @llvm.abs.v4i8(<4 x i8>, i1)
define <4 x i8> @f(<4 x i8> %a) {
  %r = call <4 x i8> @llvm.abs.v4i8(<4 x i8> %a, i1 false)
  ret <4 x i8> %r
}
