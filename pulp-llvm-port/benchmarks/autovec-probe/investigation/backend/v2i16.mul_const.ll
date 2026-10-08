define <2 x i16> @f(<2 x i16> %a) {
  %r = mul <2 x i16> %a, <i16 7, i16 7>
  ret <2 x i16> %r
}
