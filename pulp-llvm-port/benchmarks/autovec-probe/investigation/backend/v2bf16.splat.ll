define <2 x bfloat> @f(bfloat %s) {
  %i = insertelement <2 x bfloat> poison, bfloat %s, i32 0
  %sp = shufflevector <2 x bfloat> %i, <2 x bfloat> poison, <2 x i32> zeroinitializer
  ret <2 x bfloat> %sp
}
