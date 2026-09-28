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
	li	a7, 0
	li	a6, 3
	j	.LBB0_3
.LBB0_2:                                # %for.cond.cleanup3
                                        #   in Loop: Header=BB0_3 Depth=1
	addi	a7, a7, 1
	beq	a7, a4, .LBB0_11
.LBB0_3:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_7 Depth 2
                                        #       Child Loop BB0_9 Depth 3
	beqz	a3, .LBB0_2
# %bb.4:                                # %for.body4.preheader
                                        #   in Loop: Header=BB0_3 Depth=1
	li	s0, 0
	.p2align	2
# %bb.53:                               # %for.body4.preheader
                                        #   in Loop: Header=BB0_3 Depth=1
	lp.setup	x1, a3, .LBB0_45
.LBB0_7:                                # %for.body4
                                        #   Parent Loop BB0_3 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_9 Depth 3
	lbu	s1, 0(a1)
	andi	s1, s1, 1
	beqz	s1, .LBB0_5
# %bb.8:                                # %for.cond.cleanup9
                                        #   in Loop: Header=BB0_7 Depth=2
	addi	s1, a6, 37
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lw	s1, 0(s1)
	sw	s1, 28(a2)
	mv	s1, a3
	.p2align	2
# %bb.54:                               # %for.cond.cleanup9
                                        #   in Loop: Header=BB0_7 Depth=2
	lp.setup	x0, a3, .LBB0_46
.LBB0_52:                               #   in Loop: Header=BB0_7 Depth=2
	nop
	nop
.LBB0_9:                                # Block address taken
                                        # %for.body28
                                        #   Parent Loop BB0_3 Depth=1
                                        #     Parent Loop BB0_7 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
                                        # Label of block must be emitted
.LBB0_46:                               #   in Loop: Header=BB0_9 Depth=3
                                        # Label of block must be emitted
	slli	a6, a6, 2
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
.LBB0_45:                               #   in Loop: Header=BB0_7 Depth=2
                                        # Label of block must be emitted
	addi	s0, s0, 1
	j	.LBB0_2
.LBB0_10:
	li	a6, 3
.LBB0_11:                               # %for.cond80.preheader
	li	a7, 2
	beqz	a5, .LBB0_14
# %bb.12:                               # %for.body83.preheader
	lp.setup	x0, a5, .LBB0_47
.LBB0_13:                               # Block address taken
                                        # %for.body83
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	addi	s1, a7, 12
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lw	s1, 0(s1)
.LBB0_47:                               #   in Loop: Header=BB0_13 Depth=1
                                        # Label of block must be emitted
	add	a7, a7, s1
.LBB0_14:                               # %for.cond92.preheader
	beqz	a4, .LBB0_43
# %bb.15:                               # %for.body95.lr.ph
	li	t2, 0
	andi	t0, a4, 3
	addi	t1, a0, 20
	addi	s6, a3, 10
	addi	t3, a3, 56
	li	s1, 1
	li	t4, 23
	slli	t5, t0, 2
	add	t5, t5, t1
	li	t6, 38
	j	.LBB0_17
.LBB0_16:                               # %for.inc311
                                        #   in Loop: Header=BB0_17 Depth=1
	addi	t2, t2, 1
	mv	s1, s7
	beq	t2, a4, .LBB0_44
.LBB0_17:                               # %for.body95
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_20 Depth 2
                                        #       Child Loop BB0_22 Depth 3
                                        #     Child Loop BB0_25 Depth 2
                                        #     Child Loop BB0_36 Depth 2
                                        #       Child Loop BB0_40 Depth 3
                                        #     Child Loop BB0_30 Depth 2
                                        #       Child Loop BB0_31 Depth 3
	addi	a5, s1, 43
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lbu	a5, 0(a5)
	andi	a5, a5, 1
	addi	s7, s1, 53
	bnez	a5, .LBB0_23
# %bb.18:                               # %for.cond129.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	li	s2, 0
	addi	s1, s1, 19
	andi	s0, s1, 63
	slli	s0, s0, 2
	add	s1, a2, s0
	lp.starti	x1, .LBB0_20
	lp.endi	x1, .LBB0_48
	lp.counti	x1, 6
.LBB0_20:                               # Block address taken
                                        # %for.cond134.preheader
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_22 Depth 3
                                        # Label of block must be emitted
	beqz	a3, .LBB0_19
