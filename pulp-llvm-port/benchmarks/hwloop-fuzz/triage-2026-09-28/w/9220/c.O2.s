	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	addi	sp, sp, -48
	sw	s0, 44(sp)                      # 4-byte Folded Spill
	sw	s1, 40(sp)                      # 4-byte Folded Spill
	sw	s2, 36(sp)                      # 4-byte Folded Spill
	sw	s3, 32(sp)                      # 4-byte Folded Spill
	sw	s4, 28(sp)                      # 4-byte Folded Spill
	sw	s5, 24(sp)                      # 4-byte Folded Spill
	sw	s6, 20(sp)                      # 4-byte Folded Spill
	sw	s7, 16(sp)                      # 4-byte Folded Spill
	sw	s8, 12(sp)                      # 4-byte Folded Spill
	sw	s9, 8(sp)                       # 4-byte Folded Spill
	beqz	a4, .LBB0_10
# %bb.1:                                # %for.cond1.preheader.lr.ph
	li	a6, 0
	li	t6, 3
	j	.LBB0_3
.LBB0_2:                                # %for.cond.cleanup3
                                        #   in Loop: Header=BB0_3 Depth=1
	addi	a6, a6, 1
	beq	a6, a4, .LBB0_11
.LBB0_3:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_7 Depth 2
                                        #       Child Loop BB0_9 Depth 3
	beqz	a3, .LBB0_2
# %bb.4:                                # %for.body4.preheader
                                        #   in Loop: Header=BB0_3 Depth=1
	li	s0, 0
	.p2align	2
# %bb.98:                               # %for.body4.preheader
                                        #   in Loop: Header=BB0_3 Depth=1
	lp.setup	x1, a3, .LBB0_72
.LBB0_7:                                # %for.body4
                                        #   Parent Loop BB0_3 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_9 Depth 3
	lbu	s1, 0(a1)
	andi	s1, s1, 1
	beqz	s1, .LBB0_5
# %bb.8:                                # %for.cond6.preheader
                                        #   in Loop: Header=BB0_7 Depth=2
	addi	s1, t6, 37
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lw	s1, 0(s1)
	sw	s1, 28(a2)
	mv	s1, a3
	.p2align	2
# %bb.99:                               # %for.cond6.preheader
                                        #   in Loop: Header=BB0_7 Depth=2
	lp.setup	x0, a3, .LBB0_73
.LBB0_90:                               #   in Loop: Header=BB0_7 Depth=2
	nop
	nop
.LBB0_9:                                # Block address taken
                                        # %for.body28
                                        #   Parent Loop BB0_3 Depth=1
                                        #     Parent Loop BB0_7 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
                                        # Label of block must be emitted
.LBB0_73:                               #   in Loop: Header=BB0_9 Depth=3
                                        # Label of block must be emitted
	slli	t6, t6, 2
	j	.LBB0_6
.LBB0_5:                                # %if.else
                                        #   in Loop: Header=BB0_7 Depth=2
	addi	s1, s0, 39
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lw	s1, 0(s1)
	sw	s1, 164(a2)
.LBB0_6:                                # Block address taken
                                        # %for.inc73
                                        #   in Loop: Header=BB0_7 Depth=2
                                        # Label of block must be emitted
.LBB0_72:                               #   in Loop: Header=BB0_7 Depth=2
                                        # Label of block must be emitted
	addi	s0, s0, 1
	j	.LBB0_2
.LBB0_10:
	li	t6, 3
.LBB0_11:                               # %for.cond80.preheader
	li	a6, 2
	beqz	a5, .LBB0_14
# %bb.12:                               # %for.body83.preheader
	lp.setup	x0, a5, .LBB0_74
.LBB0_13:                               # Block address taken
                                        # %for.body83
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	addi	s1, a6, 12
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lw	s1, 0(s1)
.LBB0_74:                               #   in Loop: Header=BB0_13 Depth=1
                                        # Label of block must be emitted
	add	a6, a6, s1
.LBB0_14:                               # %for.cond92.preheader
	beqz	a4, .LBB0_70
