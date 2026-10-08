define <2 x i32> @f(<2 x i16> %a) {
  %r = sext <2 x i16> %a to <2 x i32>
  ret <2 x i32> %r
}
