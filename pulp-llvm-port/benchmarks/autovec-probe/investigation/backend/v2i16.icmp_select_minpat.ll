define <2 x i16> @f(<2 x i16> %a, <2 x i16> %b) {
  %c = icmp slt <2 x i16> %a, %b
  %r = select <2 x i1> %c, <2 x i16> %a, <2 x i16> %b
  ret <2 x i16> %r
}
