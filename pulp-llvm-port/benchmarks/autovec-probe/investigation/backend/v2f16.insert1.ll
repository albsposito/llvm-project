define <2 x half> @f(<2 x half> %a, half %s) {
  %r = insertelement <2 x half> %a, half %s, i32 1
  ret <2 x half> %r
}
