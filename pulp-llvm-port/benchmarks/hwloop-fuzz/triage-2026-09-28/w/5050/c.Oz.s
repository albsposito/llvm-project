	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	s0, 12(sp)                      # 4-byte Folded Spill
	sw	s1, 8(sp)                       # 4-byte Folded Spill
	sw	s2, 4(sp)                       # 4-byte Folded Spill
	sw	s3, 0(sp)                       # 4-byte Folded Spill
	li	t1, 0
	addi	t2, a3, 1
	andi	a6, a4, 3
	addi	t3, a0, 176
	li	s3, 3
	li	t0, 2
	li	a7, 1
.LBB0_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_13 Depth 2
                                        #       Child Loop BB0_14 Depth 3
                                        #     Child Loop BB0_19 Depth 2
                                        #       Child Loop BB0_20 Depth 3
                                        #     Child Loop BB0_4 Depth 2
                                        #       Child Loop BB0_5 Depth 3
	srli	t4, t0, 31
	beq	t1, a4, .LBB0_24
# %bb.2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	addi	a5, t0, 46
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lbu	a5, 0(a5)
	slli	s1, s3, 1
	andi	a5, a5, 1
	or	s3, s1, t4
	bnez	a5, .LBB0_12
# %bb.3:                                # %for.cond70.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	li	t4, 0
	addi	a5, t1, 48
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	t5, a1, a5
	andi	t6, a7, 1
	beqz	a4, .LBB0_23
.LBB0_4:                                # %for.cond75.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_5 Depth 3
	mv	a5, a3
	beqz	a3, .LBB0_8
.LBB0_5:                                # %for.body78
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	addi	s0, s3, 3
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lbu	s1, 0(s0)
	lw	s0, 0(t5)
	andi	s1, s1, 7
	beqz	s1, .LBB0_7
# %bb.6:                                # %for.body78
                                        #   in Loop: Header=BB0_5 Depth=3
	p.addun	s1, s0, t0, 31
	slli	s3, s3, 1
	or	s3, s3, s1
.LBB0_7:                                # %for.body78
                                        #   in Loop: Header=BB0_5 Depth=3
	add	t0, t0, s0
	addi	a5, a5, -1
	bnez	a5, .LBB0_5
.LBB0_8:                                # %for.cond.cleanup77
                                        #   in Loop: Header=BB0_4 Depth=2
	bnez	t6, .LBB0_10
# %bb.9:                                # %if.else114
                                        #   in Loop: Header=BB0_4 Depth=2
	addi	s0, t4, 15
	li	a5, 70
	j	.LBB0_11
.LBB0_10:                               # %if.then100
                                        #   in Loop: Header=BB0_4 Depth=2
	andi	a5, t4, 63
	xori	a5, a5, 32
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	addi	s0, a7, 54
.LBB0_11:                               # %for.inc119
                                        #   in Loop: Header=BB0_4 Depth=2
	addi	a7, a7, 330
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a2
	sw	a5, 0(s0)
	addi	t4, t4, 1
	beq	t4, a4, .LBB0_23
	j	.LBB0_4
.LBB0_12:                               # %for.cond2.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	li	t5, 0
	p.beqimm	zero, 2, .LBB0_18
.LBB0_13:                               # %for.cond6.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_14 Depth 3
	li	s0, 24
	mv	a5, t2
	beqz	t2, .LBB0_17
.LBB0_14:                               # %for.body10
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_13 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	andi	s1, s0, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lbu	s1, 0(s1)
	slli	s3, s3, 1
	andi	s1, s1, 7
	or	s3, s3, t4
	beqz	s1, .LBB0_16
# %bb.15:                               # %for.body10
                                        #   in Loop: Header=BB0_14 Depth=3
	slli	s3, s3, 1
	or	s3, s3, t4
.LBB0_16:                               # %for.body10
                                        #   in Loop: Header=BB0_14 Depth=3
	addi	a5, a5, -1
	addi	s0, s0, 1
	bnez	a5, .LBB0_14
