define i32 @f(<2 x i16> %a) {
  %e = extractelement <2 x i16> %a, i32 1
  %r = sext i16 %e to i32
  ret i32 %r
}
