	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"v2f16.load_fmul_store.ll"
	.text
	.globl	f                               # -- Begin function f
	.p2align	1
	.type	f,@function
f:                                      # @f
	.cfi_startproc
# %bb.0:
	lh	a3, 0(a1)
	lh	a1, 2(a1)
	lh	a4, 0(a2)
	lh	a2, 2(a2)
	fmul.h	a3, a3, a4
	fmul.h	a1, a1, a2
	sh	a3, 0(a0)
	sh	a1, 2(a0)
	ret
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
