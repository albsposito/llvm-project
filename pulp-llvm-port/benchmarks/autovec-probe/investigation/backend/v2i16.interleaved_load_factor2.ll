define <2 x i16> @f(ptr %p) {
  %w = load <4 x i16>, ptr %p, align 2
  %e = shufflevector <4 x i16> %w, <4 x i16> poison, <2 x i32> <i32 0, i32 2>
  %o = shufflevector <4 x i16> %w, <4 x i16> poison, <2 x i32> <i32 1, i32 3>
  %r = add <2 x i16> %e, %o
  ret <2 x i16> %r
}
