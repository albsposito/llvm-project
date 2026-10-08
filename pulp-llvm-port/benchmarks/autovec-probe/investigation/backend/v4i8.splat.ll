define <4 x i8> @f(i8 %s) {
  %i = insertelement <4 x i8> poison, i8 %s, i32 0
  %sp = shufflevector <4 x i8> %i, <4 x i8> poison, <4 x i32> zeroinitializer
  ret <4 x i8> %sp
}
