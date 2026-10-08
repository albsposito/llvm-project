define i32 @f(<4 x i8> %a) {
  %e = extractelement <4 x i8> %a, i32 3
  %r = sext i8 %e to i32
  ret i32 %r
}
