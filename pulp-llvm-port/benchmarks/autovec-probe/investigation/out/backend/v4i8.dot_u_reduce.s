	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"v4i8.dot_u_reduce.ll"
	.text
	.globl	f                               # -- Begin function f
	.p2align	1
	.type	f,@function
f:                                      # @f
	.cfi_startproc
# %bb.0:
	pv.extractu.b	a6, a0, 2
	pv.extractu.b	a7, a0, 3
	pv.extractu.b	a4, a0, 1
	pv.extractu.b	a0, a0, 0
	pv.extractu.b	a5, a1, 2
	pv.extractu.b	a2, a1, 3
	pv.extractu.b	a3, a1, 1
	pv.extractu.b	a1, a1, 0
	mul	a0, a0, a1
	mul	a1, a4, a3
	p.mac	a1, a7, a2
	p.mac	a0, a6, a5
	add	a0, a0, a1
	ret
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
