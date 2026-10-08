declare half @llvm.vector.reduce.fadd.v2f16(half, <2 x half>)
define half @f(<2 x half> %a) {
  %r = call reassoc half @llvm.vector.reduce.fadd.v2f16(half 0.0, <2 x half> %a)
  ret half %r
}