# %bb.21:                               # %for.body137.preheader
                                        #   in Loop: Header=BB0_20 Depth=2
	li	s0, 10
	sub	a5, s6, s0
	.p2align	2
# %bb.55:                               # %for.body137.preheader
                                        #   in Loop: Header=BB0_20 Depth=2
	lp.setup	x0, a5, .LBB0_49
.LBB0_22:                               # Block address taken
                                        # %for.body137
                                        #   Parent Loop BB0_17 Depth=1
                                        #     Parent Loop BB0_20 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
                                        # Label of block must be emitted
	andi	a5, s0, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	addi	s0, s0, 1
.LBB0_49:                               #   in Loop: Header=BB0_22 Depth=3
                                        # Label of block must be emitted
	sw	a5, 0(s1)
.LBB0_19:                               # Block address taken
                                        # %for.cond.cleanup136
                                        #   in Loop: Header=BB0_20 Depth=2
                                        # Label of block must be emitted
.LBB0_48:                               #   in Loop: Header=BB0_20 Depth=2
                                        # Label of block must be emitted
	addi	s2, s2, 1
	j	.LBB0_24
.LBB0_23:                               # %if.then102
                                        #   in Loop: Header=BB0_17 Depth=1
	addi	s2, s1, 10
	addi	s3, a7, 26
	addi	s4, a7, 30
	addi	s5, a7, 58
	addi	a5, a7, 28
	andi	s0, s2, 63
	andi	s1, s3, 63
	andi	s2, s4, 63
	andi	s3, s5, 63
	andi	a5, a5, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	slli	s2, s2, 2
	slli	s3, s3, 2
	slli	a5, a5, 2
	add	s0, s0, a0
	add	s1, s1, a1
	add	s3, s3, a1
	add	a5, a5, a1
	lw	s4, 0(s0)
	lw	s0, 0(s3)
	lw	a5, 0(a5)
	lw	s1, 0(s1)
	add	s2, s2, a0
	lw	s2, 0(s2)
	add	a5, a5, s0
	add	s1, s1, s4
	xor	a5, a5, s7
	add	s1, s1, s2
	add	a5, a5, s1
	andi	a5, a5, 7
	bnez	a5, .LBB0_29
	j	.LBB0_16
.LBB0_24:                               # %for.cond151.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	mv	a5, t1
	beqz	t0, .LBB0_26
.LBB0_25:                               # %for.body155
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	addi	s0, a6, 34
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s0, 0(s0)
	p.lw	s1, 4(a5!)
	add	s0, s0, a7
	add	a7, s0, s1
	p.addun	s0, s0, s1, 31
	slli	a6, a6, 1
	or	a6, a6, s0
	bne	a5, t5, .LBB0_25
.LBB0_26:                               # %for.cond.cleanup154
                                        #   in Loop: Header=BB0_17 Depth=1
	addi	a5, a7, 44
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lbu	a5, 0(a5)
	andi	a5, a5, 1
	beqz	a5, .LBB0_29
# %bb.27:                               # %if.then175
                                        #   in Loop: Header=BB0_17 Depth=1
	andi	a5, s7, 3
	p.bneimm	a5, 1, .LBB0_33
.LBB0_28:                               # %if.end277
                                        #   in Loop: Header=BB0_17 Depth=1
	addi	s7, s7, 60
.LBB0_29:                               # %if.end282
                                        #   in Loop: Header=BB0_17 Depth=1
	li	s1, 0
	srai	a5, a7, 1
	srli	a5, a5, 30
	mv	s3, a6
	lp.starti	x1, .LBB0_30
	lp.endi	x1, .LBB0_50
	lp.counti	x1, 8
.LBB0_30:                               # Block address taken
                                        # %for.body287
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_31 Depth 3
                                        # Label of block must be emitted
	addi	s0, s7, 42
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s2, 0(s0)
	mv	s0, a3
	beqz	a3, .LBB0_32
.LBB0_31:                               # %for.body298
                                        #   Parent Loop BB0_17 Depth=1
                                        #     Parent Loop BB0_30 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	slli	a6, a6, 2
	addi	s0, s0, -1
	or	a6, a6, a5
	bnez	s0, .LBB0_31
.LBB0_32:                               # Block address taken
                                        # %for.cond.cleanup297
                                        #   in Loop: Header=BB0_30 Depth=2
                                        # Label of block must be emitted
	xor	s0, s7, s2
	xor	s0, s0, s3
	add	s7, s7, s0
