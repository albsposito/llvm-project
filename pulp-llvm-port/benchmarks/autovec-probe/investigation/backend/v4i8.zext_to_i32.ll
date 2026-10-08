define <4 x i32> @f(<4 x i8> %a) {
  %r = zext <4 x i8> %a to <4 x i32>
  ret <4 x i32> %r
}
