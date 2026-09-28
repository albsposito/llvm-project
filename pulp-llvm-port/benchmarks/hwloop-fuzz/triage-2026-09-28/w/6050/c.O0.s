	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	addi	sp, sp, -80
	sw	ra, 76(sp)                      # 4-byte Folded Spill
	sw	s0, 72(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 80
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
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_4
	j	.LBB0_2
.LBB0_2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -16(s0)
	lw	a1, -44(s0)
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -36(s0)
	add	a0, a0, a1
	sw	a0, -36(s0)
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
.LBB0_5:                                # %for.cond3
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_7 Depth 2
                                        #       Child Loop BB0_9 Depth 3
                                        #       Child Loop BB0_20 Depth 3
                                        #       Child Loop BB0_15 Depth 3
                                        #       Child Loop BB0_29 Depth 3
	lw	a0, -52(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_40
	j	.LBB0_6
.LBB0_6:                                # %for.body5
                                        #   in Loop: Header=BB0_5 Depth=1
	li	a0, 0
	sw	a0, -56(s0)
	j	.LBB0_7
.LBB0_7:                                # %for.cond6
                                        #   Parent Loop BB0_5 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_9 Depth 3
                                        #       Child Loop BB0_20 Depth 3
                                        #       Child Loop BB0_15 Depth 3
                                        #       Child Loop BB0_29 Depth 3
	lw	a0, -56(s0)
	lw	a1, -28(s0)
	andi	a1, a1, 3
	bgeu	a0, a1, .LBB0_38
	j	.LBB0_8
.LBB0_8:                                # %for.body9
                                        #   in Loop: Header=BB0_7 Depth=2
	li	a0, 0
	sw	a0, -60(s0)
	j	.LBB0_9
.LBB0_9:                                # %for.cond10
                                        #   Parent Loop BB0_5 Depth=1
                                        #     Parent Loop BB0_7 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -60(s0)
	lw	a1, -32(s0)
	bgeu	a0, a1, .LBB0_12
	j	.LBB0_10
.LBB0_10:                               # %for.body12
                                        #   in Loop: Header=BB0_9 Depth=3
	lw	a0, -16(s0)
	lw	a1, -60(s0)
	addi	a1, a1, 43
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -20(s0)
	lw	a2, -56(s0)
	addi	a2, a2, 17
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB0_11
.LBB0_11:                               # %for.inc19
                                        #   in Loop: Header=BB0_9 Depth=3
	lw	a0, -60(s0)
	addi	a0, a0, 1
	sw	a0, -60(s0)
	j	.LBB0_9
.LBB0_12:                               # %for.end21
                                        #   in Loop: Header=BB0_7 Depth=2
	lw	a0, -16(s0)
	lw	a1, -56(s0)
	addi	a1, a1, 5
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -36(s0)
	xor	a0, a0, a1
	lw	a1, -40(s0)
	xor	a0, a0, a1
	andi	a0, a0, 4
	beqz	a0, .LBB0_36
	j	.LBB0_13
.LBB0_13:                               # %if.then
                                        #   in Loop: Header=BB0_7 Depth=2
	li	a0, 1
	bnez	a0, .LBB0_19
	j	.LBB0_14
.LBB0_14:                               # %if.then32
                                        #   in Loop: Header=BB0_7 Depth=2
	li	a0, 0
	sw	a0, -64(s0)
	j	.LBB0_15
.LBB0_15:                               # %for.cond34
                                        #   Parent Loop BB0_5 Depth=1
                                        #     Parent Loop BB0_7 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -64(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_18
	j	.LBB0_16
.LBB0_16:                               # %for.body36
                                        #   in Loop: Header=BB0_15 Depth=3
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	addi	a1, a1, 24
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -36(s0)
	add	a0, a0, a1
	sw	a0, -36(s0)
	j	.LBB0_17
.LBB0_17:                               # %for.inc41
                                        #   in Loop: Header=BB0_15 Depth=3
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB0_15
.LBB0_18:                               # %for.end43
                                        #   in Loop: Header=BB0_7 Depth=2
	lw	a0, -16(s0)
	lw	a2, -36(s0)
	addi	a1, a2, 54
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	slli	a0, a1, 1
	add	a0, a0, a1
	xor	a0, a0, a2
	lw	a1, -12(s0)
	addi	a2, a2, 13
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a1, a1, a0
	lw	a0, -40(s0)
	add	a0, a0, a1
	sw	a0, -40(s0)
	j	.LBB0_26
.LBB0_19:                               # %if.else
                                        #   in Loop: Header=BB0_7 Depth=2
	li	a0, 0
	sw	a0, -68(s0)
	j	.LBB0_20
.LBB0_20:                               # %for.cond55
                                        #   Parent Loop BB0_5 Depth=1
                                        #     Parent Loop BB0_7 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -68(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_25
	j	.LBB0_21
.LBB0_21:                               # %for.body57
                                        #   in Loop: Header=BB0_20 Depth=3
	lw	a0, -12(s0)
	lw	a1, -36(s0)
	addi	a2, a1, 24
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a0, a0, a2
	lw	a0, 0(a0)
	xor	a1, a1, a0
	lw	a0, -44(s0)
	xor	a1, a1, a0
	add	a0, a0, a1
	sw	a0, -44(s0)
	lw	a0, -16(s0)
	lw	a1, -44(s0)
	addi	a1, a1, -1
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 7
	bnez	a0, .LBB0_23
	j	.LBB0_22
.LBB0_22:                               # %if.then69
                                        #   in Loop: Header=BB0_20 Depth=3
	j	.LBB0_24
.LBB0_23:                               # %if.end
                                        #   in Loop: Header=BB0_20 Depth=3
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_24
.LBB0_24:                               # %for.inc73
                                        #   in Loop: Header=BB0_20 Depth=3
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	j	.LBB0_20
.LBB0_25:                               # %for.end75
                                        #   in Loop: Header=BB0_7 Depth=2
	lw	a0, -44(s0)
	addi	a0, a0, 142
	sw	a0, -44(s0)
	j	.LBB0_26
.LBB0_26:                               # %if.end77
                                        #   in Loop: Header=BB0_7 Depth=2
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	lw	a0, -12(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 56
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -16(s0)
	lw	a2, -52(s0)
	addi	a2, a2, 28
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	slli	a1, a0, 1
	slli	a0, a0, 3
	sub	a0, a0, a1
	andi	a0, a0, 8
	beqz	a0, .LBB0_35
	j	.LBB0_27
.LBB0_27:                               # %if.then91
                                        #   in Loop: Header=BB0_7 Depth=2
	lw	a0, -12(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 12
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -36(s0)
	add	a0, a0, a1
	sw	a0, -36(s0)
	lw	a1, -12(s0)
	lw	a0, -44(s0)
	addi	a0, a0, 21
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a2, -40(s0)
	addi	a2, a2, 52
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	lw	a1, -16(s0)
	lw	a2, -56(s0)
	addi	a2, a2, 29
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	andi	a0, a0, 1
	beqz	a0, .LBB0_33
	j	.LBB0_28
.LBB0_28:                               # %if.then110
                                        #   in Loop: Header=BB0_7 Depth=2
	li	a0, 0
	sw	a0, -72(s0)
	j	.LBB0_29
.LBB0_29:                               # %for.cond112
                                        #   Parent Loop BB0_5 Depth=1
                                        #     Parent Loop BB0_7 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -72(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_32
	j	.LBB0_30
.LBB0_30:                               # %for.body114
                                        #   in Loop: Header=BB0_29 Depth=3
	lw	a2, -16(s0)
	lw	a0, -72(s0)
	addi	a0, a0, 33
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a2
	lw	a0, 0(a0)
	lw	a1, -44(s0)
	addi	a1, a1, 4
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a1, a1, a2
	lw	a3, 0(a1)
	slli	a1, a3, 3
	sub	a1, a1, a3
	lw	a3, -36(s0)
	addi	a3, a3, 57
	andi	a3, a3, 63
	slli	a3, a3, 2
	add	a2, a2, a3
	lw	a3, 0(a2)
	slli	a2, a3, 3
	sub	a2, a2, a3
	add	a1, a1, a2
	add	a1, a1, a0
	lw	a0, -40(s0)
	add	a0, a0, a1
	sw	a0, -40(s0)
	j	.LBB0_31
.LBB0_31:                               # %for.inc129
                                        #   in Loop: Header=BB0_29 Depth=3
	lw	a0, -72(s0)
	addi	a0, a0, 1
	sw	a0, -72(s0)
	j	.LBB0_29
.LBB0_32:                               # %for.end131
                                        #   in Loop: Header=BB0_7 Depth=2
	j	.LBB0_34
.LBB0_33:                               # %if.else132
                                        #   in Loop: Header=BB0_7 Depth=2
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_34
.LBB0_34:                               # %if.end136
                                        #   in Loop: Header=BB0_7 Depth=2
	j	.LBB0_35
.LBB0_35:                               # %if.end137
                                        #   in Loop: Header=BB0_7 Depth=2
	j	.LBB0_36
.LBB0_36:                               # %if.end138
                                        #   in Loop: Header=BB0_7 Depth=2
	lw	a0, -16(s0)
	lw	a1, -52(s0)
	addi	a1, a1, 57
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -20(s0)
	lw	a2, -56(s0)
	addi	a2, a2, 47
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB0_37
.LBB0_37:                               # %for.inc145
                                        #   in Loop: Header=BB0_7 Depth=2
	lw	a0, -56(s0)
	addi	a0, a0, 1
	sw	a0, -56(s0)
	j	.LBB0_7
.LBB0_38:                               # %for.end147
                                        #   in Loop: Header=BB0_5 Depth=1
	lw	a0, -16(s0)
	lw	a1, -44(s0)
	addi	a1, a1, 28
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -40(s0)
	add	a0, a0, a1
	sw	a0, -40(s0)
	j	.LBB0_39
.LBB0_39:                               # %for.inc152
                                        #   in Loop: Header=BB0_5 Depth=1
	lw	a0, -52(s0)
	addi	a0, a0, 1
	sw	a0, -52(s0)
	j	.LBB0_5
.LBB0_40:                               # %for.end154
	li	a0, 0
	sw	a0, -76(s0)
	j	.LBB0_41
.LBB0_41:                               # %for.cond156
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -76(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_44
	j	.LBB0_42
.LBB0_42:                               # %for.body158
                                        #   in Loop: Header=BB0_41 Depth=1
	lw	a0, -12(s0)
	lw	a1, -76(s0)
	addi	a1, a1, 9
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a2, -40(s0)
	xor	a0, a0, a2
	lw	a1, -44(s0)
	xor	a0, a0, a1
	lw	a1, -20(s0)
	addi	a2, a2, 22
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB0_43
.LBB0_43:                               # %for.inc167
                                        #   in Loop: Header=BB0_41 Depth=1
	lw	a0, -76(s0)
	addi	a0, a0, 1
	sw	a0, -76(s0)
	j	.LBB0_41
.LBB0_44:                               # %for.end169
	lw	a0, -36(s0)
	lw	a1, -40(s0)
	xor	a0, a0, a1
	lw	a1, -44(s0)
	xor	a0, a0, a1
	lw	ra, 76(sp)                      # 4-byte Folded Reload
	lw	s0, 72(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 80
	ret
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
