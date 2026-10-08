declare i32 @llvm.vector.reduce.add.v2i32(<2 x i32>)
define i32 @f(<2 x i16> %a) {
  %ea = sext <2 x i16> %a to <2 x i32>
  %r = call i32 @llvm.vector.reduce.add.v2i32(<2 x i32> %ea)
  ret i32 %r
}
