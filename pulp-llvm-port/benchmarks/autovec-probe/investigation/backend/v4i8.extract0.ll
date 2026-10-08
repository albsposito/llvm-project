define i8 @f(<4 x i8> %a) {
  %r = extractelement <4 x i8> %a, i32 0
  ret i8 %r
}
