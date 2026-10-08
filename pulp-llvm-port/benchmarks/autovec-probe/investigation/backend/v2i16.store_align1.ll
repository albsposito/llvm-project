define void @f(ptr %p, <2 x i16> %v) {
  store <2 x i16> %v, ptr %p, align 1
  ret void
}
