define <2 x i16> @f(i1 %c, <2 x i16> %x, <2 x i16> %y) {
  %r = select i1 %c, <2 x i16> %x, <2 x i16> %y
  ret <2 x i16> %r
}
