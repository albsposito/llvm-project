	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	beqz	a4, .LBB0_5
# %bb.1:                                # %for.body.lr.ph
	li	t0, 73
	addi	a6, a4, 8
	li	a7, 8
	sub	t1, a6, a7
	mul	t0, a4, t0
	.p2align	2
# %bb.15:                               # %for.body.lr.ph
	lp.setup	x0, t1, .LBB0_12
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lw	t1, 212(a1)
	lw	a4, 252(a1)
	slli	t1, t1, 1
	add	t1, t1, a4
	slli	a4, t1, 3
	sub	t1, a4, t1
	andi	a4, a7, 63
	slli	a4, a4, 2
	add	a4, a4, a2
	addi	a7, a7, 1
.LBB0_12:                               #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	sw	t1, 0(a4)
# %bb.3:                                # %for.cond11.preheader.loopexit
	addi	a6, t0, 3
	addi	a2, a3, 1
	bnez	a2, .LBB0_6
.LBB0_4:
	li	a4, 2
	j	.LBB0_8
.LBB0_5:
	li	a6, 3
	addi	a2, a3, 1
	beqz	a2, .LBB0_4
.LBB0_6:                                # %for.body15.lr.ph
	li	a4, 19
	mul	a7, a5, a4
	li	a4, 2
	.p2align	2
# %bb.16:                               # %for.body15.lr.ph
	lp.setup	x0, a2, .LBB0_13
.LBB0_7:                                # Block address taken
                                        # %for.body15
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	andi	a5, a6, 63
	xori	a5, a5, 32
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	slli	a5, a5, 1
	xor	a5, a5, a6
	add	a6, a6, a5
.LBB0_13:                               #   in Loop: Header=BB0_7 Depth=1
                                        # Label of block must be emitted
	add	a4, a4, a7
.LBB0_8:                                # %for.cond33.preheader
	beqz	a3, .LBB0_11
# %bb.9:
	lp.setup	x0, a3, .LBB0_14
.LBB0_10:                               # Block address taken
                                        # %for.body36
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	addi	a0, a4, 53
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
.LBB0_14:                               #   in Loop: Header=BB0_10 Depth=1
                                        # Label of block must be emitted
	add	a4, a4, a0
.LBB0_11:                               # %for.cond.cleanup35
	xor	a0, a6, a4
	xori	a0, a0, 1
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
