	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	max16r                          # -- Begin function max16r
	.p2align	1
	.type	max16r,@function
max16r:                                 # @max16r
# %bb.0:                                # %entry
	blez	a1, .LBB0_3
# %bb.1:                                # %for.body.preheader
	p.bneimm	a1, 1, .LBB0_4
# %bb.2:
	li	a6, 0
	lui	a2, 1048568
	j	.LBB0_7
.LBB0_3:
	lui	a0, 1048568
	ret
.LBB0_4:                                # %vector.ph
	lui	a2, 524288
	addi	a2, a2, -2
	and	a6, a1, a2
	slli	a4, a6, 1
	add	t0, a4, a0
	lui	a2, 1048568
	sub	a3, t0, a0
	srli	a7, a3, 2
	mv	a5, a0
	lui	a3, 1048568
	.p2align	2
# %bb.12:                               # %vector.ph
	lp.setup	x0, a7, .LBB0_10
.LBB0_5:                                # Block address taken
                                        # %vector.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lw	a4, 4(a5!)
	pv.extract.h	a7, a4, 0
	pv.extract.h	a4, a4, 1
	p.max	a3, a3, a4
.LBB0_10:                               #   in Loop: Header=BB0_5 Depth=1
                                        # Label of block must be emitted
	p.max	a2, a2, a7
# %bb.6:                                # %middle.block
	p.max	a2, a2, a3
	beq	a1, a6, .LBB0_9
.LBB0_7:                                # %for.body.preheader9
	slli	a6, a6, 1
	slli	a3, a1, 1
	add	a1, a0, a6
	add	a0, a0, a3
	sub	a3, a0, a1
	srli	a3, a3, 1
	.p2align	2
# %bb.13:                               # %for.body.preheader9
	lp.setup	x0, a3, .LBB0_11
.LBB0_8:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a3, 2(a1!)
.LBB0_11:                               #   in Loop: Header=BB0_8 Depth=1
                                        # Label of block must be emitted
	p.max	a2, a2, a3
.LBB0_9:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	max16r, .Lfunc_end0-max16r
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
