declare <2 x bfloat> @llvm.minnum.v2bf16(<2 x bfloat>, <2 x bfloat>)
define <2 x bfloat> @f(<2 x bfloat> %a, <2 x bfloat> %b) {
  %r = call <2 x bfloat> @llvm.minnum.v2bf16(<2 x bfloat> %a, <2 x bfloat> %b)
  ret <2 x bfloat> %r
}