.LBB0_50:                               #   in Loop: Header=BB0_30 Depth=2
                                        # Label of block must be emitted
	mv	s3, a6
	j	.LBB0_16
.LBB0_33:                               # %for.cond181.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	li	s3, 0
	addi	a5, t2, 49
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	s2, a2, a5
	j	.LBB0_36
.LBB0_34:                               # %if.else269
                                        #   in Loop: Header=BB0_36 Depth=2
	addi	a5, s7, 2
	andi	a5, a5, 62
	slli	a5, a5, 2
	add	a5, a5, a2
	sw	t4, 0(a5)
.LBB0_35:                               # %for.inc274
                                        #   in Loop: Header=BB0_36 Depth=2
	addi	s3, s3, 1
	beq	s3, a4, .LBB0_28
.LBB0_36:                               # %for.body184
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_40 Depth 3
	andi	a5, s7, 1
	beqz	a5, .LBB0_34
# %bb.37:                               # %if.then194
                                        #   in Loop: Header=BB0_36 Depth=2
	addi	s4, a7, 27
	addi	s5, s7, 62
	addi	s8, s3, 44
	addi	a5, s3, 3
	andi	s0, s4, 63
	andi	s1, s5, 63
	andi	s4, s8, 63
	andi	a5, a5, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	slli	s4, s4, 2
	slli	a5, a5, 2
	add	s0, s0, a1
	add	s1, s1, a1
	add	s4, s4, a0
	add	s5, a0, a5
	lw	s8, 0(s0)
	lw	s1, 0(s1)
	lw	a5, 0(s4)
	lw	s0, 0(s5)
	add	s1, s1, s8
	add	a5, a5, s0
	add	a5, a5, s1
	andi	a5, a5, 1
	bnez	a5, .LBB0_42
# %bb.38:                               # %for.cond231.preheader
                                        #   in Loop: Header=BB0_36 Depth=2
	beqz	a3, .LBB0_41
# %bb.39:                               # %for.body234.lr.ph
                                        #   in Loop: Header=BB0_36 Depth=2
	addi	a5, s3, 53
	addi	s0, s3, 42
	andi	a5, a5, 63
	andi	s0, s0, 63
	slli	a5, a5, 2
	slli	s0, s0, 2
	add	a5, a5, a0
	add	s0, s0, a0
	lw	s4, 0(a5)
	lw	s5, 0(s0)
	li	s1, 56
	sub	a5, t3, s1
	.p2align	2
# %bb.56:                               # %for.body234.lr.ph
                                        #   in Loop: Header=BB0_36 Depth=2
	lp.setup	x0, a5, .LBB0_51
.LBB0_40:                               # Block address taken
                                        # %for.body234
                                        #   Parent Loop BB0_17 Depth=1
                                        #     Parent Loop BB0_36 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
                                        # Label of block must be emitted
	addi	a5, s7, 18
	addi	s0, s1, -45
	andi	a5, a5, 63
	andi	s0, s0, 63
	slli	a5, a5, 2
	slli	s0, s0, 2
	add	a5, a5, a1
	add	s0, s0, a1
	lw	a5, 0(a5)
	lw	s0, 0(s0)
	andi	s8, s1, 63
	add	a5, a5, s4
	xor	s0, s0, s7
	xor	s9, a5, s7
	add	s7, s7, s5
	slli	s8, s8, 2
	add	s8, s8, a0
	lw	a5, 0(s8)
	add	s0, s0, s7
	add	s0, s0, s9
	addi	s1, s1, 1
.LBB0_51:                               #   in Loop: Header=BB0_40 Depth=3
                                        # Label of block must be emitted
	add	s7, s0, a5
.LBB0_41:                               # %for.cond.cleanup233
                                        #   in Loop: Header=BB0_36 Depth=2
	addi	a5, s3, 43
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	add	a5, a5, a7
	addi	a7, a5, 38
	p.addun	a5, a5, t6, 31
	slli	a6, a6, 1
	or	a6, a6, a5
	j	.LBB0_35
.LBB0_42:                               # %if.then212
                                        #   in Loop: Header=BB0_36 Depth=2
	addi	a5, a7, 2
	addi	s0, s7, 60
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
	sw	s0, 0(s2)
	j	.LBB0_35
.LBB0_43:
	li	s7, 1
.LBB0_44:                               # %for.cond.cleanup94
	xor	a0, s7, a6
	xor	a0, a7, a0
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
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
