declare i8 @llvm.vector.reduce.umax.v4i8(<4 x i8>)
define i8 @f(<4 x i8> %a) {
  %r = call i8 @llvm.vector.reduce.umax.v4i8(<4 x i8> %a)
  ret i8 %r
}