# %bb.15:                               # %for.body95.lr.ph
	li	t1, 0
	andi	a7, a4, 3
	addi	t0, a0, 20
	addi	s3, a3, 10
	addi	t2, a3, 56
	li	a5, 1
	li	t3, 23
	slli	t4, a7, 2
	add	t4, t4, t0
	li	t5, 38
	j	.LBB0_17
.LBB0_16:                               # %for.inc311
                                        #   in Loop: Header=BB0_17 Depth=1
	addi	t1, t1, 1
	mv	a5, s7
	beq	t1, a4, .LBB0_71
.LBB0_17:                               # %for.body95
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_20 Depth 2
                                        #     Child Loop BB0_22 Depth 2
                                        #     Child Loop BB0_24 Depth 2
                                        #     Child Loop BB0_26 Depth 2
                                        #     Child Loop BB0_28 Depth 2
                                        #     Child Loop BB0_30 Depth 2
                                        #     Child Loop BB0_32 Depth 2
                                        #     Child Loop BB0_63 Depth 2
                                        #       Child Loop BB0_67 Depth 3
                                        #     Child Loop BB0_38 Depth 2
                                        #     Child Loop BB0_41 Depth 2
                                        #     Child Loop BB0_44 Depth 2
                                        #     Child Loop BB0_47 Depth 2
                                        #     Child Loop BB0_50 Depth 2
                                        #     Child Loop BB0_53 Depth 2
                                        #     Child Loop BB0_56 Depth 2
                                        #     Child Loop BB0_59 Depth 2
	addi	s0, a5, 43
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lbu	s0, 0(s0)
	andi	s1, s0, 1
	addi	s7, a5, 53
	bnez	s1, .LBB0_36
# %bb.18:                               # %for.cond129.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	beqz	a3, .LBB0_31
# %bb.19:                               # %for.body137.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	addi	s1, a5, 19
	li	a5, 10
	andi	s1, s1, 63
	slli	s1, s1, 2
	sub	s2, s3, a5
	add	s1, s1, a2
	.p2align	2
# %bb.100:                              # %for.body137.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, s2, .LBB0_75
.LBB0_20:                               # Block address taken
                                        # %for.body137
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	andi	s0, a5, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	addi	a5, a5, 1
.LBB0_75:                               #   in Loop: Header=BB0_20 Depth=2
                                        # Label of block must be emitted
	sw	s0, 0(s1)
# %bb.21:                               # %for.body137.1.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	li	a5, 10
	sub	s0, s3, a5
	.p2align	2
# %bb.101:                              # %for.body137.1.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, s0, .LBB0_76
.LBB0_22:                               # Block address taken
                                        # %for.body137.1
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	andi	s0, a5, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	addi	a5, a5, 1
.LBB0_76:                               #   in Loop: Header=BB0_22 Depth=2
                                        # Label of block must be emitted
	sw	s0, 0(s1)
# %bb.23:                               # %for.body137.2.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	li	a5, 10
	sub	s0, s3, a5
	.p2align	2
# %bb.102:                              # %for.body137.2.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, s0, .LBB0_77
.LBB0_24:                               # Block address taken
                                        # %for.body137.2
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	andi	s0, a5, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	addi	a5, a5, 1
.LBB0_77:                               #   in Loop: Header=BB0_24 Depth=2
                                        # Label of block must be emitted
	sw	s0, 0(s1)
# %bb.25:                               # %for.body137.3.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	li	a5, 10
	sub	s0, s3, a5
	.p2align	2
# %bb.103:                              # %for.body137.3.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, s0, .LBB0_78
.LBB0_26:                               # Block address taken
                                        # %for.body137.3
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	andi	s0, a5, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	addi	a5, a5, 1
.LBB0_78:                               #   in Loop: Header=BB0_26 Depth=2
                                        # Label of block must be emitted
	sw	s0, 0(s1)
# %bb.27:                               # %for.body137.4.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	li	a5, 10
	sub	s0, s3, a5
	.p2align	2
