define <2 x i16> @f(<2 x i16> %a, <2 x i16> %b) {
  %r = shufflevector <2 x i16> %a, <2 x i16> %b, <2 x i32> <i32 1, i32 3>
  ret <2 x i16> %r
}
