define <4 x i8> @f(<4 x i32> %a) {
  %r = trunc <4 x i32> %a to <4 x i8>
  ret <4 x i8> %r
}
