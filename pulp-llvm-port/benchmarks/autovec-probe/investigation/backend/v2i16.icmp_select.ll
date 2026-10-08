define <2 x i16> @f(<2 x i16> %a, <2 x i16> %b, <2 x i16> %x, <2 x i16> %y) {
  %c = icmp slt <2 x i16> %a, %b
  %r = select <2 x i1> %c, <2 x i16> %x, <2 x i16> %y
  ret <2 x i16> %r
}
