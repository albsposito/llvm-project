define <2 x half> @f(<2 x half> %a, <2 x half> %b) {
  %c = fcmp olt <2 x half> %a, %b
  %r = select <2 x i1> %c, <2 x half> %a, <2 x half> %b
  ret <2 x half> %r
}
