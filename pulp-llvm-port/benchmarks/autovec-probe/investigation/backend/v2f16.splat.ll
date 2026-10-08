define <2 x half> @f(half %s) {
  %i = insertelement <2 x half> poison, half %s, i32 0
  %sp = shufflevector <2 x half> %i, <2 x half> poison, <2 x i32> zeroinitializer
  ret <2 x half> %sp
}
