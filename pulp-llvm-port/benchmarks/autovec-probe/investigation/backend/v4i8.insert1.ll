define <4 x i8> @f(<4 x i8> %a, i8 %s) {
  %r = insertelement <4 x i8> %a, i8 %s, i32 1
  ret <4 x i8> %r
}
