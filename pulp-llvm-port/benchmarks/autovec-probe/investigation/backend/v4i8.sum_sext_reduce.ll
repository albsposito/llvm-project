declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>)
define i32 @f(<4 x i8> %a) {
  %ea = sext <4 x i8> %a to <4 x i32>
  %r = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %ea)
  ret i32 %r
}
