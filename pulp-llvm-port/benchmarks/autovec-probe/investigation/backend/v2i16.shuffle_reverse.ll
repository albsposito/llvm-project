define <2 x i16> @f(<2 x i16> %a) {
  %r = shufflevector <2 x i16> %a, <2 x i16> poison, <2 x i32> <i32 1, i32 0>
  ret <2 x i16> %r
}
