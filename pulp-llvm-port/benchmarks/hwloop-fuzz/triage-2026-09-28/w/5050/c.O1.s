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
	andi	a6, a4, 3
	beqz	a4, .LBB0_27
# %bb.1:                                # %for.body.lr.ph
	li	t1, 0
	addi	t2, a0, 176
	addi	t3, a3, 25
	slli	t4, a6, 2
	li	t0, 1
	li	a7, 2
	add	t4, t4, t2
	li	s5, 3
	j	.LBB0_4
.LBB0_2:                                # %for.cond.cleanup36
                                        #   in Loop: Header=BB0_4 Depth=1
	addi	s1, t0, 19
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lw	s1, 0(s1)
	addi	s0, t0, 12
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a2
	sw	s1, 0(s0)
.LBB0_3:                                # %for.inc123
                                        #   in Loop: Header=BB0_4 Depth=1
	addi	t1, t1, 1
	beq	t1, a4, .LBB0_28
.LBB0_4:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_18 Depth 2
                                        #       Child Loop BB0_21 Depth 3
                                        #     Child Loop BB0_25 Depth 2
                                        #       Child Loop BB0_26 Depth 3
                                        #     Child Loop BB0_8 Depth 2
                                        #       Child Loop BB0_11 Depth 3
	addi	s1, a7, 46
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lbu	s1, 0(s1)
	slli	a5, s5, 1
	srli	t5, a7, 31
	andi	s1, s1, 1
	or	s5, a5, t5
	bnez	s1, .LBB0_16
# %bb.5:                                # %for.cond70.preheader
                                        #   in Loop: Header=BB0_4 Depth=1
	li	t5, 0
	addi	s1, t1, 48
	andi	s1, s1, 63
	slli	t6, s1, 2
	add	t6, t6, a1
	andi	s2, t0, 1
	j	.LBB0_8
.LBB0_6:                                # %if.else114
                                        #   in Loop: Header=BB0_8 Depth=2
	addi	s1, t5, 15
	li	s0, 70
.LBB0_7:                                # %for.inc119
                                        #   in Loop: Header=BB0_8 Depth=2
	addi	t0, t0, 330
	andi	a5, s1, 63
	slli	a5, a5, 2
	add	a5, a5, a2
	addi	t5, t5, 1
	sw	s0, 0(a5)
	beq	t5, a4, .LBB0_3
.LBB0_8:                                # %for.cond75.preheader
                                        #   Parent Loop BB0_4 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_11 Depth 3
	beqz	a3, .LBB0_14
# %bb.9:                                # %for.body78.lr.ph
                                        #   in Loop: Header=BB0_8 Depth=2
	lw	s4, 0(t6)
	mul	s3, a3, s4
	add	s0, a7, s4
	mv	s1, a3
	.p2align	2
# %bb.45:                               # %for.body78.lr.ph
                                        #   in Loop: Header=BB0_8 Depth=2
	lp.setup	x0, a3, .LBB0_39
.LBB0_11:                               # %for.body78
                                        #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_8 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	addi	a5, s5, 3
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lbu	a5, 0(a5)
	andi	a5, a5, 7
	beqz	a5, .LBB0_10
# %bb.12:                               # %for.body78
                                        #   in Loop: Header=BB0_11 Depth=3
	srli	a5, s0, 31
	slli	s5, s5, 1
	or	s5, s5, a5
.LBB0_10:                               # Block address taken
                                        # %for.body78
                                        #   in Loop: Header=BB0_11 Depth=3
                                        # Label of block must be emitted
.LBB0_39:                               #   in Loop: Header=BB0_11 Depth=3
                                        # Label of block must be emitted
	add	s0, s0, s4
	j	.LBB0_13
.LBB0_13:                               # %for.cond.cleanup77.loopexit
                                        #   in Loop: Header=BB0_8 Depth=2
	add	a7, a7, s3
.LBB0_14:                               # %for.cond.cleanup77
                                        #   in Loop: Header=BB0_8 Depth=2
	beqz	s2, .LBB0_6
# %bb.15:                               # %if.then100
                                        #   in Loop: Header=BB0_8 Depth=2
	andi	a5, t5, 63
	xori	a5, a5, 32
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	s0, 0(a5)
	addi	s1, t0, 54
	j	.LBB0_7
.LBB0_16:                               # %for.cond6.preheader.preheader
                                        #   in Loop: Header=BB0_4 Depth=1
	li	s0, 0
	j	.LBB0_18
.LBB0_17:                               # %for.cond.cleanup9
                                        #   in Loop: Header=BB0_18 Depth=2
	addi	s0, t6, 1
	bnez	t6, .LBB0_23
.LBB0_18:                               # %for.cond6.preheader
                                        #   Parent Loop BB0_4 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_21 Depth 3
	mv	t6, s0
	p.beqimm	a3, -1, .LBB0_17
# %bb.19:                               # %for.body10.preheader
                                        #   in Loop: Header=BB0_18 Depth=2
	li	s1, 24
	sub	s0, t3, s1
	.p2align	2
# %bb.46:                               # %for.body10.preheader
                                        #   in Loop: Header=BB0_18 Depth=2
	lp.setup	x0, s0, .LBB0_40
