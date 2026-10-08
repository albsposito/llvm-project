declare bfloat @llvm.vector.reduce.fadd.v2bf16(bfloat, <2 x bfloat>)
define bfloat @f(<2 x bfloat> %a) {
  %r = call reassoc bfloat @llvm.vector.reduce.fadd.v2bf16(bfloat 0.0, <2 x bfloat> %a)
  ret bfloat %r
}
