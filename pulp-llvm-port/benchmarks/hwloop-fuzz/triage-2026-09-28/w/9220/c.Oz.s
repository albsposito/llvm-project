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
	sw	s6, 4(sp)                       # 4-byte Folded Spill
	sw	s7, 0(sp)                       # 4-byte Folded Spill
	li	a7, 0
	li	a6, 3
	beqz	a4, .LBB0_8
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_6 Depth 3
	li	s1, 0
	beqz	a3, .LBB0_7
.LBB0_2:                                # %for.body4
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_6 Depth 3
	lbu	s0, 0(a1)
	andi	s0, s0, 1
	bnez	s0, .LBB0_5
# %bb.3:                                # %if.else
                                        #   in Loop: Header=BB0_2 Depth=2
	addi	s0, s1, 39
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s0, 0(s0)
	sw	s0, 164(a2)
.LBB0_4:                                # %for.inc73
                                        #   in Loop: Header=BB0_2 Depth=2
	addi	s1, s1, 1
	bne	s1, a3, .LBB0_2
	j	.LBB0_7
.LBB0_5:                                # %for.cond6.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	addi	s0, a6, 37
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	sw	s0, 28(a2)
	mv	s0, a3
	beqz	a3, .LBB0_4
.LBB0_6:                                # %for.body28
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	slli	a6, a6, 2
	addi	s0, s0, -1
	beqz	s0, .LBB0_4
	j	.LBB0_6
.LBB0_7:                                # %for.cond.cleanup3
                                        #   in Loop: Header=BB0_1 Depth=1
	addi	a7, a7, 1
	bne	a7, a4, .LBB0_1
.LBB0_8:                                # %for.cond80.preheader
	li	a7, 2
	beqz	a5, .LBB0_10
.LBB0_9:                                # %for.body83
                                        # =>This Inner Loop Header: Depth=1
	addi	s1, a7, 12
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lw	s1, 0(s1)
	add	a7, a7, s1
	addi	a5, a5, -1
	bnez	a5, .LBB0_9
.LBB0_10:                               # %for.cond92.preheader
	li	t4, 0
	andi	t0, a4, 3
	addi	t1, a0, 20
	li	s0, 1
	li	t2, 23
	li	t3, 38
	beqz	a4, .LBB0_36
.LBB0_11:                               # %for.body95
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_13 Depth 2
                                        #       Child Loop BB0_14 Depth 3
                                        #     Child Loop BB0_17 Depth 2
                                        #     Child Loop BB0_28 Depth 2
                                        #       Child Loop BB0_32 Depth 3
                                        #     Child Loop BB0_23 Depth 2
                                        #       Child Loop BB0_24 Depth 3
	addi	a5, s0, 43
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lbu	a5, 0(a5)
	andi	a5, a5, 1
	addi	s4, s0, 53
	bnez	a5, .LBB0_21
# %bb.12:                               # %for.cond129.preheader
                                        #   in Loop: Header=BB0_11 Depth=1
	li	t5, 0
	addi	s0, s0, 19
	andi	a5, s0, 63
	slli	a5, a5, 2
	add	t6, a2, a5
	p.beqimm	zero, 6, .LBB0_16
.LBB0_13:                               # %for.cond134.preheader
                                        #   Parent Loop BB0_11 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_14 Depth 3
	li	a5, 10
	mv	s1, a3
	beqz	a3, .LBB0_15
.LBB0_14:                               # %for.body137
                                        #   Parent Loop BB0_11 Depth=1
                                        #     Parent Loop BB0_13 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	andi	s0, a5, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	addi	s1, s1, -1
	sw	s0, 0(t6)
	addi	a5, a5, 1
	bnez	s1, .LBB0_14
.LBB0_15:                               # %for.cond.cleanup136
                                        #   in Loop: Header=BB0_13 Depth=2
	addi	t5, t5, 1
	p.bneimm	t5, 6, .LBB0_13
.LBB0_16:                               #   in Loop: Header=BB0_11 Depth=1
	mv	t5, t1
	mv	s0, t0
	beqz	t0, .LBB0_18
