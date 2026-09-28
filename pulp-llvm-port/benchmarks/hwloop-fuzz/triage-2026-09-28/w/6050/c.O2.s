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
	sw	s1, 52(sp)                      # 4-byte Folded Spill
	sw	s2, 48(sp)                      # 4-byte Folded Spill
	sw	s3, 44(sp)                      # 4-byte Folded Spill
	sw	s4, 40(sp)                      # 4-byte Folded Spill
	sw	s5, 36(sp)                      # 4-byte Folded Spill
	sw	s6, 32(sp)                      # 4-byte Folded Spill
	sw	s7, 28(sp)                      # 4-byte Folded Spill
	sw	s8, 24(sp)                      # 4-byte Folded Spill
	sw	s9, 20(sp)                      # 4-byte Folded Spill
	sw	s10, 16(sp)                     # 4-byte Folded Spill
	sw	s11, 12(sp)                     # 4-byte Folded Spill
	beqz	a3, .LBB0_21
# %bb.1:                                # %for.body.lr.ph
	lw	s1, 12(a1)
	mul	a6, s1, a3
	addi	a6, a6, 1
	beqz	a4, .LBB0_22
.LBB0_2:                                # %for.cond7.preheader.lr.ph
	li	t1, 0
	andi	t2, a4, 3
	addi	t3, a2, 68
	addi	t4, a1, 20
	addi	t5, a1, 116
	addi	t6, a2, 188
	addi	s8, a5, 43
	addi	s2, a4, 33
	li	a7, 2
	li	t0, 3
	j	.LBB0_4
.LBB0_3:                                # %for.cond.cleanup10
                                        #   in Loop: Header=BB0_4 Depth=1
	addi	s0, t0, 28
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	addi	t1, t1, 1
	add	a7, a7, s0
	beq	t1, a4, .LBB0_23
.LBB0_4:                                # %for.cond7.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_8 Depth 2
                                        #       Child Loop BB0_10 Depth 3
                                        #       Child Loop BB0_15 Depth 3
                                        #       Child Loop BB0_20 Depth 3
	beqz	t2, .LBB0_3
# %bb.5:                                # %for.cond12.preheader.lr.ph
                                        #   in Loop: Header=BB0_4 Depth=1
	li	s6, 0
	addi	s0, t1, 28
	addi	s1, t1, 57
	andi	s0, s0, 63
	andi	s1, s1, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	add	s3, a1, s0
	add	s4, a1, s1
	.p2align	2
# %bb.32:                               # %for.cond12.preheader.lr.ph
                                        #   in Loop: Header=BB0_4 Depth=1
	lp.setup	x1, t2, .LBB0_27
.LBB0_8:                                # %for.cond12.preheader
                                        #   Parent Loop BB0_4 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_10 Depth 3
                                        #       Child Loop BB0_15 Depth 3
                                        #       Child Loop BB0_20 Depth 3
	slli	s5, s6, 2
	beqz	a5, .LBB0_11
# %bb.9:                                # %for.body15.lr.ph
                                        #   in Loop: Header=BB0_8 Depth=2
	li	s0, 43
	sub	s7, s8, s0
	add	s9, t3, s5
	.p2align	2
# %bb.33:                               # %for.body15.lr.ph
                                        #   in Loop: Header=BB0_8 Depth=2
	lp.setup	x0, s7, .LBB0_28
.LBB0_10:                               # Block address taken
                                        # %for.body15
                                        #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_8 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
                                        # Label of block must be emitted
	andi	s1, s0, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lw	s1, 0(s1)
	addi	s0, s0, 1
.LBB0_28:                               #   in Loop: Header=BB0_10 Depth=3
                                        # Label of block must be emitted
	sw	s1, 0(s9)
.LBB0_11:                               # %for.cond.cleanup14
                                        #   in Loop: Header=BB0_8 Depth=2
	add	s0, t4, s5
	lw	s0, 0(s0)
	xor	s1, a6, a7
	xor	s0, s0, s1
	andi	s0, s0, 4
	beqz	s0, .LBB0_7
# %bb.12:                               # %for.cond59.preheader
                                        #   in Loop: Header=BB0_8 Depth=2
	srli	s7, a7, 31
	beqz	a3, .LBB0_17
# %bb.13:                               # %for.body62.lr.ph
                                        #   in Loop: Header=BB0_8 Depth=2
	addi	s0, a6, 24
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s0, 0(s0)
	xor	s9, a6, s0
	mv	s0, a3
	.p2align	2
# %bb.34:                               # %for.body62.lr.ph
                                        #   in Loop: Header=BB0_8 Depth=2
	lp.setup	x0, a3, .LBB0_29
.LBB0_15:                               # %for.body62
                                        #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_8 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	xor	s1, t0, s9
	add	t0, t0, s1
	addi	s1, t0, -1
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lbu	s1, 0(s1)
	andi	s1, s1, 7
	beqz	s1, .LBB0_14
# %bb.16:                               # %for.body62
                                        #   in Loop: Header=BB0_15 Depth=3
	slli	t0, t0, 1
	or	t0, t0, s7
.LBB0_14:                               # Block address taken
                                        # %for.body62
                                        #   in Loop: Header=BB0_15 Depth=3
                                        # Label of block must be emitted
