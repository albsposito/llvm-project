	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	addi	sp, sp, -96
	sw	ra, 92(sp)                      # 4-byte Folded Spill
	sw	s0, 88(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 96
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
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #       Child Loop BB0_12 Depth 3
	lw	a0, -48(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_23
	j	.LBB0_2
.LBB0_2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	li	a0, 0
	sw	a0, -52(s0)
	j	.LBB0_3
.LBB0_3:                                # %for.cond1
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_6 Depth 3
                                        #       Child Loop BB0_12 Depth 3
	lw	a0, -52(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_21
	j	.LBB0_4
.LBB0_4:                                # %for.body3
                                        #   in Loop: Header=BB0_3 Depth=2
	lw	a0, -16(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 62
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 1
	beqz	a0, .LBB0_18
	j	.LBB0_5
.LBB0_5:                                # %if.then
                                        #   in Loop: Header=BB0_3 Depth=2
	li	a0, 0
	sw	a0, -56(s0)
	j	.LBB0_6
.LBB0_6:                                # %for.cond5
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -56(s0)
	lw	a1, -24(s0)
	addi	a1, a1, 1
	bgeu	a0, a1, .LBB0_11
	j	.LBB0_7
.LBB0_7:                                # %for.body8
                                        #   in Loop: Header=BB0_6 Depth=3
	lw	a0, -16(s0)
	lw	a1, -56(s0)
	addi	a1, a1, 31
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -40(s0)
	xor	a0, a0, a1
	addi	a0, a0, 27
	andi	a0, a0, 7
	bnez	a0, .LBB0_9
	j	.LBB0_8
.LBB0_8:                                # %if.then15
                                        #   in Loop: Header=BB0_6 Depth=3
	j	.LBB0_10
.LBB0_9:                                # %if.end
                                        #   in Loop: Header=BB0_6 Depth=3
	j	.LBB0_10
.LBB0_10:                               # %for.inc
                                        #   in Loop: Header=BB0_6 Depth=3
	lw	a0, -56(s0)
	addi	a0, a0, 1
	sw	a0, -56(s0)
	j	.LBB0_6
.LBB0_11:                               # %for.end
                                        #   in Loop: Header=BB0_3 Depth=2
	lw	a0, -16(s0)
	lw	a1, -44(s0)
	addi	a1, a1, 37
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -20(s0)
	lw	a2, -40(s0)
	addi	a2, a2, 5
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	li	a0, 0
	sw	a0, -60(s0)
	j	.LBB0_12
.LBB0_12:                               # %for.cond23
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -60(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_17
	j	.LBB0_13
.LBB0_13:                               # %for.body25
                                        #   in Loop: Header=BB0_12 Depth=3
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	li	a0, 1
	bnez	a0, .LBB0_15
	j	.LBB0_14
.LBB0_14:                               # %if.then33
                                        #   in Loop: Header=BB0_12 Depth=3
	lw	a0, -16(s0)
	lw	a1, -60(s0)
	addi	a1, a1, 32
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	slli	a0, a1, 1
	add	a0, a0, a1
	lw	a3, -12(s0)
	lw	a2, -40(s0)
	addi	a1, a2, 46
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a1, a1, a3
	lw	a1, 0(a1)
	xor	a1, a1, a2
	add	a1, a1, a0
	lw	a0, -44(s0)
	addi	a0, a0, 47
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a3
	lw	a2, 0(a0)
	lw	a0, -36(s0)
	addi	a4, a0, 27
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a3, a3, a4
	lw	a3, 0(a3)
	add	a2, a2, a3
	add	a1, a1, a2
	add	a0, a0, a1
	sw	a0, -36(s0)
	lw	a1, -12(s0)
	lw	a0, -36(s0)
	addi	a2, a0, 28
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	sw	a0, -36(s0)
	j	.LBB0_15
.LBB0_15:                               # %if.end56
                                        #   in Loop: Header=BB0_12 Depth=3
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_16
.LBB0_16:                               # %for.inc60
                                        #   in Loop: Header=BB0_12 Depth=3
	lw	a0, -60(s0)
	addi	a0, a0, 1
	sw	a0, -60(s0)
	j	.LBB0_12
.LBB0_17:                               # %for.end62
                                        #   in Loop: Header=BB0_3 Depth=2
	j	.LBB0_19
.LBB0_18:                               # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	lw	a0, -12(s0)
	lw	a1, -52(s0)
	addi	a1, a1, 39
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -20(s0)
	lw	a2, -36(s0)
	addi	a2, a2, 40
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB0_19
.LBB0_19:                               # %if.end69
                                        #   in Loop: Header=BB0_3 Depth=2
	j	.LBB0_20
.LBB0_20:                               # %for.inc70
                                        #   in Loop: Header=BB0_3 Depth=2
	lw	a0, -52(s0)
	addi	a0, a0, 1
	sw	a0, -52(s0)
	j	.LBB0_3
.LBB0_21:                               # %for.end72
                                        #   in Loop: Header=BB0_1 Depth=1
	j	.LBB0_22
.LBB0_22:                               # %for.inc73
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -48(s0)
	addi	a0, a0, 1
	sw	a0, -48(s0)
	j	.LBB0_1
.LBB0_23:                               # %for.end75
	li	a0, 0
	sw	a0, -64(s0)
	j	.LBB0_24
.LBB0_24:                               # %for.cond77
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -64(s0)
	lw	a1, -32(s0)
	bgeu	a0, a1, .LBB0_27
	j	.LBB0_25
.LBB0_25:                               # %for.body79
                                        #   in Loop: Header=BB0_24 Depth=1
	lw	a1, -12(s0)
	lw	a0, -40(s0)
	addi	a2, a0, 12
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	sw	a0, -40(s0)
	j	.LBB0_26
.LBB0_26:                               # %for.inc84
                                        #   in Loop: Header=BB0_24 Depth=1
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB0_24
.LBB0_27:                               # %for.end86
	li	a0, 0
	sw	a0, -68(s0)
	j	.LBB0_28
.LBB0_28:                               # %for.cond88
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_34 Depth 2
                                        #       Child Loop BB0_36 Depth 3
                                        #     Child Loop BB0_42 Depth 2
                                        #     Child Loop BB0_48 Depth 2
                                        #       Child Loop BB0_53 Depth 3
                                        #     Child Loop BB0_65 Depth 2
                                        #       Child Loop BB0_67 Depth 3
	lw	a0, -68(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_74
	j	.LBB0_29
.LBB0_29:                               # %for.body90
                                        #   in Loop: Header=BB0_28 Depth=1
	lw	a0, -36(s0)
	addi	a0, a0, 53
	sw	a0, -36(s0)
	lw	a0, -16(s0)
	lw	a1, -36(s0)
	addi	a1, a1, 54
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 1
	beqz	a0, .LBB0_33
	j	.LBB0_30
.LBB0_30:                               # %if.then97
                                        #   in Loop: Header=BB0_28 Depth=1
	lw	a5, -12(s0)
	lw	a2, -36(s0)
	addi	a0, a2, 21
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a5
	lw	a0, 0(a0)
	lw	a3, -16(s0)
	lw	a4, -40(s0)
	addi	a1, a4, 26
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a1, a1, a3
	lw	a1, 0(a1)
	addi	a6, a4, 30
	andi	a6, a6, 63
	slli	a6, a6, 2
	add	a5, a5, a6
	lw	a5, 0(a5)
	add	a1, a1, a5
	add	a0, a0, a1
	addi	a1, a4, 58
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a1, a1, a3
	lw	a1, 0(a1)
	addi	a4, a4, 28
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a3, a3, a4
	lw	a3, 0(a3)
	add	a1, a1, a3
	xor	a1, a1, a2
	add	a0, a0, a1
	andi	a0, a0, 7
	bnez	a0, .LBB0_32
	j	.LBB0_31
.LBB0_31:                               # %if.then120
                                        #   in Loop: Header=BB0_28 Depth=1
	j	.LBB0_73
.LBB0_32:                               # %if.end121
                                        #   in Loop: Header=BB0_28 Depth=1
	j	.LBB0_64
.LBB0_33:                               # %if.else122
                                        #   in Loop: Header=BB0_28 Depth=1
	li	a0, 0
	sw	a0, -72(s0)
	j	.LBB0_34
.LBB0_34:                               # %for.cond124
                                        #   Parent Loop BB0_28 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_36 Depth 3
	lw	a1, -72(s0)
	li	a0, 5
	bltu	a0, a1, .LBB0_41
	j	.LBB0_35
.LBB0_35:                               # %for.body126
                                        #   in Loop: Header=BB0_34 Depth=2
	li	a0, 0
	sw	a0, -76(s0)
	j	.LBB0_36
.LBB0_36:                               # %for.cond128
                                        #   Parent Loop BB0_28 Depth=1
                                        #     Parent Loop BB0_34 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -76(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_39
	j	.LBB0_37
.LBB0_37:                               # %for.body130
                                        #   in Loop: Header=BB0_36 Depth=3
	lw	a0, -16(s0)
	lw	a1, -76(s0)
	addi	a1, a1, 10
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -20(s0)
	lw	a2, -36(s0)
	addi	a2, a2, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB0_38
.LBB0_38:                               # %for.inc137
                                        #   in Loop: Header=BB0_36 Depth=3
	lw	a0, -76(s0)
	addi	a0, a0, 1
	sw	a0, -76(s0)
	j	.LBB0_36
.LBB0_39:                               # %for.end139
                                        #   in Loop: Header=BB0_34 Depth=2
	j	.LBB0_40
.LBB0_40:                               # %for.inc140
                                        #   in Loop: Header=BB0_34 Depth=2
	lw	a0, -72(s0)
	addi	a0, a0, 1
	sw	a0, -72(s0)
	j	.LBB0_34
.LBB0_41:                               # %for.end142
                                        #   in Loop: Header=BB0_28 Depth=1
	li	a0, 0
	sw	a0, -80(s0)
	j	.LBB0_42
.LBB0_42:                               # %for.cond144
                                        #   Parent Loop BB0_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a0, -80(s0)
	lw	a1, -28(s0)
	andi	a1, a1, 3
	bgeu	a0, a1, .LBB0_45
	j	.LBB0_43
.LBB0_43:                               # %for.body147
                                        #   in Loop: Header=BB0_42 Depth=2
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	addi	a1, a1, 34
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -40(s0)
	add	a0, a0, a1
	sw	a0, -40(s0)
	lw	a0, -12(s0)
	lw	a1, -80(s0)
	addi	a1, a1, 5
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
	j	.LBB0_44
.LBB0_44:                               # %for.inc159
                                        #   in Loop: Header=BB0_42 Depth=2
	lw	a0, -80(s0)
	addi	a0, a0, 1
	sw	a0, -80(s0)
	j	.LBB0_42
.LBB0_45:                               # %for.end161
                                        #   in Loop: Header=BB0_28 Depth=1
	lw	a0, -16(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 44
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 1
	beqz	a0, .LBB0_63
	j	.LBB0_46
.LBB0_46:                               # %if.then167
                                        #   in Loop: Header=BB0_28 Depth=1
	lw	a0, -36(s0)
	xori	a0, a0, 1
	andi	a0, a0, 3
	beqz	a0, .LBB0_62
	j	.LBB0_47
.LBB0_47:                               # %if.then171
                                        #   in Loop: Header=BB0_28 Depth=1
	li	a0, 0
	sw	a0, -84(s0)
	j	.LBB0_48
.LBB0_48:                               # %for.cond173
                                        #   Parent Loop BB0_28 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_53 Depth 3
	lw	a0, -84(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_61
	j	.LBB0_49
.LBB0_49:                               # %for.body175
                                        #   in Loop: Header=BB0_48 Depth=2
	lw	a0, -36(s0)
	andi	a0, a0, 1
	beqz	a0, .LBB0_58
	j	.LBB0_50
.LBB0_50:                               # %if.then185
                                        #   in Loop: Header=BB0_48 Depth=2
	lw	a1, -16(s0)
	lw	a0, -40(s0)
	addi	a0, a0, 27
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a2, -36(s0)
	addi	a2, a2, 62
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a3, 0(a1)
	lw	a1, -12(s0)
	lw	a2, -84(s0)
	addi	a4, a2, 44
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a4, a4, a1
	lw	a4, 0(a4)
	add	a3, a3, a4
	add	a0, a0, a3
	addi	a2, a2, 3
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	andi	a0, a0, 1
	beqz	a0, .LBB0_52
	j	.LBB0_51
.LBB0_51:                               # %if.then203
                                        #   in Loop: Header=BB0_48 Depth=2
	lw	a0, -12(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 2
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -20(s0)
	lw	a2, -36(s0)
	addi	a2, a2, 60
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	lw	a1, -12(s0)
	lw	a0, -44(s0)
	addi	a2, a0, 24
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	sw	a0, -44(s0)
	lw	a0, -12(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 30
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -20(s0)
	lw	a2, -68(s0)
	addi	a2, a2, 49
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB0_57
.LBB0_52:                               # %if.else220
                                        #   in Loop: Header=BB0_48 Depth=2
	li	a0, 0
	sw	a0, -88(s0)
	j	.LBB0_53
.LBB0_53:                               # %for.cond222
                                        #   Parent Loop BB0_28 Depth=1
                                        #     Parent Loop BB0_48 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -88(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_56
	j	.LBB0_54
.LBB0_54:                               # %for.body224
                                        #   in Loop: Header=BB0_53 Depth=3
	lw	a4, -12(s0)
	lw	a3, -84(s0)
	addi	a0, a3, 53
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a4
	lw	a1, 0(a0)
	lw	a2, -16(s0)
	lw	a0, -36(s0)
	addi	a5, a0, 18
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a2
	lw	a5, 0(a5)
	add	a1, a1, a5
	xor	a1, a1, a0
	lw	a5, -88(s0)
	addi	a6, a5, 11
	andi	a6, a6, 63
	slli	a6, a6, 2
	add	a2, a2, a6
	lw	a2, 0(a2)
	xor	a2, a2, a0
	addi	a3, a3, 42
	andi	a3, a3, 63
	slli	a3, a3, 2
	add	a3, a3, a4
	lw	a3, 0(a3)
	addi	a5, a5, 56
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a4, a4, a5
	lw	a4, 0(a4)
	add	a3, a3, a4
	add	a2, a2, a3
	add	a1, a1, a2
	add	a0, a0, a1
	sw	a0, -36(s0)
	j	.LBB0_55
.LBB0_55:                               # %for.inc247
                                        #   in Loop: Header=BB0_53 Depth=3
	lw	a0, -88(s0)
	addi	a0, a0, 1
	sw	a0, -88(s0)
	j	.LBB0_53
.LBB0_56:                               # %for.end249
                                        #   in Loop: Header=BB0_48 Depth=2
	lw	a0, -16(s0)
	lw	a1, -84(s0)
	addi	a1, a1, 43
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -40(s0)
	add	a0, a0, a1
	addi	a0, a0, 38
	sw	a0, -40(s0)
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_57
.LBB0_57:                               # %if.end258
                                        #   in Loop: Header=BB0_48 Depth=2
	j	.LBB0_59
.LBB0_58:                               # %if.else259
                                        #   in Loop: Header=BB0_48 Depth=2
	lw	a0, -20(s0)
	lw	a1, -36(s0)
	addi	a1, a1, 2
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a1, a1, a0
	li	a0, 23
	sw	a0, 0(a1)
	j	.LBB0_59
.LBB0_59:                               # %if.end263
                                        #   in Loop: Header=BB0_48 Depth=2
	j	.LBB0_60
.LBB0_60:                               # %for.inc264
                                        #   in Loop: Header=BB0_48 Depth=2
	lw	a0, -84(s0)
	addi	a0, a0, 1
	sw	a0, -84(s0)
	j	.LBB0_48
.LBB0_61:                               # %for.end266
                                        #   in Loop: Header=BB0_28 Depth=1
	j	.LBB0_62
.LBB0_62:                               # %if.end267
                                        #   in Loop: Header=BB0_28 Depth=1
	lw	a0, -36(s0)
	addi	a0, a0, 60
	sw	a0, -36(s0)
	j	.LBB0_63
.LBB0_63:                               # %if.end271
                                        #   in Loop: Header=BB0_28 Depth=1
	j	.LBB0_64
.LBB0_64:                               # %if.end272
                                        #   in Loop: Header=BB0_28 Depth=1
	li	a0, 0
	sw	a0, -92(s0)
	j	.LBB0_65
.LBB0_65:                               # %for.cond274
                                        #   Parent Loop BB0_28 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_67 Depth 3
	lw	a1, -92(s0)
	li	a0, 7
	bltu	a0, a1, .LBB0_72
	j	.LBB0_66
.LBB0_66:                               # %for.body276
                                        #   in Loop: Header=BB0_65 Depth=2
	lw	a1, -12(s0)
	lw	a0, -36(s0)
	addi	a2, a0, 42
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	xor	a1, a1, a0
	lw	a2, -44(s0)
	xor	a1, a1, a2
	add	a0, a0, a1
	sw	a0, -36(s0)
	li	a0, 0
	sw	a0, -96(s0)
	j	.LBB0_67
.LBB0_67:                               # %for.cond284
                                        #   Parent Loop BB0_28 Depth=1
                                        #     Parent Loop BB0_65 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -96(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_70
	j	.LBB0_68
.LBB0_68:                               # %for.body286
                                        #   in Loop: Header=BB0_67 Depth=3
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_69
.LBB0_69:                               # %for.inc293
                                        #   in Loop: Header=BB0_67 Depth=3
	lw	a0, -96(s0)
	addi	a0, a0, 1
	sw	a0, -96(s0)
	j	.LBB0_67
.LBB0_70:                               # %for.end295
                                        #   in Loop: Header=BB0_65 Depth=2
	j	.LBB0_71
.LBB0_71:                               # %for.inc296
                                        #   in Loop: Header=BB0_65 Depth=2
	lw	a0, -92(s0)
	addi	a0, a0, 1
	sw	a0, -92(s0)
	j	.LBB0_65
.LBB0_72:                               # %for.end298
                                        #   in Loop: Header=BB0_28 Depth=1
	j	.LBB0_73
.LBB0_73:                               # %for.inc299
                                        #   in Loop: Header=BB0_28 Depth=1
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	j	.LBB0_28
.LBB0_74:                               # %for.end301
	lw	a0, -36(s0)
	lw	a1, -40(s0)
	xor	a0, a0, a1
	lw	a1, -44(s0)
	xor	a0, a0, a1
	lw	ra, 92(sp)                      # 4-byte Folded Reload
	lw	s0, 88(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 96
	ret
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
