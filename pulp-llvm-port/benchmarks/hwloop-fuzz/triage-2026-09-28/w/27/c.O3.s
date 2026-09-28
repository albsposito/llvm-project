	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	beqz	a4, .LBB0_8
# %bb.1:                                # %for.body.lr.ph
	li	t0, 73
	addi	a6, a4, 8
	li	a7, 8
	sub	t1, a6, a7
	mul	t0, a4, t0
	.p2align	2
# %bb.20:                               # %for.body.lr.ph
	lp.setup	x0, t1, .LBB0_16
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
.LBB0_16:                               #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	sw	t1, 0(a4)
# %bb.3:                                # %for.cond11.preheader.loopexit
	addi	a2, t0, 3
	p.beqimm	a3, -1, .LBB0_9
.LBB0_4:                                # %for.body15.lr.ph
	beqz	a5, .LBB0_10
# %bb.5:                                # %for.body15.us.preheader
	li	a4, 19
	mul	a4, a3, a4
	addi	a6, a4, 19
	addi	a4, a3, 1
	mul	a6, a5, a6
	.p2align	2
# %bb.21:                               # %for.body15.us.preheader
	lp.setup	x0, a4, .LBB0_17
.LBB0_6:                                # Block address taken
                                        # %for.body15.us
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	andi	a5, a2, 63
	xori	a5, a5, 32
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	slli	a5, a5, 1
	xor	a5, a5, a2
.LBB0_17:                               #   in Loop: Header=BB0_6 Depth=1
                                        # Label of block must be emitted
	add	a2, a2, a5
# %bb.7:                                # %for.cond33.preheader.loopexit81
	addi	a0, a6, 2
	bnez	a3, .LBB0_13
	j	.LBB0_15
.LBB0_8:
	li	a2, 3
	p.bneimm	a3, -1, .LBB0_4
.LBB0_9:
	li	a0, 2
	.p2align	2
# %bb.22:
	lp.setup	x0, a3, .LBB0_18
	j	.LBB0_14
.LBB0_10:                               # %for.body15.preheader
	addi	a4, a3, 1
.LBB0_11:                               # %for.body15
                                        # =>This Inner Loop Header: Depth=1
	andi	a5, a2, 63
	xori	a5, a5, 32
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	slli	a5, a5, 1
	xor	a5, a5, a2
	addi	a4, a4, -1
	add	a2, a2, a5
	bnez	a4, .LBB0_11
# %bb.12:
	li	a0, 2
	beqz	a3, .LBB0_15
.LBB0_13:                               # %for.body36.preheader
	lp.setup	x0, a3, .LBB0_19
.LBB0_14:                               # Block address taken
                                        # %for.body36
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	addi	a4, a0, 53
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a4, a4, a1
	lw	a4, 0(a4)
.LBB0_19:                               #   in Loop: Header=BB0_14 Depth=1
                                        # Label of block must be emitted
	addi	a3, a3, -1
.LBB0_18:                               #   in Loop: Header=BB0_14 Depth=1
                                        # Label of block must be emitted
	add	a0, a0, a4
.LBB0_15:                               # %for.cond.cleanup35
	xor	a0, a0, a2
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
