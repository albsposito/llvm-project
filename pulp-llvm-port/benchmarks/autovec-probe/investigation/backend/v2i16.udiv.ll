define <2 x i16> @f(<2 x i16> %a, <2 x i16> %b) {
  %r = udiv <2 x i16> %a, %b
  ret <2 x i16> %r
}