.LBB0_21:                               # %for.body10
                                        #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_18 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	andi	s0, s1, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lbu	s0, 0(s0)
	slli	a5, s5, 1
	andi	s0, s0, 7
	or	s5, a5, t5
	beqz	s0, .LBB0_20
# %bb.22:                               # %for.body10
                                        #   in Loop: Header=BB0_21 Depth=3
	slli	a5, s5, 1
	or	s5, a5, t5
.LBB0_20:                               # Block address taken
                                        # %for.body10
                                        #   in Loop: Header=BB0_21 Depth=3
                                        # Label of block must be emitted
.LBB0_40:                               #   in Loop: Header=BB0_21 Depth=3
                                        # Label of block must be emitted
	addi	s1, s1, 1
	j	.LBB0_17
.LBB0_23:                               # %for.cond34.preheader
                                        #   in Loop: Header=BB0_4 Depth=1
	li	t6, 0
	addi	s0, a7, 43
	addi	s1, t1, 2
	andi	s0, s0, 63
	andi	s1, s1, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	add	s2, a2, s0
	add	s3, a0, s1
	.p2align	2
# %bb.47:                               # %for.cond34.preheader
                                        #   in Loop: Header=BB0_4 Depth=1
	lp.setup	x1, a4, .LBB0_41
.LBB0_25:                               # %for.cond39.preheader
                                        #   Parent Loop BB0_4 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_26 Depth 3
	mv	s1, t2
	beqz	a6, .LBB0_24
.LBB0_26:                               # %for.body43
                                        #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_25 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	p.lw	s0, 4(s1!)
	sw	s0, 0(s2)
	lw	s0, 0(s3)
	xor	s0, s0, s5
	add	a5, s0, s5
	slli	a5, a5, 1
	or	s5, a5, t5
	bne	s1, t4, .LBB0_26
.LBB0_24:                               # Block address taken
                                        # %for.cond.cleanup42
                                        #   in Loop: Header=BB0_25 Depth=2
                                        # Label of block must be emitted
.LBB0_41:                               #   in Loop: Header=BB0_25 Depth=2
                                        # Label of block must be emitted
	addi	t6, t6, 1
	j	.LBB0_2
.LBB0_27:
	li	s5, 3
	li	a7, 2
	li	t0, 1
.LBB0_28:                               # %for.cond127.preheader
	beqz	a3, .LBB0_33
# %bb.29:                               # %for.body130.preheader
	li	a2, 0
	srli	a4, a7, 31
	.p2align	2
# %bb.48:                               # %for.body130.preheader
	lp.setup	x1, a3, .LBB0_42
.LBB0_30:                               # %for.body130
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_31 Depth 2
	addi	a5, a2, 52
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	s1, 0(a5)
	li	s0, 3
	lp.starti	x0, .LBB0_31
	lp.endi	x0, .LBB0_43
	lp.counti	x0, 3
.LBB0_31:                               # Block address taken
                                        # %for.body138
                                        #   Parent Loop BB0_30 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	xor	a5, s1, t0
.LBB0_43:                               #   in Loop: Header=BB0_31 Depth=2
                                        # Label of block must be emitted
	add	t0, t0, a5
.LBB0_32:                               # Block address taken
                                        # %for.cond.cleanup137
                                        #   in Loop: Header=BB0_30 Depth=1
                                        # Label of block must be emitted
	slli	s5, s5, 1
	addi	a2, a2, 1
.LBB0_42:                               #   in Loop: Header=BB0_30 Depth=1
                                        # Label of block must be emitted
	or	s5, s5, a4
.LBB0_33:                               # %for.cond151.preheader
	beqz	a6, .LBB0_38
# %bb.34:                               # %for.body155.lr.ph
	addi	a2, s5, 49
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a0
	lw	a2, 0(a2)
	xori	a3, t0, 37
	.p2align	2
# %bb.49:                               # %for.body155.lr.ph
	lp.setup	x0, a6, .LBB0_44
.LBB0_36:                               # %for.body155
                                        # =>This Inner Loop Header: Depth=1
	addi	a4, a7, 46
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a4, a4, a0
	lw	a4, 0(a4)
	add	a4, a4, a2
	xor	a4, a4, a7
	andi	a4, a4, 7
	beqz	a4, .LBB0_35
# %bb.37:                               # %if.end167
                                        #   in Loop: Header=BB0_36 Depth=1
	addi	a4, a7, 1
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a4, a4, a1
	lw	a4, 0(a4)
	slli	a4, a4, 31
	srai	a4, a4, 31
	and	a4, a4, a3
	add	a7, a7, a4
.LBB0_35:                               # Block address taken
                                        # %for.inc194
                                        #   in Loop: Header=BB0_36 Depth=1
                                        # Label of block must be emitted
.LBB0_44:                               #   in Loop: Header=BB0_36 Depth=1
                                        # Label of block must be emitted
	addi	a6, a6, -1
	j	.LBB0_38
.LBB0_38:                               # %for.cond.cleanup154
	xor	a0, t0, a7
	xor	a0, a0, s5
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
.Ltmp5:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
