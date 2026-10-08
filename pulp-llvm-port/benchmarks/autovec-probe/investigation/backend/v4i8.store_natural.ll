define void @f(ptr %p, <4 x i8> %v) {
  store <4 x i8> %v, ptr %p, align 1
  ret void
}