.LBB0_17:                               # %for.body155
                                        #   Parent Loop BB0_11 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	addi	a5, a6, 34
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	p.lw	s1, 4(t5!)
	slli	a6, a6, 1
	add	a5, a5, a7
	add	a7, a5, s1
	p.addun	a5, a5, s1, 31
	or	a6, a6, a5
	addi	s0, s0, -1
	bnez	s0, .LBB0_17
.LBB0_18:                               # %for.cond.cleanup154
                                        #   in Loop: Header=BB0_11 Depth=1
	addi	a5, a7, 44
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lbu	a5, 0(a5)
	andi	a5, a5, 1
	beqz	a5, .LBB0_22
# %bb.19:                               # %if.then175
                                        #   in Loop: Header=BB0_11 Depth=1
	andi	a5, s4, 3
	p.bneimm	a5, 1, .LBB0_27
.LBB0_20:                               # %if.end277
                                        #   in Loop: Header=BB0_11 Depth=1
	addi	s4, s4, 60
	j	.LBB0_22
.LBB0_21:                               # %if.then102
                                        #   in Loop: Header=BB0_11 Depth=1
	addi	t5, s0, 10
	addi	t6, a7, 26
	addi	s2, a7, 30
	addi	s3, a7, 58
	addi	a5, a7, 28
	andi	s1, t5, 63
	andi	s0, t6, 63
	andi	t5, s2, 63
	andi	t6, s3, 63
	andi	a5, a5, 63
	slli	s1, s1, 2
	slli	s0, s0, 2
	slli	t5, t5, 2
	slli	t6, t6, 2
	slli	a5, a5, 2
	add	s1, s1, a0
	add	s0, s0, a1
	add	t6, t6, a1
	add	a5, a5, a1
	lw	s2, 0(s1)
	lw	s1, 0(t6)
	lw	a5, 0(a5)
	lw	s0, 0(s0)
	add	t5, t5, a0
	lw	t5, 0(t5)
	add	a5, a5, s1
	add	s0, s0, s2
	xor	a5, a5, s4
	add	t5, t5, s0
	add	a5, a5, t5
	andi	a5, a5, 7
	beqz	a5, .LBB0_26
.LBB0_22:                               # %if.end282
                                        #   in Loop: Header=BB0_11 Depth=1
	li	t5, 0
	srai	s0, a7, 1
	srli	s0, s0, 30
	p.beqimm	zero, 8, .LBB0_26
.LBB0_23:                               # %for.body287
                                        #   Parent Loop BB0_11 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_24 Depth 3
	addi	a5, s4, 42
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	s1, 0(a5)
	xor	a5, s4, a6
	xor	a5, a5, s1
	mv	s1, a3
	beqz	a3, .LBB0_25
.LBB0_24:                               # %for.body298
                                        #   Parent Loop BB0_11 Depth=1
                                        #     Parent Loop BB0_23 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	slli	a6, a6, 2
	or	a6, a6, s0
	addi	s1, s1, -1
	bnez	s1, .LBB0_24
.LBB0_25:                               # %for.cond.cleanup297
                                        #   in Loop: Header=BB0_23 Depth=2
	add	s4, s4, a5
	addi	t5, t5, 1
	p.bneimm	t5, 8, .LBB0_23
.LBB0_26:                               # %for.inc311
                                        #   in Loop: Header=BB0_11 Depth=1
	addi	t4, t4, 1
	mv	s0, s4
	beq	t4, a4, .LBB0_36
	j	.LBB0_11
.LBB0_27:                               # %for.cond181.preheader
                                        #   in Loop: Header=BB0_11 Depth=1
	li	t5, 0
	addi	a5, t4, 49
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	t6, a2, a5
	beqz	a4, .LBB0_20
.LBB0_28:                               # %for.body184
                                        #   Parent Loop BB0_11 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_32 Depth 3
	andi	a5, s4, 1
	bnez	a5, .LBB0_30
# %bb.29:                               # %if.else269
                                        #   in Loop: Header=BB0_28 Depth=2
	addi	a5, s4, 2
	andi	a5, a5, 62
	slli	a5, a5, 2
	add	a5, a5, a2
	sw	t2, 0(a5)
	j	.LBB0_35
