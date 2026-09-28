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
# %bb.17:                               # %for.body.preheader
	lp.setup	x0, a7, .LBB0_13
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	andi	a1, a5, 63
	slli	a1, a1, 2
	add	a1, a1, a2
	addi	a5, a5, 1
.LBB0_13:                               #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	sw	a6, 0(a1)
.LBB0_3:                                # %for.cond2.preheader
	addi	a2, a3, 1
	bnez	a2, .LBB0_5
# %bb.4:
	li	a0, 2
	li	t0, 1
	li	a2, 3
	bnez	a4, .LBB0_10
	j	.LBB0_12
.LBB0_5:                                # %for.body6.lr.ph
	lw	a7, 164(a0)
	lw	a5, 56(a0)
	slli	a1, a3, 6
	sub	a6, a1, a3
	li	t0, 1
	add	a5, a5, a7
	andi	a5, a5, 8
	li	a3, 55
	.p2align	2
# %bb.18:                               # %for.body6.lr.ph
	lp.setup	x0, a2, .LBB0_14
.LBB0_7:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	beqz	a5, .LBB0_6
# %bb.8:                                # %if.then
                                        #   in Loop: Header=BB0_7 Depth=1
	andi	a1, a3, 63
	slli	a1, a1, 2
	add	a1, a1, a0
	lw	a1, 0(a1)
	add	t0, t0, a1
.LBB0_6:                                # Block address taken
                                        # %for.inc20
                                        #   in Loop: Header=BB0_7 Depth=1
                                        # Label of block must be emitted
.LBB0_14:                               #   in Loop: Header=BB0_7 Depth=1
                                        # Label of block must be emitted
	addi	a3, a3, 1
	j	.LBB0_9
.LBB0_9:                                # %for.cond24.preheader.loopexit
	addi	a0, a6, 65
	li	a2, 3
	beqz	a4, .LBB0_12
.LBB0_10:                               # %for.body27.preheader
	srli	a3, a0, 31
	.p2align	2
# %bb.19:                               # %for.body27.preheader
	lp.setup	x0, a4, .LBB0_15
.LBB0_16:
	nop
.LBB0_11:                               # Block address taken
                                        # %for.body27
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	slli	a2, a2, 1
.LBB0_15:                               #   in Loop: Header=BB0_11 Depth=1
                                        # Label of block must be emitted
	or	a2, a2, a3
.LBB0_12:                               # %for.cond.cleanup26
	xor	a0, t0, a0
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
