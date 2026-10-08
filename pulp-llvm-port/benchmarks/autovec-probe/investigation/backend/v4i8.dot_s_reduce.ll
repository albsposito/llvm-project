declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>)
define i32 @f(<4 x i8> %a, <4 x i8> %b) {
  %ea = sext <4 x i8> %a to <4 x i32>
  %eb = sext <4 x i8> %b to <4 x i32>
  %m = mul nsw <4 x i32> %ea, %eb
  %r = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %m)
  ret i32 %r
}