.LBB0_30:                               # %if.then194
                                        #   in Loop: Header=BB0_28 Depth=2
	addi	s2, a7, 27
	addi	s3, s4, 62
	addi	s5, t5, 44
	addi	a5, t5, 3
	andi	s0, s2, 63
	andi	s1, s3, 63
	andi	s2, s5, 63
	andi	a5, a5, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	slli	s2, s2, 2
	slli	a5, a5, 2
	add	s0, s0, a1
	add	s1, s1, a1
	add	s2, s2, a0
	add	s3, a0, a5
	lw	s5, 0(s0)
	lw	s1, 0(s1)
	lw	a5, 0(s2)
	lw	s0, 0(s3)
	add	s1, s1, s5
	add	a5, a5, s0
	add	a5, a5, s1
	andi	a5, a5, 1
	bnez	a5, .LBB0_34
# %bb.31:                               # %for.cond231.preheader
                                        #   in Loop: Header=BB0_28 Depth=2
	addi	a5, t5, 53
	addi	s0, t5, 42
	andi	a5, a5, 63
	andi	s0, s0, 63
	slli	a5, a5, 2
	slli	s0, s0, 2
	add	s2, a0, a5
	add	s3, a0, s0
	li	s6, 56
	mv	s5, a3
	beqz	a3, .LBB0_33
.LBB0_32:                               # %for.body234
                                        #   Parent Loop BB0_11 Depth=1
                                        #     Parent Loop BB0_28 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	addi	a5, s4, 18
	addi	s1, s6, -45
	lw	s0, 0(s2)
	lw	s7, 0(s3)
	andi	a5, a5, 63
	andi	s1, s1, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	slli	s1, s1, 2
	add	s1, s1, a1
	lw	s1, 0(s1)
	add	a5, a5, s0
	andi	s0, s6, 63
	addi	s5, s5, -1
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s0, 0(s0)
	add	s7, s7, s4
	xor	s1, s1, s4
	xor	a5, a5, s4
	add	s1, s1, s7
	add	a5, a5, s1
	add	s4, a5, s0
	addi	s6, s6, 1
	bnez	s5, .LBB0_32
.LBB0_33:                               # %for.cond.cleanup233
                                        #   in Loop: Header=BB0_28 Depth=2
	addi	a5, t5, 43
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	add	a5, a5, a7
	addi	a7, a5, 38
	p.addun	a5, a5, t3, 31
	slli	a6, a6, 1
	or	a6, a6, a5
	j	.LBB0_35
.LBB0_34:                               # %if.then212
                                        #   in Loop: Header=BB0_28 Depth=2
	addi	a5, a7, 2
	addi	s0, s4, 60
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a2
	sw	a5, 0(s0)
	addi	a5, a6, 24
	addi	s0, a7, 30
	andi	a5, a5, 63
	andi	s0, s0, 63
	slli	a5, a5, 2
	slli	s0, s0, 2
	add	a5, a5, a0
	add	s0, s0, a0
	lw	a5, 0(a5)
	lw	s0, 0(s0)
	add	a6, a6, a5
	sw	s0, 0(t6)
.LBB0_35:                               # %for.inc274
                                        #   in Loop: Header=BB0_28 Depth=2
	addi	t5, t5, 1
	bne	t5, a4, .LBB0_28
	j	.LBB0_20
.LBB0_36:                               # %for.cond.cleanup94
	xor	a0, a7, s0
	xor	a0, a0, a6
	lw	s0, 28(sp)                      # 4-byte Folded Reload
	lw	s1, 24(sp)                      # 4-byte Folded Reload
	lw	s2, 20(sp)                      # 4-byte Folded Reload
	lw	s3, 16(sp)                      # 4-byte Folded Reload
	lw	s4, 12(sp)                      # 4-byte Folded Reload
	lw	s5, 8(sp)                       # 4-byte Folded Reload
	lw	s6, 4(sp)                       # 4-byte Folded Reload
	lw	s7, 0(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
