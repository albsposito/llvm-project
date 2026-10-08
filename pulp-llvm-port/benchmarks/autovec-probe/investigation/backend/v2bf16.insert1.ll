define <2 x bfloat> @f(<2 x bfloat> %a, bfloat %s) {
  %r = insertelement <2 x bfloat> %a, bfloat %s, i32 1
  ret <2 x bfloat> %r
}