.LBB0_29:                               #   in Loop: Header=BB0_15 Depth=3
                                        # Label of block must be emitted
	addi	s0, s0, -1
	j	.LBB0_17
.LBB0_17:                               # %for.cond.cleanup61
                                        #   in Loop: Header=BB0_8 Depth=2
	addi	s0, a7, 56
	lw	s9, 0(s3)
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s0, 0(s0)
	slli	t0, t0, 1
	or	t0, t0, s7
	add	s0, s0, s9
	slli	s1, s0, 1
	slli	s0, s0, 3
	sub	s0, s0, s1
	andi	s0, s0, 8
	addi	t0, t0, 284
	beqz	s0, .LBB0_7
# %bb.18:                               # %if.then96
                                        #   in Loop: Header=BB0_8 Depth=2
	addi	s9, a7, 12
	addi	s10, t0, 21
	addi	s0, a7, 52
	add	s11, t5, s5
	andi	s9, s9, 63
	andi	s1, s10, 63
	andi	s0, s0, 63
	slli	s1, s1, 2
	slli	s0, s0, 2
	add	s1, s1, a0
	add	s0, s0, a0
	lw	s10, 0(s1)
	lw	ra, 0(s0)
	lw	s1, 0(s11)
	slli	s9, s9, 2
	add	s9, s9, a0
	lw	s0, 0(s9)
	add	s1, s1, ra
	add	s1, s1, s10
	andi	s1, s1, 1
	add	a6, a6, s0
	beqz	s1, .LBB0_6
# %bb.19:                               # %for.cond117.preheader
                                        #   in Loop: Header=BB0_8 Depth=2
	addi	s0, t0, 4
	addi	s1, a6, 57
	andi	s0, s0, 63
	andi	s1, s1, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	add	s0, s0, a1
	add	s1, s1, a1
	lw	s7, 0(s0)
	lw	s1, 0(s1)
	li	s0, 33
	add	s1, s1, s7
	slli	s7, s1, 3
	sub	s9, s2, s0
	sub	s7, s7, s1
	.p2align	2
# %bb.35:                               # %for.cond117.preheader
                                        #   in Loop: Header=BB0_8 Depth=2
	lp.setup	x0, s9, .LBB0_30
.LBB0_20:                               # Block address taken
                                        # %for.body120
                                        #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_8 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
                                        # Label of block must be emitted
	andi	s1, s0, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lw	s1, 0(s1)
	add	a7, a7, s7
	addi	s0, s0, 1
.LBB0_30:                               #   in Loop: Header=BB0_20 Depth=3
                                        # Label of block must be emitted
	add	a7, a7, s1
	j	.LBB0_7
.LBB0_6:                                # %if.else138
                                        #   in Loop: Header=BB0_8 Depth=2
	slli	t0, t0, 1
	or	t0, t0, s7
.LBB0_7:                                # Block address taken
                                        # %if.end144
                                        #   in Loop: Header=BB0_8 Depth=2
                                        # Label of block must be emitted
	lw	s0, 0(s4)
	add	s5, s5, t6
	addi	s6, s6, 1
.LBB0_27:                               #   in Loop: Header=BB0_8 Depth=2
                                        # Label of block must be emitted
	sw	s0, 0(s5)
	j	.LBB0_3
.LBB0_21:
	li	a6, 1
	bnez	a4, .LBB0_2
.LBB0_22:
	li	t0, 3
	li	a7, 2
.LBB0_23:                               # %for.cond162.preheader
	beqz	a3, .LBB0_26
# %bb.24:                               # %for.body165.lr.ph
	addi	a4, a7, 22
	addi	a3, a3, 9
	li	a1, 9
	andi	a4, a4, 63
	sub	a5, a3, a1
	slli	a4, a4, 2
	add	a2, a2, a4
	xor	a4, t0, a7
	.p2align	2
# %bb.36:                               # %for.body165.lr.ph
	lp.setup	x0, a5, .LBB0_31
.LBB0_25:                               # Block address taken
                                        # %for.body165
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	andi	a5, a1, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	xor	a5, a5, a4
	addi	a1, a1, 1
.LBB0_31:                               #   in Loop: Header=BB0_25 Depth=1
                                        # Label of block must be emitted
	sw	a5, 0(a2)
.LBB0_26:                               # %for.cond.cleanup164
	xor	a0, a7, a6
	xor	a0, a0, t0
	lw	ra, 60(sp)                      # 4-byte Folded Reload
	lw	s0, 56(sp)                      # 4-byte Folded Reload
	lw	s1, 52(sp)                      # 4-byte Folded Reload
	lw	s2, 48(sp)                      # 4-byte Folded Reload
	lw	s3, 44(sp)                      # 4-byte Folded Reload
	lw	s4, 40(sp)                      # 4-byte Folded Reload
	lw	s5, 36(sp)                      # 4-byte Folded Reload
	lw	s6, 32(sp)                      # 4-byte Folded Reload
	lw	s7, 28(sp)                      # 4-byte Folded Reload
	lw	s8, 24(sp)                      # 4-byte Folded Reload
	lw	s9, 20(sp)                      # 4-byte Folded Reload
	lw	s10, 16(sp)                     # 4-byte Folded Reload
	lw	s11, 12(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 64
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Ltmp2:                                 # Address of block that was removed by CodeGen
.Ltmp3:                                 # Address of block that was removed by CodeGen
.Ltmp4:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
