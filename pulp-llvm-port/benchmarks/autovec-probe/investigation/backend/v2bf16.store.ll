define void @f(ptr %p, <2 x bfloat> %v) {
  store <2 x bfloat> %v, ptr %p, align 2
  ret void
}
