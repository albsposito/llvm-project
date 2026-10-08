	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	sad8                            # -- Begin function sad8
	.p2align	1
	.type	sad8,@function
sad8:                                   # @sad8
# %bb.0:                                # %entry
	blez	a2, .LBB0_3
# %bb.1:                                # %for.body.preheader
	mv	a6, a0
	li	a0, 4
	bgeu	a2, a0, .LBB0_4
# %bb.2:
	li	a0, 0
	li	a7, 0
	j	.LBB0_7
.LBB0_3:
	li	a0, 0
	ret
.LBB0_4:                                # %vector.ph
	li	a0, 0
	lui	a3, 524288
	addi	a3, a3, -4
	and	a7, a2, a3
	add	t1, a7, a1
	sub	a3, t1, a1
	srli	t0, a3, 2
	mv	a3, a6
	mv	a4, a1
	.p2align	2
# %bb.12:                               # %vector.ph
	lp.setup	x0, t0, .LBB0_10
.LBB0_5:                                # Block address taken
                                        # %vector.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lw	t0, 4(a3!)
	p.lw	a5, 4(a4!)
	pv.minu.b	t2, t0, a5
	pv.maxu.b	a5, t0, a5
	pv.sub.b	a5, a5, t2
	pv.extractu.b	t0, a5, 2
	pv.extractu.b	t2, a5, 0
	pv.extractu.b	t3, a5, 3
	pv.extractu.b	a5, a5, 1
	add	a5, a5, t3
	add	t0, t0, t2
	add	a5, a5, t0
.LBB0_10:                               #   in Loop: Header=BB0_5 Depth=1
                                        # Label of block must be emitted
	add	a0, a0, a5
# %bb.6:                                # %middle.block
	beq	a2, a7, .LBB0_9
.LBB0_7:                                # %for.body.preheader11
	add	a5, a1, a7
	add	a1, a1, a2
	sub	a2, a1, a5
	add	a6, a6, a7
	.p2align	2
# %bb.13:                               # %for.body.preheader11
	lp.setup	x0, a2, .LBB0_11
.LBB0_8:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lbu	a2, 1(a6!)
	p.lbu	a3, 1(a5!)
	p.minu	a4, a2, a3
	p.maxu	a2, a2, a3
	sub	a2, a2, a4
.LBB0_11:                               #   in Loop: Header=BB0_8 Depth=1
                                        # Label of block must be emitted
	add	a0, a0, a2
.LBB0_9:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	sad8, .Lfunc_end0-sad8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
