define <2 x i16> @f(<2 x i16> %a, i16 %s, i32 %i) {
  %r = insertelement <2 x i16> %a, i16 %s, i32 %i
  ret <2 x i16> %r
}
