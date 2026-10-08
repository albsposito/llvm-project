define <2 x half> @f(<2 x half> %a, <2 x half> %b) {
  %r = fdiv <2 x half> %a, %b
  ret <2 x half> %r
}
