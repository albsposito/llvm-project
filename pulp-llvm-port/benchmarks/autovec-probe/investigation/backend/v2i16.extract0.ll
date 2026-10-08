define i16 @f(<2 x i16> %a) {
  %r = extractelement <2 x i16> %a, i32 0
  ret i16 %r
}
