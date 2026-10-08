declare <4 x i8> @llvm.umin.v4i8(<4 x i8>, <4 x i8>)
define <4 x i8> @f(<4 x i8> %a, <4 x i8> %b) {
  %r = call <4 x i8> @llvm.umin.v4i8(<4 x i8> %a, <4 x i8> %b)
  ret <4 x i8> %r
}
