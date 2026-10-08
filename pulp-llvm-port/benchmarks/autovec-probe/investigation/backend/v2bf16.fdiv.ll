define <2 x bfloat> @f(<2 x bfloat> %a, <2 x bfloat> %b) {
  %r = fdiv <2 x bfloat> %a, %b
  ret <2 x bfloat> %r
}
