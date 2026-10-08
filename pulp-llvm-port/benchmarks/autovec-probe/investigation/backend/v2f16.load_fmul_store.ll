define void @f(ptr %a, ptr %b, ptr %c) {
  %vb = load <2 x half>, ptr %b, align 2
  %vc = load <2 x half>, ptr %c, align 2
  %m = fmul <2 x half> %vb, %vc
  store <2 x half> %m, ptr %a, align 2
  ret void
}
