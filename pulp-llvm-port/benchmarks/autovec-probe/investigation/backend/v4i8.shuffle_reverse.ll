define <4 x i8> @f(<4 x i8> %a) {
  %r = shufflevector <4 x i8> %a, <4 x i8> poison, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  ret <4 x i8> %r
}
