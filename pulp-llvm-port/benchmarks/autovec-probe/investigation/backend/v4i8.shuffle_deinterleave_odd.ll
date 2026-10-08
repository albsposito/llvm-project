define <4 x i8> @f(<4 x i8> %a, <4 x i8> %b) {
  %r = shufflevector <4 x i8> %a, <4 x i8> %b, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  ret <4 x i8> %r
}
