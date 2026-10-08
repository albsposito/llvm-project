define <2 x i16> @f(<2 x i16> %a) {
  %r = ashr <2 x i16> %a, <i16 3, i16 3>
  ret <2 x i16> %r
}
