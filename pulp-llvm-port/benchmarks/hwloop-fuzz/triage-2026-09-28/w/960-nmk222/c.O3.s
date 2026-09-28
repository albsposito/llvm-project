	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	addi	sp, sp, -32
	sw	s0, 28(sp)                      # 4-byte Folded Spill
	sw	s1, 24(sp)                      # 4-byte Folded Spill
	sw	s2, 20(sp)                      # 4-byte Folded Spill
	sw	s3, 16(sp)                      # 4-byte Folded Spill
	sw	s4, 12(sp)                      # 4-byte Folded Spill
	sw	s5, 8(sp)                       # 4-byte Folded Spill
	beqz	a5, .LBB0_8
# %bb.1:                                # %for.cond1.preheader.lr.ph
	p.beqimm	a3, -1, .LBB0_9
# %bb.2:                                # %for.cond1.preheader.lr.ph
	bnez	a3, .LBB0_10
# %bb.3:                                # %for.cond1.preheader.us.preheader
	addi	a7, a3, 2
	li	t0, 1
	li	s5, 3
	li	t1, 21
	li	t2, 25
	sub	s1, a5, a3
	mv	t3, a3
	li	a6, 1
	.p2align	2
# %bb.32:                               # %for.cond1.preheader.us.preheader
	lp.setup	x1, s1, .LBB0_26
.LBB0_4:                                # %for.cond1.preheader.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
	addi	a4, t3, 4
	sub	t4, a7, t0
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	t5, a1, a4
	li	s0, 1
	.p2align	2
# %bb.33:                               # %for.cond1.preheader.us
                                        #   in Loop: Header=BB0_4 Depth=1
	lp.setup	x0, t4, .LBB0_27
.LBB0_5:                                # Block address taken
                                        # %if.else109.us352
                                        #   Parent Loop BB0_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	andi	a4, s0, 63
	lw	s1, 80(a0)
	slli	a4, a4, 2
	add	a4, a4, a0
	lw	a4, 0(a4)
	mul	s1, s1, t1
	sw	s1, 148(a2)
	lw	s1, 0(t5)
	andi	a4, a4, 1
	sll	s5, s5, a4
	mul	a4, s1, t2
	xor	a4, a4, a6
	addi	s0, s0, 1
.LBB0_27:                               #   in Loop: Header=BB0_5 Depth=2
                                        # Label of block must be emitted
	add	a6, a6, a4
.LBB0_6:                                # Block address taken
                                        # %for.cond1.for.cond.cleanup3_crit_edge.split.split.us371
                                        #   in Loop: Header=BB0_4 Depth=1
                                        # Label of block must be emitted
.LBB0_26:                               #   in Loop: Header=BB0_4 Depth=1
                                        # Label of block must be emitted
	addi	t3, t3, 1
# %bb.7:                                # %for.cond202.preheader
	bnez	a3, .LBB0_23
	j	.LBB0_25
.LBB0_8:
	li	s5, 3
	li	a6, 1
	bnez	a3, .LBB0_23
	j	.LBB0_25
.LBB0_9:
	li	a6, 1
	li	s5, 3
	j	.LBB0_23
.LBB0_10:                               # %for.cond1.preheader.us.us.us.preheader
	li	a7, 0
	li	a6, 1
	li	s5, 3
	li	t0, 21
	li	t1, 25
	li	t2, 94
	.p2align	2
# %bb.34:                               # %for.cond1.preheader.us.us.us.preheader
	lp.setup	x1, a5, .LBB0_28
.LBB0_11:                               # %for.cond1.preheader.us.us.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_12 Depth 2
                                        #       Child Loop BB0_14 Depth 3
                                        #       Child Loop BB0_17 Depth 3
	li	t3, 0
	addi	s1, a7, 4
	addi	s0, a7, 17
	andi	s1, s1, 63
	andi	s0, s0, 63
	slli	t4, s1, 2
	slli	t5, s0, 2
	add	t4, t4, a1
	add	t5, t5, a0
.LBB0_12:                               # %if.else109.us.us.us.us.us
                                        #   Parent Loop BB0_11 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_14 Depth 3
                                        #       Child Loop BB0_17 Depth 3
	mv	t6, t3
	addi	t3, t3, 1
	andi	s0, t3, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lbu	s0, 0(s0)
	andi	s0, s0, 1
	bnez	s0, .LBB0_15
