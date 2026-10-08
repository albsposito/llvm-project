declare void @llvm.masked.store.v2i16.p0(<2 x i16>, ptr, i32, <2 x i1>)
define void @f(ptr %p, <2 x i16> %v, <2 x i1> %m) {
  call void @llvm.masked.store.v2i16.p0(<2 x i16> %v, ptr %p, i32 2, <2 x i1> %m)
  ret void
}
