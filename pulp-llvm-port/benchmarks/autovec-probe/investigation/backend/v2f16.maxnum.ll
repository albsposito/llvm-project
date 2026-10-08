declare <2 x half> @llvm.maxnum.v2f16(<2 x half>, <2 x half>)
define <2 x half> @f(<2 x half> %a, <2 x half> %b) {
  %r = call <2 x half> @llvm.maxnum.v2f16(<2 x half> %a, <2 x half> %b)
  ret <2 x half> %r
}
