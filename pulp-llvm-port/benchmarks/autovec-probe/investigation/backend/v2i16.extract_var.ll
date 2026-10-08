define i16 @f(<2 x i16> %a, i32 %i) {
  %r = extractelement <2 x i16> %a, i32 %i
  ret i16 %r
}
