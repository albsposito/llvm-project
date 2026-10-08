	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	dot16                           # -- Begin function dot16
	.p2align	1
	.type	dot16,@function
dot16:                                  # @dot16
# %bb.0:                                # %entry
	blez	a2, .LBB0_3
# %bb.1:                                # %for.body.preheader
	mv	a6, a0
	p.bneimm	a2, 1, .LBB0_4
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
	addi	a3, a3, -2
	and	a7, a2, a3
	slli	a5, a7, 1
	add	t1, a5, a1
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
.LBB0_10:                               #   in Loop: Header=BB0_5 Depth=1
                                        # Label of block must be emitted
	pv.sdotsp.h	a0, a5, t0
# %bb.6:                                # %middle.block
	beq	a2, a7, .LBB0_9
.LBB0_7:                                # %for.body.preheader9
	slli	a3, a7, 1
	slli	a4, a2, 1
	add	a2, a1, a3
	add	a1, a1, a4
	sub	a4, a1, a2
	srli	a4, a4, 1
	add	a3, a3, a6
	.p2align	2
# %bb.13:                               # %for.body.preheader9
	lp.setup	x0, a4, .LBB0_11
.LBB0_8:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a4, 2(a3!)
	p.lh	a5, 2(a2!)
.LBB0_11:                               #   in Loop: Header=BB0_8 Depth=1
                                        # Label of block must be emitted
	p.mac	a0, a5, a4
.LBB0_9:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	dot16, .Lfunc_end0-dot16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
