define <4 x i8> @f(<4 x i8> %a, <4 x i8> %b) {
  %c = icmp slt <4 x i8> %a, %b
  %r = sext <4 x i1> %c to <4 x i8>
  ret <4 x i8> %r
}
