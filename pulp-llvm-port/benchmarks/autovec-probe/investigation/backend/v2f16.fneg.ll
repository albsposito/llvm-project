define <2 x half> @f(<2 x half> %a) {
  %r = fneg <2 x half> %a
  ret <2 x half> %r
}
