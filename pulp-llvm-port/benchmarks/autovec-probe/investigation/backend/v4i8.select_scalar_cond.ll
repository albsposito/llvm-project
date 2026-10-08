define <4 x i8> @f(i1 %c, <4 x i8> %x, <4 x i8> %y) {
  %r = select i1 %c, <4 x i8> %x, <4 x i8> %y
  ret <4 x i8> %r
}
