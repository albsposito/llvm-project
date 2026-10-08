define <2 x i16> @f(i16 %s) {
  %i = insertelement <2 x i16> poison, i16 %s, i32 0
  %sp = shufflevector <2 x i16> %i, <2 x i16> poison, <2 x i32> zeroinitializer
  ret <2 x i16> %sp
}
