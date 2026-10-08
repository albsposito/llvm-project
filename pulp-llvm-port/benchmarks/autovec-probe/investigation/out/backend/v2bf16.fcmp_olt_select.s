	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"v2bf16.fcmp_olt_select.ll"
	.text
	.globl	f                               # -- Begin function f
	.p2align	1
	.type	f,@function
f:                                      # @f
	.cfi_startproc
# %bb.0:
                                        # kill: def $x13_w killed $x13_w def $x13
                                        # kill: def $x12_w killed $x12_w def $x12
                                        # kill: def $x11_w killed $x11_w def $x11
                                        # kill: def $x10_w killed $x10_w def $x10
	slli	a6, a2, 16
	slli	a5, a3, 16
	slli	a4, a1, 16
	flt.s	a5, a4, a5
	slli	a4, a0, 16
	flt.s	a4, a4, a6
	bnez	a5, .LBB0_2
# %bb.1:
	mv	a1, a3
.LBB0_2:
	slli	a1, a1, 16
	bnez	a4, .LBB0_4
# %bb.3:
	mv	a0, a2
.LBB0_4:
	p.bset	a0, a0, 15, 16
	pv.extract.h	a1, a1, 1
	p.bset	a1, a1, 15, 16
                                        # kill: def $x10_w killed $x10_w killed $x10
                                        # kill: def $x11_w killed $x11_w killed $x11
	ret
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
