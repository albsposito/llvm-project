define <2 x i16> @f(<2 x i32> %a) {
  %r = trunc <2 x i32> %a to <2 x i16>
  ret <2 x i16> %r
}
