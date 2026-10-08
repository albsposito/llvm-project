	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"v4i8.ssub_sat.ll"
	.text
	.globl	f                               # -- Begin function f
	.p2align	1
	.type	f,@function
f:                                      # @f
	.cfi_startproc
# %bb.0:
	pv.extract.b	a2, a1, 2
	pv.extract.b	a3, a0, 2
	pv.extract.b	a4, a1, 3
	pv.extract.b	a5, a0, 3
	sub	a3, a3, a2
	pv.extract.b	a2, a1, 0
	sub	a5, a5, a4
	pv.extract.b	a4, a0, 0
	sub	a4, a4, a2
	pv.extract.b	a1, a1, 1
	pv.extract.b	a0, a0, 1
	sub	a1, a0, a1
	p.clip	a0, a3, 8
	p.clip	a2, a5, 8
	p.clip	a3, a4, 8
	pv.packhi.b	a0, a2, a0
	p.clip	a1, a1, 8
	pv.packlo.b	a0, a1, a3
	ret
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
