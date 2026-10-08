define <2 x half> @f(ptr %p) {
  %r = load <2 x half>, ptr %p, align 2
  ret <2 x half> %r
}
