define i8 @f(<4 x i8> %a, i32 %i) {
  %r = extractelement <4 x i8> %a, i32 %i
  ret i8 %r
}