.LBB0_17:                               # %for.cond.cleanup9
                                        #   in Loop: Header=BB0_13 Depth=2
	addi	t5, t5, 1
	p.bneimm	t5, 2, .LBB0_13
.LBB0_18:                               # %for.cond34.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	li	t5, 0
	addi	a5, t0, 43
	addi	s0, t1, 2
	andi	a5, a5, 63
	andi	s0, s0, 63
	slli	a5, a5, 2
	slli	s0, s0, 2
	add	t6, a2, a5
	add	s2, a0, s0
	beqz	a4, .LBB0_22
.LBB0_19:                               #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_20 Depth 3
	mv	a5, t3
	mv	s0, a6
	beqz	a6, .LBB0_21
.LBB0_20:                               # %for.body43
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_19 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	p.lw	s1, 4(a5!)
	sw	s1, 0(t6)
	lw	s1, 0(s2)
	xor	s1, s1, s3
	add	s1, s1, s3
	slli	s1, s1, 1
	or	s3, s1, t4
	addi	s0, s0, -1
	bnez	s0, .LBB0_20
.LBB0_21:                               # %for.cond.cleanup42
                                        #   in Loop: Header=BB0_19 Depth=2
	addi	t5, t5, 1
	bne	t5, a4, .LBB0_19
.LBB0_22:                               # %for.cond.cleanup36
                                        #   in Loop: Header=BB0_1 Depth=1
	addi	a5, a7, 19
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	addi	s1, a7, 12
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a2
	sw	a5, 0(s1)
.LBB0_23:                               # %for.inc123
                                        #   in Loop: Header=BB0_1 Depth=1
	addi	t1, t1, 1
	j	.LBB0_1
.LBB0_24:                               # %for.cond127.preheader
	li	a2, 0
	beqz	a3, .LBB0_28
.LBB0_25:                               # %for.body130
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_26 Depth 2
	addi	a4, a2, 52
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a4, a4, a0
	lw	a4, 0(a4)
	li	a5, 3
	beqz	a5, .LBB0_27
.LBB0_26:                               # %for.body138
                                        #   Parent Loop BB0_25 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	xor	s1, a4, a7
	add	a7, a7, s1
	addi	a5, a5, -1
	bnez	a5, .LBB0_26
.LBB0_27:                               # %for.cond.cleanup137
                                        #   in Loop: Header=BB0_25 Depth=1
	slli	s3, s3, 1
	or	s3, s3, t4
	addi	a2, a2, 1
	bne	a2, a3, .LBB0_25
.LBB0_28:                               # %for.cond151.preheader
	addi	a2, s3, 49
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a0
	xori	a3, a7, 37
	beqz	a6, .LBB0_32
.LBB0_29:                               # %for.body155
                                        # =>This Inner Loop Header: Depth=1
	addi	a4, t0, 46
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a4, a4, a0
	lw	a5, 0(a2)
	lw	a4, 0(a4)
	add	a4, a4, a5
	xor	a4, a4, t0
	andi	a4, a4, 7
	beqz	a4, .LBB0_31
# %bb.30:                               # %if.end167
                                        #   in Loop: Header=BB0_29 Depth=1
	addi	a4, t0, 1
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a4, a4, a1
	lw	a4, 0(a4)
	slli	a4, a4, 31
	srai	a4, a4, 31
	and	a4, a4, a3
	add	t0, t0, a4
.LBB0_31:                               # %for.inc194
                                        #   in Loop: Header=BB0_29 Depth=1
	addi	a6, a6, -1
	bnez	a6, .LBB0_29
.LBB0_32:                               # %for.cond.cleanup154
	xor	a0, s3, a7
	xor	a0, a0, t0
	lw	s0, 12(sp)                      # 4-byte Folded Reload
	lw	s1, 8(sp)                       # 4-byte Folded Reload
	lw	s2, 4(sp)                       # 4-byte Folded Reload
	lw	s3, 0(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
