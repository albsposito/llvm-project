	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	beqz	a4, .LBB0_3
# %bb.1:                                # %for.body.preheader
	addi	t0, a4, 48
	li	a5, 48
	sub	a7, t0, a5
	li	a6, 23
	.p2align	2
# %bb.16:                               # %for.body.preheader
	lp.setup	x0, a7, .LBB0_12
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	andi	a1, a5, 63
	slli	a1, a1, 2
	add	a1, a1, a2
	addi	a5, a5, 1
.LBB0_12:                               #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	sw	a6, 0(a1)
.LBB0_3:                                # %for.cond2.preheader
	li	a1, 1
	p.beqimm	a3, -1, .LBB0_8
# %bb.4:                                # %for.body6.lr.ph
	lw	a2, 164(a0)
	lw	a5, 56(a0)
	add	a2, a2, a5
	andi	a5, a2, 8
	slli	a2, a3, 6
	sub	a7, a2, a3
	beqz	a5, .LBB0_7
# %bb.5:                                # %for.body6.preheader
	addi	a3, a3, 56
	li	a5, 55
	sub	a6, a3, a5
	li	a1, 1
	.p2align	2
# %bb.17:                               # %for.body6.preheader
	lp.setup	x0, a6, .LBB0_13
.LBB0_6:                                # Block address taken
                                        # %for.body6
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	andi	a2, a5, 63
	slli	a2, a2, 2
	add	a2, a2, a0
	lw	a2, 0(a2)
	addi	a5, a5, 1
.LBB0_13:                               #   in Loop: Header=BB0_6 Depth=1
                                        # Label of block must be emitted
	add	a1, a1, a2
.LBB0_7:                                # %for.cond24.preheader.loopexit58
	addi	a0, a7, 65
	li	a2, 3
	bnez	a4, .LBB0_9
	j	.LBB0_11
.LBB0_8:
	li	a0, 2
	li	a2, 3
	beqz	a4, .LBB0_11
.LBB0_9:                                # %for.body27.preheader
	srli	a3, a0, 31
	.p2align	2
# %bb.18:                               # %for.body27.preheader
	lp.setup	x0, a4, .LBB0_14
.LBB0_15:
	nop
.LBB0_10:                               # Block address taken
                                        # %for.body27
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	slli	a2, a2, 1
.LBB0_14:                               #   in Loop: Header=BB0_10 Depth=1
                                        # Label of block must be emitted
	or	a2, a2, a3
.LBB0_11:                               # %for.cond.cleanup26
	xor	a0, a0, a1
	xor	a0, a0, a2
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Ltmp2:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
