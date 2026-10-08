define <2 x bfloat> @f(<2 x bfloat> %a, <2 x bfloat> %b) {
  %r = fmul <2 x bfloat> %a, %b
  ret <2 x bfloat> %r
}
