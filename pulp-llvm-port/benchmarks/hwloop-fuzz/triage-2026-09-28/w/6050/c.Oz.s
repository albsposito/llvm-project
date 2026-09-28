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
	sw	s10, 4(sp)                      # 4-byte Folded Spill
	sw	s11, 0(sp)                      # 4-byte Folded Spill
	li	a6, 1
	mv	s1, a3
	beqz	a3, .LBB0_2
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lw	s0, 12(a1)
	add	a6, a6, s0
	addi	s1, s1, -1
	bnez	s1, .LBB0_1
.LBB0_2:                                # %for.cond3.preheader
	li	a7, 0
	andi	t0, a4, 3
	addi	t1, a2, 68
	addi	t2, a1, 20
	addi	t3, a1, 116
	addi	t4, a2, 188
	li	t6, 3
	li	t5, 2
	li	s2, 6
	beqz	a4, .LBB0_19
.LBB0_3:                                # %for.cond7.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
                                        #       Child Loop BB0_5 Depth 3
                                        #       Child Loop BB0_8 Depth 3
                                        #       Child Loop BB0_17 Depth 3
	li	s5, 0
	addi	s0, a7, 28
	addi	s1, a7, 57
	andi	s0, s0, 63
	andi	s1, s1, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	add	s3, a1, s0
	add	s4, a1, s1
	beq	zero, t0, .LBB0_18
.LBB0_4:                                # %for.cond12.preheader
                                        #   Parent Loop BB0_3 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_5 Depth 3
                                        #       Child Loop BB0_8 Depth 3
                                        #       Child Loop BB0_17 Depth 3
	slli	s6, s5, 2
	add	s7, t1, s6
	li	s8, 43
	mv	s0, a5
	beqz	a5, .LBB0_6
.LBB0_5:                                # %for.body15
                                        #   Parent Loop BB0_3 Depth=1
                                        #     Parent Loop BB0_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	andi	s1, s8, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lw	s1, 0(s1)
	addi	s0, s0, -1
	sw	s1, 0(s7)
	addi	s8, s8, 1
	bnez	s0, .LBB0_5
.LBB0_6:                                # %for.cond.cleanup14
                                        #   in Loop: Header=BB0_4 Depth=2
	add	s0, t2, s6
	lw	s0, 0(s0)
	xor	s1, a6, t5
	xor	s0, s0, s1
	andi	s0, s0, 4
	beqz	s0, .LBB0_15
# %bb.7:                                # %for.cond59.preheader
                                        #   in Loop: Header=BB0_4 Depth=2
	addi	s0, a6, 24
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s7, a0, s0
	mv	s9, a3
.LBB0_8:                                # %for.cond59
                                        #   Parent Loop BB0_3 Depth=1
                                        #     Parent Loop BB0_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	srli	s8, t5, 31
	beqz	s9, .LBB0_12
# %bb.9:                                # %for.body62
                                        #   in Loop: Header=BB0_8 Depth=3
	lw	s0, 0(s7)
	xor	s1, a6, t6
	xor	s0, s0, s1
	add	t6, t6, s0
	addi	s0, t6, -1
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lbu	s0, 0(s0)
	andi	s0, s0, 7
	beqz	s0, .LBB0_11
# %bb.10:                               # %for.body62
                                        #   in Loop: Header=BB0_8 Depth=3
	slli	t6, t6, 1
	or	t6, t6, s8
.LBB0_11:                               # %for.body62
                                        #   in Loop: Header=BB0_8 Depth=3
	addi	s9, s9, -1
	j	.LBB0_8
.LBB0_12:                               # %for.cond.cleanup61
                                        #   in Loop: Header=BB0_4 Depth=2
	addi	s1, t5, 56
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lw	s7, 0(s1)
	lw	s1, 0(s3)
	slli	t6, t6, 1
	or	t6, t6, s8
	add	s1, s1, s7
	mul	s1, s1, s2
	andi	s1, s1, 8
	addi	t6, t6, 284
	beqz	s1, .LBB0_15
# %bb.13:                               # %if.then96
                                        #   in Loop: Header=BB0_4 Depth=2
	addi	s7, t5, 12
	addi	s9, t6, 21
	addi	s0, t5, 52
	add	s10, t3, s6
	andi	s7, s7, 63
	andi	s1, s9, 63
	andi	s0, s0, 63
	slli	s1, s1, 2
	slli	s0, s0, 2
	add	s1, s1, a0
	add	s0, s0, a0
	lw	s9, 0(s1)
	lw	s11, 0(s0)
	lw	s1, 0(s10)
	slli	s7, s7, 2
	add	s7, s7, a0
	lw	s0, 0(s7)
	add	s1, s1, s11
	add	s1, s1, s9
	andi	s1, s1, 1
	add	a6, a6, s0
	bnez	s1, .LBB0_16
# %bb.14:                               # %if.else138
                                        #   in Loop: Header=BB0_4 Depth=2
	slli	t6, t6, 1
	or	t6, t6, s8
.LBB0_15:                               # %if.end144
                                        #   in Loop: Header=BB0_4 Depth=2
	lw	s0, 0(s4)
	add	s6, s6, t4
	sw	s0, 0(s6)
	addi	s5, s5, 1
	beq	s5, t0, .LBB0_18
	j	.LBB0_4
.LBB0_16:                               # %for.cond117.preheader
                                        #   in Loop: Header=BB0_4 Depth=2
	addi	s0, t6, 4
	addi	s1, a6, 57
	andi	s0, s0, 63
	andi	s1, s1, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	add	s0, s0, a1
	add	s1, s1, a1
	lw	s0, 0(s0)
	lw	s1, 0(s1)
	add	s0, s0, s1
	slli	s1, s0, 3
	sub	s7, s1, s0
	li	s8, 33
	mv	s0, a4
	beqz	a4, .LBB0_15
.LBB0_17:                               # %for.body120
                                        #   Parent Loop BB0_3 Depth=1
                                        #     Parent Loop BB0_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	andi	s1, s8, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lw	s1, 0(s1)
	add	t5, t5, s7
	addi	s0, s0, -1
	add	t5, t5, s1
	addi	s8, s8, 1
	beqz	s0, .LBB0_15
	j	.LBB0_17
.LBB0_18:                               # %for.cond.cleanup10
                                        #   in Loop: Header=BB0_3 Depth=1
	addi	s0, t6, 28
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	add	t5, t5, s0
	addi	a7, a7, 1
	bne	a7, a4, .LBB0_3
.LBB0_19:                               # %for.cond162.preheader
	addi	a4, t5, 22
	xor	a1, t6, t5
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a2, a2, a4
	li	a4, 9
	beqz	a3, .LBB0_21
.LBB0_20:                               # %for.body165
                                        # =>This Inner Loop Header: Depth=1
	andi	a5, a4, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	addi	a3, a3, -1
	xor	a5, a5, a1
	sw	a5, 0(a2)
	addi	a4, a4, 1
	bnez	a3, .LBB0_20
.LBB0_21:                               # %for.cond.cleanup164
	xor	a0, a1, a6
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
	lw	s10, 4(sp)                      # 4-byte Folded Reload
	lw	s11, 0(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
