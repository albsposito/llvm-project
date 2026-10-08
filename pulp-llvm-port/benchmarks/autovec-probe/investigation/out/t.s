	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops.c"
	.text
	.globl	add16                           # -- Begin function add16
	.p2align	1
	.type	add16,@function
add16:                                  # @add16
# %bb.0:                                # %entry
	blez	a3, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	add	a4, a4, a5
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB0_2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	add16, .Lfunc_end0-add16
                                        # -- End function
	.globl	add8                            # -- Begin function add8
	.p2align	1
	.type	add8,@function
add8:                                   # @add8
# %bb.0:                                # %entry
	blez	a3, .LBB1_3
# %bb.1:                                # %for.body.preheader
	add	a3, a3, a0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a4, 1(a1!)
	p.lbu	a5, 1(a2!)
	add	a4, a4, a5
	p.sb	a4, 1(a0!)
	bne	a0, a3, .LBB1_2
.LBB1_3:                                # %for.cond.cleanup
	ret
.Lfunc_end1:
	.size	add8, .Lfunc_end1-add8
                                        # -- End function
	.globl	dot16                           # -- Begin function dot16
	.p2align	1
	.type	dot16,@function
dot16:                                  # @dot16
# %bb.0:                                # %entry
	blez	a2, .LBB2_4
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a3, a1, a2
	sub	a2, a3, a1
	srli	a4, a2, 1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB2_5
.LBB2_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a4, 2(a0!)
	p.lh	a5, 2(a1!)
.LBB2_5:                                #   in Loop: Header=BB2_2 Depth=1
                                        # Label of block must be emitted
	p.mac	a2, a5, a4
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.LBB2_4:
	li	a0, 0
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end2:
	.size	dot16, .Lfunc_end2-dot16
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
