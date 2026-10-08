define <2 x i16> @f(i16 %e0, i16 %e1) {
  %v0 = insertelement <2 x i16> poison, i16 %e0, i32 0
  %v1 = insertelement <2 x i16> %v0, i16 %e1, i32 1
  ret <2 x i16> %v1
}
