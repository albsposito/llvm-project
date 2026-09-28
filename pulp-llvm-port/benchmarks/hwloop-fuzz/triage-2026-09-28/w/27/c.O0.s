	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	addi	sp, sp, -64
	sw	ra, 60(sp)                      # 4-byte Folded Spill
	sw	s0, 56(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 64
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	sw	a4, -28(s0)
	sw	a5, -32(s0)
	li	a0, 1
	sw	a0, -36(s0)
	li	a0, 2
	sw	a0, -40(s0)
	li	a0, 3
	sw	a0, -44(s0)
	li	a0, 0
	sw	a0, -48(s0)
	j	.LBB0_1
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -48(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_4
	j	.LBB0_2
.LBB0_2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a1, -16(s0)
	lw	a0, -40(s0)
	addi	a0, a0, 51
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	slli	a0, a0, 1
	lw	a2, -36(s0)
	addi	a2, a2, 62
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a1, a1, a0
	slli	a0, a1, 3
	sub	a0, a0, a1
	lw	a1, -20(s0)
	lw	a2, -48(s0)
	addi	a2, a2, 8
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	lw	a0, -44(s0)
	addi	a0, a0, 73
	sw	a0, -44(s0)
	j	.LBB0_3
.LBB0_3:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -48(s0)
	addi	a0, a0, 1
	sw	a0, -48(s0)
	j	.LBB0_1
.LBB0_4:                                # %for.end
	li	a0, 0
	sw	a0, -52(s0)
	j	.LBB0_5
.LBB0_5:                                # %for.cond11
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_7 Depth 2
	lw	a0, -52(s0)
	lw	a1, -24(s0)
	addi	a1, a1, 1
	bgeu	a0, a1, .LBB0_12
	j	.LBB0_6
.LBB0_6:                                # %for.body14
                                        #   in Loop: Header=BB0_5 Depth=1
	lw	a1, -12(s0)
	lw	a0, -44(s0)
	addi	a2, a0, 32
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	slli	a1, a1, 1
	xor	a1, a1, a0
	add	a0, a0, a1
	sw	a0, -44(s0)
	li	a0, 0
	sw	a0, -56(s0)
	j	.LBB0_7
.LBB0_7:                                # %for.cond20
                                        #   Parent Loop BB0_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a0, -56(s0)
	lw	a1, -32(s0)
	bgeu	a0, a1, .LBB0_10
	j	.LBB0_8
.LBB0_8:                                # %for.body22
                                        #   in Loop: Header=BB0_7 Depth=2
	lw	a0, -40(s0)
	addi	a0, a0, 19
	sw	a0, -40(s0)
	j	.LBB0_9
.LBB0_9:                                # %for.inc24
                                        #   in Loop: Header=BB0_7 Depth=2
	lw	a0, -56(s0)
	addi	a0, a0, 1
	sw	a0, -56(s0)
	j	.LBB0_7
.LBB0_10:                               # %for.end26
                                        #   in Loop: Header=BB0_5 Depth=1
	j	.LBB0_11
.LBB0_11:                               # %for.inc27
                                        #   in Loop: Header=BB0_5 Depth=1
	lw	a0, -52(s0)
	addi	a0, a0, 1
	sw	a0, -52(s0)
	j	.LBB0_5
.LBB0_12:                               # %for.end29
	li	a0, 0
	sw	a0, -60(s0)
	j	.LBB0_13
.LBB0_13:                               # %for.cond31
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -60(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_16
	j	.LBB0_14
.LBB0_14:                               # %for.body33
                                        #   in Loop: Header=BB0_13 Depth=1
	lw	a1, -16(s0)
	lw	a0, -40(s0)
	addi	a2, a0, 53
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	sw	a0, -40(s0)
	j	.LBB0_15
.LBB0_15:                               # %for.inc38
                                        #   in Loop: Header=BB0_13 Depth=1
	lw	a0, -60(s0)
	addi	a0, a0, 1
	sw	a0, -60(s0)
	j	.LBB0_13
.LBB0_16:                               # %for.end40
	lw	a0, -36(s0)
	lw	a1, -40(s0)
	xor	a0, a0, a1
	lw	a1, -44(s0)
	xor	a0, a0, a1
	lw	ra, 60(sp)                      # 4-byte Folded Reload
	lw	s0, 56(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 64
	ret
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
