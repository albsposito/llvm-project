define <2 x i16> @f(<2 x i16> %a, <2 x i16> %b) {
  %c = icmp eq <2 x i16> %a, %b
  %r = sext <2 x i1> %c to <2 x i16>
  ret <2 x i16> %r
}
