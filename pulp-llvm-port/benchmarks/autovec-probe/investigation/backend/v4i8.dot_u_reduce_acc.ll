declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>)
define i32 @f(<4 x i8> %a, <4 x i8> %b, i32 %acc) {
  %ea = zext <4 x i8> %a to <4 x i32>
  %eb = zext <4 x i8> %b to <4 x i32>
  %m = mul nsw <4 x i32> %ea, %eb
  %r = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %m)
  %s = add i32 %r, %acc
  ret i32 %s
}
