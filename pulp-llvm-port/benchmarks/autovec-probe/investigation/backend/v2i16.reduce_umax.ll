declare i16 @llvm.vector.reduce.umax.v2i16(<2 x i16>)
define i16 @f(<2 x i16> %a) {
  %r = call i16 @llvm.vector.reduce.umax.v2i16(<2 x i16> %a)
  ret i16 %r
}
