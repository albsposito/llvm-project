define <2 x bfloat> @f(ptr %p) {
  %r = load <2 x bfloat>, ptr %p, align 2
  ret <2 x bfloat> %r
}
