define <4 x i8> @f(<4 x i8> %a, <4 x i8> %b) {
  %r = xor <4 x i8> %a, %b
  ret <4 x i8> %r
}
