	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	beqz	a3, .LBB0_10
# %bb.1:                                # %for.body.lr.ph
	lbu	a0, 180(a0)
	andi	a0, a0, 7
	snez	a6, a0
	li	t1, 3
	mv	a5, a3
	.p2align	2
# %bb.17:                               # %for.body.lr.ph
	lp.setup	x0, a3, .LBB0_13
.LBB0_16:
	nop
	nop
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
.LBB0_13:                               #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	sll	t1, t1, a6
# %bb.3:                                # %for.cond4.preheader
	beqz	a4, .LBB0_11
.LBB0_4:                                # %for.body7.preheader
	addi	a6, a4, 9
	li	a5, 9
	sub	a7, a6, a5
	li	a4, 2
	.p2align	2
# %bb.18:                               # %for.body7.preheader
	lp.setup	x0, a7, .LBB0_14
.LBB0_5:                                # Block address taken
                                        # %for.body7
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	andi	a0, a5, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	addi	a5, a5, 1
.LBB0_14:                               #   in Loop: Header=BB0_5 Depth=1
                                        # Label of block must be emitted
	add	a4, a4, a0
# %bb.6:                                # %for.cond16.preheader
	beqz	a3, .LBB0_12
.LBB0_7:                                # %for.body19.lr.ph
	xori	a6, t1, 29
	addi	a7, a3, 63
	li	a5, 63
	sub	t0, a7, a5
	li	a3, 64
	.p2align	2
# %bb.19:                               # %for.body19.lr.ph
	lp.setup	x0, t0, .LBB0_15
.LBB0_8:                                # Block address taken
                                        # %for.body19
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	andi	a0, a3, 63
	andi	t0, a5, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	addi	a5, a5, 1
	slli	t0, t0, 2
	add	t0, t0, a2
	xor	a0, a0, a4
	sw	a0, 0(t0)
.LBB0_15:                               #   in Loop: Header=BB0_8 Depth=1
                                        # Label of block must be emitted
	add	a3, a3, a6
# %bb.9:                                # %for.cond.cleanup18.loopexit
	addi	a1, a3, -63
	xor	a0, t1, a1
	xor	a0, a0, a4
	ret
.LBB0_10:
	li	t1, 3
	bnez	a4, .LBB0_4
.LBB0_11:
	li	a4, 2
	bnez	a3, .LBB0_7
.LBB0_12:
	li	a1, 1
	xor	a0, t1, a1
	xor	a0, a0, a4
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
