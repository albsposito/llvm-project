define <4 x i8> @f(ptr %p) {
  %r = load <4 x i8>, ptr %p, align 1
  ret <4 x i8> %r
}
