define void @f(ptr %p, <2 x half> %v) {
  store <2 x half> %v, ptr %p, align 2
  ret void
}
