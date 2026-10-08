declare <2 x bfloat> @llvm.fmuladd.v2bf16(<2 x bfloat>, <2 x bfloat>, <2 x bfloat>)
define <2 x bfloat> @f(<2 x bfloat> %a, <2 x bfloat> %b, <2 x bfloat> %c) {
  %r = call <2 x bfloat> @llvm.fmuladd.v2bf16(<2 x bfloat> %a, <2 x bfloat> %b, <2 x bfloat> %c)
  ret <2 x bfloat> %r
}