# %bb.104:                              # %for.body137.4.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, s0, .LBB0_79
.LBB0_28:                               # Block address taken
                                        # %for.body137.4
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	andi	s0, a5, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	addi	a5, a5, 1
.LBB0_79:                               #   in Loop: Header=BB0_28 Depth=2
                                        # Label of block must be emitted
	sw	s0, 0(s1)
# %bb.29:                               # %for.body137.5.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	li	a5, 10
	sub	s0, s3, a5
	.p2align	2
# %bb.105:                              # %for.body137.5.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, s0, .LBB0_80
.LBB0_30:                               # Block address taken
                                        # %for.body137.5
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	andi	s0, a5, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	addi	a5, a5, 1
.LBB0_80:                               #   in Loop: Header=BB0_30 Depth=2
                                        # Label of block must be emitted
	sw	s0, 0(s1)
.LBB0_31:                               # %for.cond.cleanup136.5
                                        #   in Loop: Header=BB0_17 Depth=1
	mv	a5, t0
	beqz	a7, .LBB0_33
.LBB0_32:                               # %for.body155
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	addi	s0, t6, 34
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s0, 0(s0)
	p.lw	s1, 4(a5!)
	add	s0, s0, a6
	add	a6, s0, s1
	p.addun	s0, s0, s1, 31
	slli	t6, t6, 1
	or	t6, t6, s0
	bne	a5, t4, .LBB0_32
.LBB0_33:                               # %for.cond.cleanup154
                                        #   in Loop: Header=BB0_17 Depth=1
	addi	a5, a6, 44
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lbu	a5, 0(a5)
	andi	a5, a5, 1
	beqz	a5, .LBB0_37
# %bb.34:                               # %if.then175
                                        #   in Loop: Header=BB0_17 Depth=1
	andi	a5, s7, 3
	p.bneimm	a5, 1, .LBB0_60
.LBB0_35:                               # %if.end277
                                        #   in Loop: Header=BB0_17 Depth=1
	addi	s7, s7, 60
	j	.LBB0_37
.LBB0_36:                               # %if.then102
                                        #   in Loop: Header=BB0_17 Depth=1
	addi	s2, a5, 10
	addi	s4, a6, 26
	addi	s5, a6, 30
	addi	s6, a6, 58
	addi	a5, a6, 28
	andi	s1, s2, 63
	andi	s2, s4, 63
	andi	s4, s5, 63
	andi	s5, s6, 63
	andi	a5, a5, 63
	slli	s1, s1, 2
	slli	s2, s2, 2
	slli	s4, s4, 2
	slli	s5, s5, 2
	slli	a5, a5, 2
	add	s1, s1, a0
	add	s2, s2, a1
	add	s5, s5, a1
	add	a5, a5, a1
	lw	s6, 0(s1)
	lw	s1, 0(s5)
	lw	a5, 0(a5)
	lw	s2, 0(s2)
	add	s4, s4, a0
	lw	s4, 0(s4)
	add	a5, a5, s1
	add	s2, s2, s6
	xor	a5, a5, s7
	add	s2, s2, s4
	add	a5, a5, s2
	andi	a5, a5, 7
	beqz	a5, .LBB0_16
.LBB0_37:                               # %if.end282
                                        #   in Loop: Header=BB0_17 Depth=1
	addi	a5, s7, 42
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	s4, 0(a5)
	srai	a5, a6, 1
	srli	s2, a5, 30
	mv	a5, t6
	mv	s1, a3
	beqz	a3, .LBB0_39
.LBB0_38:                               # %for.body298
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	slli	a5, a5, 2
	addi	s1, s1, -1
	or	a5, a5, s2
	bnez	s1, .LBB0_38
.LBB0_39:                               # %for.cond.cleanup297
                                        #   in Loop: Header=BB0_17 Depth=1
	xor	s0, s7, s4
	xor	s4, s0, t6
	add	s4, s4, s7
	addi	s1, s4, 42
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lw	t6, 0(s1)
	mv	s1, a5
	beqz	a3, .LBB0_42
# %bb.40:                               # %for.body298.1.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	mv	s0, a3
	mv	s1, a5
	.p2align	2
