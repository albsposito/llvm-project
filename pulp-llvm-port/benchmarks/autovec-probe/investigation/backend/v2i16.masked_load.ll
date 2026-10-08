declare <2 x i16> @llvm.masked.load.v2i16.p0(ptr, i32, <2 x i1>, <2 x i16>)
define <2 x i16> @f(ptr %p, <2 x i1> %m) {
  %r = call <2 x i16> @llvm.masked.load.v2i16.p0(ptr %p, i32 2, <2 x i1> %m, <2 x i16> poison)
  ret <2 x i16> %r
}
