	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	sum8                            # -- Begin function sum8
	.p2align	1
	.type	sum8,@function
sum8:                                   # @sum8
# %bb.0:                                # %entry
	blez	a1, .LBB0_3
# %bb.1:                                # %for.body.preheader
	mv	t0, a0
	li	a0, 4
	bgeu	a1, a0, .LBB0_4
# %bb.2:
	li	a7, 0
	li	a0, 0
	j	.LBB0_7
.LBB0_3:
	li	a0, 0
	ret
.LBB0_4:                                # %vector.ph
	li	a0, 0
	lui	a3, 524288
	addi	a3, a3, -4
	and	a7, a1, a3
	add	t1, a7, t0
	sub	a5, t1, t0
	srli	a6, a5, 2
	mv	a5, t0
	.p2align	2
# %bb.12:                               # %vector.ph
	lp.setup	x0, a6, .LBB0_10
.LBB0_5:                                # Block address taken
                                        # %vector.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lw	a3, 4(a5!)
	pv.extract.b	a6, a3, 2
	pv.extract.b	a4, a3, 0
	pv.extract.b	a2, a3, 3
	pv.extract.b	a3, a3, 1
	add	a2, a2, a3
	add	a4, a4, a6
	add	a2, a2, a4
.LBB0_10:                               #   in Loop: Header=BB0_5 Depth=1
                                        # Label of block must be emitted
	add	a0, a0, a2
# %bb.6:                                # %middle.block
	beq	a1, a7, .LBB0_9
.LBB0_7:                                # %for.body.preheader7
	add	a3, t0, a7
	add	a1, a1, t0
	sub	a2, a1, a3
	.p2align	2
# %bb.13:                               # %for.body.preheader7
	lp.setup	x0, a2, .LBB0_11
.LBB0_8:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lb	a2, 1(a3!)
.LBB0_11:                               #   in Loop: Header=BB0_8 Depth=1
                                        # Label of block must be emitted
	add	a0, a0, a2
.LBB0_9:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	sum8, .Lfunc_end0-sum8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
