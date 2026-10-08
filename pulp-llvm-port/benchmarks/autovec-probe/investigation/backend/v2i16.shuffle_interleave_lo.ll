define <2 x i16> @f(<2 x i16> %a, <2 x i16> %b) {
  %r = shufflevector <2 x i16> %a, <2 x i16> %b, <2 x i32> <i32 0, i32 2>
  ret <2 x i16> %r
}