# %bb.106:                              # %for.body298.1.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, a3, .LBB0_81
.LBB0_91:                               #   in Loop: Header=BB0_17 Depth=1
	nop
.LBB0_41:                               # Block address taken
                                        # %for.body298.1
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	slli	s1, s1, 2
.LBB0_81:                               #   in Loop: Header=BB0_41 Depth=2
                                        # Label of block must be emitted
	or	s1, s1, s2
.LBB0_42:                               # %for.cond.cleanup297.1
                                        #   in Loop: Header=BB0_17 Depth=1
	xor	s0, s4, t6
	xor	a5, a5, s0
	add	s4, s4, a5
	addi	a5, s4, 42
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	t6, 0(a5)
	mv	s0, s1
	beqz	a3, .LBB0_45
# %bb.43:                               # %for.body298.2.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	mv	a5, a3
	mv	s0, s1
	.p2align	2
# %bb.107:                              # %for.body298.2.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, a3, .LBB0_82
.LBB0_92:                               #   in Loop: Header=BB0_17 Depth=1
	nop
.LBB0_44:                               # Block address taken
                                        # %for.body298.2
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	slli	s0, s0, 2
.LBB0_82:                               #   in Loop: Header=BB0_44 Depth=2
                                        # Label of block must be emitted
	or	s0, s0, s2
.LBB0_45:                               # %for.cond.cleanup297.2
                                        #   in Loop: Header=BB0_17 Depth=1
	xor	a5, s4, t6
	xor	a5, a5, s1
	add	s4, s4, a5
	addi	a5, s4, 42
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	t6, 0(a5)
	mv	a5, s0
	beqz	a3, .LBB0_48
# %bb.46:                               # %for.body298.3.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	mv	s1, a3
	mv	a5, s0
	.p2align	2
# %bb.108:                              # %for.body298.3.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, a3, .LBB0_83
.LBB0_93:                               #   in Loop: Header=BB0_17 Depth=1
	nop
.LBB0_47:                               # Block address taken
                                        # %for.body298.3
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	slli	a5, a5, 2
.LBB0_83:                               #   in Loop: Header=BB0_47 Depth=2
                                        # Label of block must be emitted
	or	a5, a5, s2
.LBB0_48:                               # %for.cond.cleanup297.3
                                        #   in Loop: Header=BB0_17 Depth=1
	xor	s1, s4, t6
	xor	s0, s0, s1
	add	s4, s4, s0
	addi	s1, s4, 42
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lw	t6, 0(s1)
	mv	s0, a5
	beqz	a3, .LBB0_51
# %bb.49:                               # %for.body298.4.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	mv	s1, a3
	mv	s0, a5
	.p2align	2
# %bb.109:                              # %for.body298.4.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, a3, .LBB0_84
.LBB0_94:                               #   in Loop: Header=BB0_17 Depth=1
	nop
.LBB0_50:                               # Block address taken
                                        # %for.body298.4
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	slli	s0, s0, 2
.LBB0_84:                               #   in Loop: Header=BB0_50 Depth=2
                                        # Label of block must be emitted
	or	s0, s0, s2
.LBB0_51:                               # %for.cond.cleanup297.4
                                        #   in Loop: Header=BB0_17 Depth=1
	xor	s1, s4, t6
	xor	a5, a5, s1
	add	s4, s4, a5
	addi	a5, s4, 42
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	t6, 0(a5)
	mv	a5, s0
	beqz	a3, .LBB0_54
# %bb.52:                               # %for.body298.5.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	mv	s1, a3
	mv	a5, s0
	.p2align	2
# %bb.110:                              # %for.body298.5.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, a3, .LBB0_85
.LBB0_95:                               #   in Loop: Header=BB0_17 Depth=1
	nop
.LBB0_53:                               # Block address taken
                                        # %for.body298.5
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	slli	a5, a5, 2
.LBB0_85:                               #   in Loop: Header=BB0_53 Depth=2
                                        # Label of block must be emitted
	or	a5, a5, s2
.LBB0_54:                               # %for.cond.cleanup297.5
                                        #   in Loop: Header=BB0_17 Depth=1
	xor	s1, s4, t6
	xor	s0, s0, s1
	add	s1, s0, s4
	addi	s0, s1, 42
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s4, 0(s0)
	mv	t6, a5
	beqz	a3, .LBB0_57
