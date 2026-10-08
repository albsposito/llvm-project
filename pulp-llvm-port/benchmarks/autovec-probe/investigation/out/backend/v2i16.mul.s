	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"v2i16.mul.ll"
	.text
	.globl	f                               # -- Begin function f
	.p2align	1
	.type	f,@function
f:                                      # @f
	.cfi_startproc
# %bb.0:
	pv.extract.h	a2, a1, 0
	pv.extract.h	a3, a0, 0
	pv.extract.h	a1, a1, 1
	pv.extract.h	a0, a0, 1
	mul	a2, a3, a2
	mul	a0, a0, a1
	pv.pack.h	a0, a0, a2
	ret
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
