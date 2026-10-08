define <4 x i8> @f(i8 %e0, i8 %e1, i8 %e2, i8 %e3) {
  %v0 = insertelement <4 x i8> poison, i8 %e0, i32 0
  %v1 = insertelement <4 x i8> %v0, i8 %e1, i32 1
  %v2 = insertelement <4 x i8> %v1, i8 %e2, i32 2
  %v3 = insertelement <4 x i8> %v2, i8 %e3, i32 3
  ret <4 x i8> %v3
}
