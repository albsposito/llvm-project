define <4 x i8> @f(<4 x i8> %a) {
  %r = mul <4 x i8> %a, <i8 7, i8 7, i8 7, i8 7>
  ret <4 x i8> %r
}
