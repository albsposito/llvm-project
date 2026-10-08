define <2 x bfloat> @f(<2 x bfloat> %a) {
  %r = fneg <2 x bfloat> %a
  ret <2 x bfloat> %r
}
