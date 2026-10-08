define <2 x i16> @f(<2 x bfloat> %a) {
  %r = fptosi <2 x bfloat> %a to <2 x i16>
  ret <2 x i16> %r
}
