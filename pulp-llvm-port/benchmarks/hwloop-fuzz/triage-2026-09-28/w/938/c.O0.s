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
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	lw	a1, -48(s0)
	li	a0, 7
	bltu	a0, a1, .LBB0_8
	j	.LBB0_2
.LBB0_2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	li	a0, 0
	sw	a0, -52(s0)
	j	.LBB0_3
.LBB0_3:                                # %for.cond1
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a0, -52(s0)
	lw	a1, -28(s0)
	andi	a1, a1, 3
	bgeu	a0, a1, .LBB0_6
	j	.LBB0_4
.LBB0_4:                                # %for.body3
                                        #   in Loop: Header=BB0_3 Depth=2
	lw	a0, -16(s0)
	lw	a1, -36(s0)
	addi	a1, a1, 41
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -44(s0)
	add	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_5
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_3 Depth=2
	lw	a0, -52(s0)
	addi	a0, a0, 1
	sw	a0, -52(s0)
	j	.LBB0_3
.LBB0_6:                                # %for.end
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a1, -16(s0)
	lw	a0, -36(s0)
	addi	a2, a0, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a2, 0(a1)
	slli	a1, a2, 2
	add	a1, a1, a2
	lw	a2, -44(s0)
	xor	a1, a1, a2
	add	a0, a0, a1
	sw	a0, -36(s0)
	j	.LBB0_7
.LBB0_7:                                # %for.inc10
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -48(s0)
	addi	a0, a0, 1
	sw	a0, -48(s0)
	j	.LBB0_1
.LBB0_8:                                # %for.end12
	li	a0, 0
	sw	a0, -56(s0)
	j	.LBB0_9
.LBB0_9:                                # %for.cond14
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -56(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_12
	j	.LBB0_10
.LBB0_10:                               # %for.body16
                                        #   in Loop: Header=BB0_9 Depth=1
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_11
.LBB0_11:                               # %for.inc17
                                        #   in Loop: Header=BB0_9 Depth=1
	lw	a0, -56(s0)
	addi	a0, a0, 1
	sw	a0, -56(s0)
	j	.LBB0_9
.LBB0_12:                               # %for.end19
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
