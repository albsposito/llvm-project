define void @f(ptr %a, ptr %b, ptr %c) {
  %vb = load <2 x bfloat>, ptr %b, align 2
  %vc = load <2 x bfloat>, ptr %c, align 2
  %m = fmul <2 x bfloat> %vb, %vc
  store <2 x bfloat> %m, ptr %a, align 2
  ret void
}
