declare void @llvm.masked.store.v4i8.p0(<4 x i8>, ptr, i32, <4 x i1>)
define void @f(ptr %p, <4 x i8> %v, <4 x i1> %m) {
  call void @llvm.masked.store.v4i8.p0(<4 x i8> %v, ptr %p, i32 1, <4 x i1> %m)
  ret void
}
