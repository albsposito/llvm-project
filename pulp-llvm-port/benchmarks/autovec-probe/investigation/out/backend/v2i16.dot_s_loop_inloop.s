	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"v2i16.dot_s_loop_inloop.ll"
	.text
	.globl	f                               # -- Begin function f
	.p2align	1
	.type	f,@function
f:                                      # @f
	.cfi_startproc
# %bb.0:                                # %entry
	li	a3, 0
.LBB0_1:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	a4, 4(a0!)
	p.lw	a5, 4(a1!)
	addi	a2, a2, -2
	pv.sdotsp.h	a3, a4, a5
	bnez	a2, .LBB0_1
# %bb.2:                                # %exit
	mv	a0, a3
	ret
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
