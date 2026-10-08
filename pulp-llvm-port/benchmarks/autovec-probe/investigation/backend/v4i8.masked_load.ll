declare <4 x i8> @llvm.masked.load.v4i8.p0(ptr, i32, <4 x i1>, <4 x i8>)
define <4 x i8> @f(ptr %p, <4 x i1> %m) {
  %r = call <4 x i8> @llvm.masked.load.v4i8.p0(ptr %p, i32 1, <4 x i1> %m, <4 x i8> poison)
  ret <4 x i8> %r
}
