define <4 x i8> @f(<4 x i8> %a) {
  %r = ashr <4 x i8> %a, <i8 3, i8 3, i8 3, i8 3>
  ret <4 x i8> %r
}