# %bb.55:                               # %for.body298.6.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	mv	s0, a3
	mv	t6, a5
	.p2align	2
# %bb.111:                              # %for.body298.6.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, a3, .LBB0_86
.LBB0_96:                               #   in Loop: Header=BB0_17 Depth=1
	nop
.LBB0_56:                               # Block address taken
                                        # %for.body298.6
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	slli	t6, t6, 2
.LBB0_86:                               #   in Loop: Header=BB0_56 Depth=2
                                        # Label of block must be emitted
	or	t6, t6, s2
.LBB0_57:                               # %for.cond.cleanup297.6
                                        #   in Loop: Header=BB0_17 Depth=1
	xor	s0, s1, s4
	xor	a5, a5, s0
	add	a5, a5, s1
	addi	s0, a5, 42
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s0, 0(s0)
	xor	s1, a5, t6
	xor	s0, s0, s1
	add	s7, s0, a5
	beqz	a3, .LBB0_16
# %bb.58:                               # %for.body298.7.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	mv	a5, a3
	.p2align	2
# %bb.112:                              # %for.body298.7.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x0, a3, .LBB0_87
.LBB0_97:                               #   in Loop: Header=BB0_17 Depth=1
	nop
.LBB0_59:                               # Block address taken
                                        # %for.body298.7
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	slli	t6, t6, 2
.LBB0_87:                               #   in Loop: Header=BB0_59 Depth=2
                                        # Label of block must be emitted
	or	t6, t6, s2
	j	.LBB0_16
.LBB0_60:                               # %for.cond181.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	li	s4, 0
	addi	a5, t1, 49
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	s2, a2, a5
	.p2align	2
# %bb.113:                              # %for.cond181.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	lp.setup	x1, a4, .LBB0_88
.LBB0_63:                               # %for.body184
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_67 Depth 3
	andi	a5, s7, 1
	beqz	a5, .LBB0_61
# %bb.64:                               # %if.then194
                                        #   in Loop: Header=BB0_63 Depth=2
	addi	s5, a6, 27
	addi	s6, s7, 62
	addi	s8, s4, 44
	addi	a5, s4, 3
	andi	s0, s5, 63
	andi	s1, s6, 63
	andi	s5, s8, 63
	andi	a5, a5, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	slli	s5, s5, 2
	slli	a5, a5, 2
	add	s0, s0, a1
	add	s1, s1, a1
	add	s5, s5, a0
	add	s6, a0, a5
	lw	s8, 0(s0)
	lw	s1, 0(s1)
	lw	a5, 0(s5)
	lw	s0, 0(s6)
	add	s1, s1, s8
	add	a5, a5, s0
	add	a5, a5, s1
	andi	a5, a5, 1
	bnez	a5, .LBB0_69
# %bb.65:                               # %for.cond231.preheader
                                        #   in Loop: Header=BB0_63 Depth=2
	beqz	a3, .LBB0_68
# %bb.66:                               # %for.body234.lr.ph
                                        #   in Loop: Header=BB0_63 Depth=2
	addi	a5, s4, 53
	addi	s0, s4, 42
	andi	a5, a5, 63
	andi	s0, s0, 63
	slli	a5, a5, 2
	slli	s0, s0, 2
	add	a5, a5, a0
	add	s0, s0, a0
	lw	s5, 0(a5)
	lw	s6, 0(s0)
	li	a5, 56
	sub	s0, t2, a5
	.p2align	2
# %bb.114:                              # %for.body234.lr.ph
                                        #   in Loop: Header=BB0_63 Depth=2
	lp.setup	x0, s0, .LBB0_89
