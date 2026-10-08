declare <2 x half> @llvm.sqrt.v2f16(<2 x half>)
define <2 x half> @f(<2 x half> %a) {
  %r = call <2 x half> @llvm.sqrt.v2f16(<2 x half> %a)
  ret <2 x half> %r
}
