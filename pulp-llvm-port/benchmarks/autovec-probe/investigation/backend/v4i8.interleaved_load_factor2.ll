define <4 x i8> @f(ptr %p) {
  %w = load <8 x i8>, ptr %p, align 1
  %e = shufflevector <8 x i8> %w, <8 x i8> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %o = shufflevector <8 x i8> %w, <8 x i8> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %r = add <4 x i8> %e, %o
  ret <4 x i8> %r
}
