declare i32 @llvm.vector.reduce.add.v2i32(<2 x i32>)
define i32 @f(<2 x i16> %a, <2 x i16> %b, i32 %acc) {
  %ea = zext <2 x i16> %a to <2 x i32>
  %eb = zext <2 x i16> %b to <2 x i32>
  %m = mul nsw <2 x i32> %ea, %eb
  %r = call i32 @llvm.vector.reduce.add.v2i32(<2 x i32> %m)
  %s = add i32 %r, %acc
  ret i32 %s
}
