define bfloat @f(<2 x bfloat> %a) {
  %r = extractelement <2 x bfloat> %a, i32 1
  ret bfloat %r
}
