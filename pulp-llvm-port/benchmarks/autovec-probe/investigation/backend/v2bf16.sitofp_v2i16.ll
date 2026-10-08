define <2 x bfloat> @f(<2 x i16> %a) {
  %r = sitofp <2 x i16> %a to <2 x bfloat>
  ret <2 x bfloat> %r
}
