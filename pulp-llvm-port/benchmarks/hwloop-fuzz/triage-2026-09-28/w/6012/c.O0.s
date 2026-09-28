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
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
                                        #       Child Loop BB0_11 Depth 3
                                        #       Child Loop BB0_34 Depth 3
	lw	a0, -48(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_44
	j	.LBB0_2
.LBB0_2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -16(s0)
	lw	a1, -44(s0)
	addi	a1, a1, 5
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 7
	bnez	a0, .LBB0_4
	j	.LBB0_3
.LBB0_3:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	j	.LBB0_43
.LBB0_4:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	li	a0, 0
	sw	a0, -52(s0)
	j	.LBB0_5
.LBB0_5:                                # %for.cond3
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_11 Depth 3
                                        #       Child Loop BB0_34 Depth 3
	lw	a0, -52(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_42
	j	.LBB0_6
.LBB0_6:                                # %for.body5
                                        #   in Loop: Header=BB0_5 Depth=2
	lw	a0, -12(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 52
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 1
	beqz	a0, .LBB0_8
	j	.LBB0_7
.LBB0_7:                                # %if.then10
                                        #   in Loop: Header=BB0_5 Depth=2
	lw	a0, -16(s0)
	lw	a1, -52(s0)
	addi	a1, a1, 37
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -36(s0)
	add	a0, a0, a1
	sw	a0, -36(s0)
	j	.LBB0_31
.LBB0_8:                                # %if.else
                                        #   in Loop: Header=BB0_5 Depth=2
	lw	a0, -12(s0)
	lw	a3, -44(s0)
	addi	a1, a3, 29
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a1, a1, a0
	lw	a1, 0(a1)
	lw	a2, -16(s0)
	addi	a4, a3, 44
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a4, a4, a2
	lw	a4, 0(a4)
	add	a1, a1, a4
	addi	a3, a3, 54
	andi	a3, a3, 63
	slli	a3, a3, 2
	add	a0, a0, a3
	lw	a0, 0(a0)
	slli	a0, a0, 1
	lw	a3, -52(s0)
	addi	a3, a3, -1
	andi	a3, a3, 63
	slli	a3, a3, 2
	add	a2, a2, a3
	lw	a2, 0(a2)
	add	a0, a0, a2
	sub	a0, a0, a1
	andi	a0, a0, 7
	bnez	a0, .LBB0_10
	j	.LBB0_9
.LBB0_9:                                # %if.then33
                                        #   in Loop: Header=BB0_5 Depth=2
	j	.LBB0_41
.LBB0_10:                               # %if.end34
                                        #   in Loop: Header=BB0_5 Depth=2
	li	a0, 0
	sw	a0, -56(s0)
	j	.LBB0_11
.LBB0_11:                               # %for.cond35
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_5 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -56(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_30
	j	.LBB0_12
.LBB0_12:                               # %for.body37
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -12(s0)
	lw	a1, -56(s0)
	addi	a1, a1, 27
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	andi	a0, a0, 1
	beqz	a0, .LBB0_22
	j	.LBB0_13
.LBB0_13:                               # %if.then44
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -12(s0)
	lw	a1, -56(s0)
	addi	a1, a1, 35
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 1
	beqz	a0, .LBB0_15
	j	.LBB0_14
.LBB0_14:                               # %if.then50
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -36(s0)
	xori	a0, a0, 343
	lw	a1, -20(s0)
	lw	a2, -44(s0)
	addi	a2, a2, 56
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB0_19
.LBB0_15:                               # %if.else54
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -12(s0)
	lw	a1, -56(s0)
	addi	a1, a1, 26
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -40(s0)
	xor	a0, a0, a1
	andi	a0, a0, 1
	beqz	a0, .LBB0_17
	j	.LBB0_16
.LBB0_16:                               # %if.then61
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a1, -16(s0)
	lw	a0, -44(s0)
	addi	a2, a0, 3
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_18
.LBB0_17:                               # %if.else66
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -44(s0)
	addi	a0, a0, 58
	sw	a0, -44(s0)
	lw	a0, -16(s0)
	lw	a1, -48(s0)
	addi	a1, a1, 8
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -44(s0)
	add	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_18
.LBB0_18:                               # %if.end72
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -40(s0)
	addi	a0, a0, 51
	sw	a0, -40(s0)
	lw	a2, -12(s0)
	lw	a3, -48(s0)
	addi	a0, a3, 52
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a2
	lw	a0, 0(a0)
	lw	a1, -40(s0)
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	addi	a3, a3, 41
	andi	a3, a3, 63
	slli	a3, a3, 2
	add	a2, a2, a3
	lw	a2, 0(a2)
	add	a1, a1, a2
	add	a0, a0, a1
	lw	a1, -36(s0)
	add	a0, a0, a1
	addi	a0, a0, 208
	sw	a0, -36(s0)
	j	.LBB0_19
.LBB0_19:                               # %if.end87
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -12(s0)
	lw	a1, -56(s0)
	addi	a1, a1, 18
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 4
	beqz	a0, .LBB0_21
	j	.LBB0_20
.LBB0_20:                               # %if.then93
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -16(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 16
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -44(s0)
	add	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_21
.LBB0_21:                               # %if.end98
                                        #   in Loop: Header=BB0_11 Depth=3
	j	.LBB0_28
.LBB0_22:                               # %if.else99
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -12(s0)
	lw	a1, -52(s0)
	addi	a1, a1, 36
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -40(s0)
	xor	a0, a0, a1
	andi	a0, a0, 1
	beqz	a0, .LBB0_26
	j	.LBB0_23
.LBB0_23:                               # %if.then106
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	addi	a1, a1, 27
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	slli	a0, a1, 1
	add	a0, a0, a1
	lw	a1, -36(s0)
	xor	a0, a0, a1
	andi	a0, a0, 7
	bnez	a0, .LBB0_25
	j	.LBB0_24
.LBB0_24:                               # %if.then115
                                        #   in Loop: Header=BB0_11 Depth=3
	j	.LBB0_29
.LBB0_25:                               # %if.end116
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a1, -16(s0)
	lw	a0, -44(s0)
	addi	a0, a0, 1
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a2, -48(s0)
	addi	a2, a2, 22
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	lw	a1, -20(s0)
	lw	a2, -56(s0)
	addi	a2, a2, 33
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB0_27
.LBB0_26:                               # %if.else127
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -16(s0)
	lw	a1, -44(s0)
	addi	a1, a1, 33
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -40(s0)
	add	a0, a0, a1
	sw	a0, -40(s0)
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	lw	a0, -36(s0)
	addi	a0, a0, 82
	sw	a0, -36(s0)
	j	.LBB0_27
.LBB0_27:                               # %if.end133
                                        #   in Loop: Header=BB0_11 Depth=3
	j	.LBB0_28
.LBB0_28:                               # %if.end134
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	lw	a0, -12(s0)
	lw	a1, -52(s0)
	addi	a1, a1, 60
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -16(s0)
	lw	a2, -56(s0)
	addi	a2, a2, 51
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	lw	a2, -44(s0)
	xor	a1, a1, a2
	add	a1, a1, a0
	lw	a0, -36(s0)
	add	a0, a0, a1
	sw	a0, -36(s0)
	j	.LBB0_29
.LBB0_29:                               # %for.inc
                                        #   in Loop: Header=BB0_11 Depth=3
	lw	a0, -56(s0)
	addi	a0, a0, 1
	sw	a0, -56(s0)
	j	.LBB0_11
.LBB0_30:                               # %for.end
                                        #   in Loop: Header=BB0_5 Depth=2
	lw	a0, -12(s0)
	lw	a1, -52(s0)
	addi	a1, a1, 59
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -40(s0)
	add	a0, a0, a1
	sw	a0, -40(s0)
	j	.LBB0_31
.LBB0_31:                               # %if.end151
                                        #   in Loop: Header=BB0_5 Depth=2
	lw	a0, -12(s0)
	lw	a1, -52(s0)
	addi	a1, a1, 51
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -36(s0)
	xor	a0, a0, a1
	addi	a0, a0, 162
	andi	a0, a0, 1
	beqz	a0, .LBB0_33
	j	.LBB0_32
.LBB0_32:                               # %if.then159
                                        #   in Loop: Header=BB0_5 Depth=2
	lw	a1, -12(s0)
	lw	a2, -36(s0)
	addi	a0, a2, 11
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a3, -44(s0)
	addi	a3, a3, 31
	andi	a3, a3, 63
	slli	a3, a3, 2
	add	a3, a3, a1
	lw	a3, 0(a3)
	lw	a4, -52(s0)
	addi	a4, a4, 52
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a4, a4, a1
	lw	a4, 0(a4)
	add	a3, a3, a4
	add	a0, a0, a3
	addi	a2, a2, 46
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	lw	a1, -20(s0)
	lw	a2, -48(s0)
	addi	a2, a2, 52
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	lw	a0, -40(s0)
	addi	a0, a0, 5
	sw	a0, -40(s0)
	j	.LBB0_40
.LBB0_33:                               # %if.else179
                                        #   in Loop: Header=BB0_5 Depth=2
	li	a0, 0
	sw	a0, -60(s0)
	j	.LBB0_34
.LBB0_34:                               # %for.cond181
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_5 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -60(s0)
	lw	a1, -24(s0)
	addi	a1, a1, 1
	bgeu	a0, a1, .LBB0_39
	j	.LBB0_35
.LBB0_35:                               # %for.body184
                                        #   in Loop: Header=BB0_34 Depth=3
	lw	a0, -16(s0)
	lw	a1, -36(s0)
	addi	a1, a1, 53
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -44(s0)
	xor	a0, a0, a1
	andi	a0, a0, 7
	bnez	a0, .LBB0_37
	j	.LBB0_36
.LBB0_36:                               # %if.then191
                                        #   in Loop: Header=BB0_34 Depth=3
	j	.LBB0_38
.LBB0_37:                               # %if.end192
                                        #   in Loop: Header=BB0_34 Depth=3
	j	.LBB0_38
.LBB0_38:                               # %for.inc193
                                        #   in Loop: Header=BB0_34 Depth=3
	lw	a0, -60(s0)
	addi	a0, a0, 1
	sw	a0, -60(s0)
	j	.LBB0_34
.LBB0_39:                               # %for.end195
                                        #   in Loop: Header=BB0_5 Depth=2
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_40
.LBB0_40:                               # %if.end199
                                        #   in Loop: Header=BB0_5 Depth=2
	lw	a0, -16(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 37
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	addi	a0, a0, 11
	lw	a1, -36(s0)
	xor	a1, a1, a0
	lw	a0, -44(s0)
	add	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_41
.LBB0_41:                               # %for.inc206
                                        #   in Loop: Header=BB0_5 Depth=2
	lw	a0, -52(s0)
	addi	a0, a0, 1
	sw	a0, -52(s0)
	j	.LBB0_5
.LBB0_42:                               # %for.end208
                                        #   in Loop: Header=BB0_1 Depth=1
	j	.LBB0_43
.LBB0_43:                               # %for.inc209
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -48(s0)
	addi	a0, a0, 1
	sw	a0, -48(s0)
	j	.LBB0_1
.LBB0_44:                               # %for.end211
	li	a0, 0
	sw	a0, -64(s0)
	j	.LBB0_45
.LBB0_45:                               # %for.cond213
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_47 Depth 2
                                        #     Child Loop BB0_51 Depth 2
                                        #       Child Loop BB0_53 Depth 3
	lw	a0, -64(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_60
	j	.LBB0_46
.LBB0_46:                               # %for.body215
                                        #   in Loop: Header=BB0_45 Depth=1
	li	a0, 0
	sw	a0, -68(s0)
	j	.LBB0_47
.LBB0_47:                               # %for.cond217
                                        #   Parent Loop BB0_45 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a0, -68(s0)
	lw	a1, -24(s0)
	addi	a1, a1, 1
	bgeu	a0, a1, .LBB0_50
	j	.LBB0_48
.LBB0_48:                               # %for.body220
                                        #   in Loop: Header=BB0_47 Depth=2
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_49
.LBB0_49:                               # %for.inc224
                                        #   in Loop: Header=BB0_47 Depth=2
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	j	.LBB0_47
.LBB0_50:                               # %for.end226
                                        #   in Loop: Header=BB0_45 Depth=1
	li	a0, 0
	sw	a0, -72(s0)
	j	.LBB0_51
.LBB0_51:                               # %for.cond228
                                        #   Parent Loop BB0_45 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_53 Depth 3
	lw	a0, -72(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_58
	j	.LBB0_52
.LBB0_52:                               # %for.body230
                                        #   in Loop: Header=BB0_51 Depth=2
	li	a0, 0
	sw	a0, -76(s0)
	j	.LBB0_53
.LBB0_53:                               # %for.cond232
                                        #   Parent Loop BB0_45 Depth=1
                                        #     Parent Loop BB0_51 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -76(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_56
	j	.LBB0_54
.LBB0_54:                               # %for.body234
                                        #   in Loop: Header=BB0_53 Depth=3
	lw	a0, -12(s0)
	lw	a1, -64(s0)
	addi	a1, a1, 42
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	slli	a0, a1, 1
	add	a1, a1, a0
	lw	a0, -36(s0)
	xor	a1, a1, a0
	add	a0, a0, a1
	sw	a0, -36(s0)
	lw	a0, -16(s0)
	lw	a1, -40(s0)
	addi	a2, a1, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a0, a0, a2
	lw	a0, 0(a0)
	xor	a1, a1, a0
	lw	a0, -36(s0)
	add	a0, a0, a1
	sw	a0, -36(s0)
	j	.LBB0_55
.LBB0_55:                               # %for.inc246
                                        #   in Loop: Header=BB0_53 Depth=3
	lw	a0, -76(s0)
	addi	a0, a0, 1
	sw	a0, -76(s0)
	j	.LBB0_53
.LBB0_56:                               # %for.end248
                                        #   in Loop: Header=BB0_51 Depth=2
	j	.LBB0_57
.LBB0_57:                               # %for.inc249
                                        #   in Loop: Header=BB0_51 Depth=2
	lw	a0, -72(s0)
	addi	a0, a0, 1
	sw	a0, -72(s0)
	j	.LBB0_51
.LBB0_58:                               # %for.end251
                                        #   in Loop: Header=BB0_45 Depth=1
	j	.LBB0_59
.LBB0_59:                               # %for.inc252
                                        #   in Loop: Header=BB0_45 Depth=1
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB0_45
.LBB0_60:                               # %for.end254
	li	a0, 0
	sw	a0, -80(s0)
	j	.LBB0_61
.LBB0_61:                               # %for.cond256
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -80(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_64
	j	.LBB0_62
.LBB0_62:                               # %for.body258
                                        #   in Loop: Header=BB0_61 Depth=1
	lw	a0, -16(s0)
	lw	a1, -36(s0)
	addi	a1, a1, 55
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -20(s0)
	lw	a2, -44(s0)
	addi	a2, a2, 40
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	lw	a1, -16(s0)
	lw	a0, -44(s0)
	addi	a2, a0, 62
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	slli	a2, a1, 1
	slli	a1, a1, 3
	sub	a1, a1, a2
	add	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_63
.LBB0_63:                               # %for.inc270
                                        #   in Loop: Header=BB0_61 Depth=1
	lw	a0, -80(s0)
	addi	a0, a0, 1
	sw	a0, -80(s0)
	j	.LBB0_61
.LBB0_64:                               # %for.end272
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
