declare <2 x bfloat> @llvm.fabs.v2bf16(<2 x bfloat>)
define <2 x bfloat> @f(<2 x bfloat> %a) {
  %r = call <2 x bfloat> @llvm.fabs.v2bf16(<2 x bfloat> %a)
  ret <2 x bfloat> %r
}
