define half @f(<2 x half> %a) {
  %r = extractelement <2 x half> %a, i32 1
  ret half %r
}
