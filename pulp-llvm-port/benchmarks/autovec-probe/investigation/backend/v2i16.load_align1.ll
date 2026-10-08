define <2 x i16> @f(ptr %p) {
  %r = load <2 x i16>, ptr %p, align 1
  ret <2 x i16> %r
}