.LBB0_67:                               # Block address taken
                                        # %for.body234
                                        #   Parent Loop BB0_17 Depth=1
                                        #     Parent Loop BB0_63 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
                                        # Label of block must be emitted
	addi	s0, s7, 18
	addi	s1, a5, -45
	andi	s0, s0, 63
	andi	s1, s1, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	add	s0, s0, a1
	add	s1, s1, a1
	lw	s0, 0(s0)
	lw	s1, 0(s1)
	andi	s8, a5, 63
	add	s0, s0, s5
	xor	s1, s1, s7
	xor	s9, s0, s7
	add	s7, s7, s6
	slli	s8, s8, 2
	add	s8, s8, a0
	lw	s0, 0(s8)
	add	s1, s1, s7
	add	s1, s1, s9
	addi	a5, a5, 1
.LBB0_89:                               #   in Loop: Header=BB0_67 Depth=3
                                        # Label of block must be emitted
	add	s7, s1, s0
.LBB0_68:                               # %for.cond.cleanup233
                                        #   in Loop: Header=BB0_63 Depth=2
	addi	a5, s4, 43
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	add	a5, a5, a6
	addi	a6, a5, 38
	p.addun	a5, a5, t5, 31
	slli	t6, t6, 1
	or	t6, t6, a5
	j	.LBB0_62
.LBB0_69:                               # %if.then212
                                        #   in Loop: Header=BB0_63 Depth=2
	addi	a5, a6, 2
	addi	s0, s7, 60
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a2
	sw	a5, 0(s0)
	addi	a5, t6, 24
	addi	s0, a6, 30
	andi	a5, a5, 63
	andi	s0, s0, 63
	slli	a5, a5, 2
	slli	s0, s0, 2
	add	a5, a5, a0
	add	s0, s0, a0
	lw	a5, 0(a5)
	lw	s0, 0(s0)
	add	t6, t6, a5
	sw	s0, 0(s2)
	j	.LBB0_62
.LBB0_61:                               # %if.else269
                                        #   in Loop: Header=BB0_63 Depth=2
	addi	a5, s7, 2
	andi	a5, a5, 62
	slli	a5, a5, 2
	add	a5, a5, a2
	sw	t3, 0(a5)
.LBB0_62:                               # Block address taken
                                        # %for.inc274
                                        #   in Loop: Header=BB0_63 Depth=2
                                        # Label of block must be emitted
.LBB0_88:                               #   in Loop: Header=BB0_63 Depth=2
                                        # Label of block must be emitted
	addi	s4, s4, 1
	j	.LBB0_35
.LBB0_70:
	li	s7, 1
.LBB0_71:                               # %for.cond.cleanup94
	xor	a0, a6, s7
	xor	a0, a0, t6
	lw	s0, 44(sp)                      # 4-byte Folded Reload
	lw	s1, 40(sp)                      # 4-byte Folded Reload
	lw	s2, 36(sp)                      # 4-byte Folded Reload
	lw	s3, 32(sp)                      # 4-byte Folded Reload
	lw	s4, 28(sp)                      # 4-byte Folded Reload
	lw	s5, 24(sp)                      # 4-byte Folded Reload
	lw	s6, 20(sp)                      # 4-byte Folded Reload
	lw	s7, 16(sp)                      # 4-byte Folded Reload
	lw	s8, 12(sp)                      # 4-byte Folded Reload
	lw	s9, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Ltmp2:                                 # Address of block that was removed by CodeGen
.Ltmp3:                                 # Address of block that was removed by CodeGen
.Ltmp4:                                 # Address of block that was removed by CodeGen
.Ltmp5:                                 # Address of block that was removed by CodeGen
.Ltmp6:                                 # Address of block that was removed by CodeGen
.Ltmp7:                                 # Address of block that was removed by CodeGen
.Ltmp8:                                 # Address of block that was removed by CodeGen
.Ltmp9:                                 # Address of block that was removed by CodeGen
.Ltmp10:                                # Address of block that was removed by CodeGen
.Ltmp11:                                # Address of block that was removed by CodeGen
.Ltmp12:                                # Address of block that was removed by CodeGen
.Ltmp13:                                # Address of block that was removed by CodeGen
.Ltmp14:                                # Address of block that was removed by CodeGen
.Ltmp15:                                # Address of block that was removed by CodeGen
.Ltmp16:                                # Address of block that was removed by CodeGen
.Ltmp17:                                # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
