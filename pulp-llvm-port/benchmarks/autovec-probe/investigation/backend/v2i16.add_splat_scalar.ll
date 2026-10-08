define <2 x i16> @f(<2 x i16> %a, i16 %s) {
  %i = insertelement <2 x i16> poison, i16 %s, i32 0
  %sp = shufflevector <2 x i16> %i, <2 x i16> poison, <2 x i32> zeroinitializer
  %r = add <2 x i16> %a, %sp
  ret <2 x i16> %r
}