# %bb.13:                               #   in Loop: Header=BB0_12 Depth=2
	mv	s0, a3
.LBB0_14:                               # %for.body125.us.us.us.us.us
                                        #   Parent Loop BB0_11 Depth=1
                                        #     Parent Loop BB0_12 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	addi	s0, s0, -1
	slli	s5, s5, 1
	bnez	s0, .LBB0_14
	j	.LBB0_16
.LBB0_15:                               # %if.then116.us.us.us.us.us
                                        #   in Loop: Header=BB0_12 Depth=2
	slli	s5, s5, 1
.LBB0_16:                               # %if.end132.us.us.us.us.us
                                        #   in Loop: Header=BB0_12 Depth=2
	lw	s2, 80(a0)
	addi	s1, t6, 42
	addi	s0, t6, 60
	andi	s1, s1, 63
	andi	s3, s0, 63
	mul	s0, s2, t0
	sw	s0, 148(a2)
	lw	s0, 0(t4)
	slli	s1, s1, 2
	slli	s4, s3, 2
	add	s3, a0, s1
	mul	s0, s0, t1
	xor	s2, s0, a6
	add	s4, s4, a2
	mv	s0, a3
	.p2align	2
# %bb.35:                               # %if.end132.us.us.us.us.us
                                        #   in Loop: Header=BB0_12 Depth=2
	lp.setup	x0, a3, .LBB0_29
.LBB0_17:                               # %for.body154.us.us.us.us.us
                                        #   Parent Loop BB0_11 Depth=1
                                        #     Parent Loop BB0_12 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lbu	s1, 0(t5)
	andi	s1, s1, 1
	bnez	s1, .LBB0_19
# %bb.18:                               # %if.end171.us.us.us.us.us
                                        #   in Loop: Header=BB0_17 Depth=3
	lw	s1, 160(a0)
	lw	a4, 0(s3)
	add	a4, a4, s1
	slli	s1, a4, 1
	add	a4, a4, s1
	andi	a4, a4, 7
	p.beqimm	a4, 2, .LBB0_20
.LBB0_19:                               # %if.end185.us.us.us.us.us
                                        #   in Loop: Header=BB0_17 Depth=3
	slli	s5, s5, 1
	sw	t2, 0(s4)
.LBB0_20:                               # Block address taken
                                        # %for.inc192.us.us.us.us.us
                                        #   in Loop: Header=BB0_17 Depth=3
                                        # Label of block must be emitted
.LBB0_29:                               #   in Loop: Header=BB0_17 Depth=3
                                        # Label of block must be emitted
	addi	s0, s0, -1
# %bb.21:                               # %for.cond151.for.cond1.loopexit_crit_edge.us.us.us.us.us
                                        #   in Loop: Header=BB0_12 Depth=2
	add	a6, a6, s2
	bne	t6, a3, .LBB0_12
.LBB0_22:                               # Block address taken
                                        # %for.cond1.for.cond.cleanup3_crit_edge.split.us.us.us.split.us.us
                                        #   in Loop: Header=BB0_11 Depth=1
                                        # Label of block must be emitted
.LBB0_28:                               #   in Loop: Header=BB0_11 Depth=1
                                        # Label of block must be emitted
	addi	a7, a7, 1
.LBB0_23:                               # %for.body205.preheader
	lp.setup	x0, a3, .LBB0_30
.LBB0_31:
	nop
	nop
.LBB0_24:                               # Block address taken
                                        # %for.body205
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
.LBB0_30:                               #   in Loop: Header=BB0_24 Depth=1
                                        # Label of block must be emitted
	slli	s5, s5, 1
.LBB0_25:                               # %for.cond.cleanup204
	xor	a0, a6, s5
	xori	a0, a0, 2
	lw	s0, 28(sp)                      # 4-byte Folded Reload
	lw	s1, 24(sp)                      # 4-byte Folded Reload
	lw	s2, 20(sp)                      # 4-byte Folded Reload
	lw	s3, 16(sp)                      # 4-byte Folded Reload
	lw	s4, 12(sp)                      # 4-byte Folded Reload
	lw	s5, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Ltmp2:                                 # Address of block that was removed by CodeGen
.Ltmp3:                                 # Address of block that was removed by CodeGen
.Ltmp4:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git e21026f4903f1dfc75f7c78ee1d4f4960f873693)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
