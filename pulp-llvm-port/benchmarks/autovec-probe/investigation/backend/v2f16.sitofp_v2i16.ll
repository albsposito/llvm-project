define <2 x half> @f(<2 x i16> %a) {
  %r = sitofp <2 x i16> %a to <2 x half>
  ret <2 x half> %r
}
