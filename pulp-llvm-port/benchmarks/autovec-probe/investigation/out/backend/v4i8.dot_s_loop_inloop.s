	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"v4i8.dot_s_loop_inloop.ll"
	.text
	.globl	f                               # -- Begin function f
	.p2align	1
	.type	f,@function
f:                                      # @f
	.cfi_startproc
# %bb.0:                                # %entry
	addi	a2, a2, -4
	andi	a2, a2, -4
	add	a2, a2, a1
	addi	a6, a2, 4
	sub	a2, a6, a1
	srli	a4, a2, 2
	li	a2, 0
	.p2align	2
# %bb.4:                                # %entry
	lp.setup	x0, a4, .LBB0_3
.LBB0_1:                                # Block address taken
                                        # %vector.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lw	a4, 4(a0!)
	p.lw	a5, 4(a1!)
	pv.extract.b	a7, a4, 2
	pv.extract.b	t0, a4, 3
	pv.extract.b	t2, a4, 1
	pv.extract.b	a4, a4, 0
	pv.extract.b	t1, a5, 2
	pv.extract.b	t3, a5, 3
	pv.extract.b	a3, a5, 1
	pv.extract.b	a5, a5, 0
	mul	a4, a4, a5
	mul	a3, t2, a3
	p.mac	a3, t0, t3
	p.mac	a4, a7, t1
	add	a3, a3, a4
.LBB0_3:                                #   in Loop: Header=BB0_1 Depth=1
                                        # Label of block must be emitted
	add	a2, a2, a3
# %bb.2:                                # %exit
	mv	a0, a2
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
