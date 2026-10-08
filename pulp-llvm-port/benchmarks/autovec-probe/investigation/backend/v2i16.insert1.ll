define <2 x i16> @f(<2 x i16> %a, i16 %s) {
  %r = insertelement <2 x i16> %a, i16 %s, i32 1
  ret <2 x i16> %r
}
