define <2 x bfloat> @f(<2 x bfloat> %a, <2 x bfloat> %b) {
  %c = fcmp olt <2 x bfloat> %a, %b
  %r = select <2 x i1> %c, <2 x bfloat> %a, <2 x bfloat> %b
  ret <2 x bfloat> %r
}
