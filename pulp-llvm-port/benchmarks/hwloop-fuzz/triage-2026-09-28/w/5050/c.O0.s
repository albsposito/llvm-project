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
                                        #     Child Loop BB0_25 Depth 2
                                        #       Child Loop BB0_27 Depth 3
                                        #     Child Loop BB0_4 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #     Child Loop BB0_16 Depth 2
                                        #       Child Loop BB0_18 Depth 3
	lw	a0, -48(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_42
	j	.LBB0_2
.LBB0_2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	lw	a0, -16(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 46
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 1
	beqz	a0, .LBB0_24
	j	.LBB0_3
.LBB0_3:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	li	a0, 0
	sw	a0, -52(s0)
	j	.LBB0_4
.LBB0_4:                                # %for.cond2
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_6 Depth 3
	lw	a1, -52(s0)
	li	a0, 1
	bltu	a0, a1, .LBB0_15
	j	.LBB0_5
.LBB0_5:                                # %for.body4
                                        #   in Loop: Header=BB0_4 Depth=2
	li	a0, 0
	sw	a0, -56(s0)
	j	.LBB0_6
.LBB0_6:                                # %for.cond5
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -56(s0)
	lw	a1, -24(s0)
	addi	a1, a1, 1
	bgeu	a0, a1, .LBB0_11
	j	.LBB0_7
.LBB0_7:                                # %for.body8
                                        #   in Loop: Header=BB0_6 Depth=3
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	lw	a0, -16(s0)
	lw	a1, -56(s0)
	addi	a1, a1, 24
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 7
	bnez	a0, .LBB0_9
	j	.LBB0_8
.LBB0_8:                                # %if.then17
                                        #   in Loop: Header=BB0_6 Depth=3
	j	.LBB0_10
.LBB0_9:                                # %if.end
                                        #   in Loop: Header=BB0_6 Depth=3
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_10
.LBB0_10:                               # %for.inc
                                        #   in Loop: Header=BB0_6 Depth=3
	lw	a0, -56(s0)
	addi	a0, a0, 1
	sw	a0, -56(s0)
	j	.LBB0_6
.LBB0_11:                               # %for.end
                                        #   in Loop: Header=BB0_4 Depth=2
	lw	a0, -16(s0)
	lw	a1, -36(s0)
	addi	a1, a1, 45
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 7
	bnez	a0, .LBB0_13
	j	.LBB0_12
.LBB0_12:                               # %if.then26
                                        #   in Loop: Header=BB0_4 Depth=2
	j	.LBB0_14
.LBB0_13:                               # %if.end27
                                        #   in Loop: Header=BB0_4 Depth=2
	j	.LBB0_14
.LBB0_14:                               # %for.inc28
                                        #   in Loop: Header=BB0_4 Depth=2
	lw	a0, -52(s0)
	addi	a0, a0, 1
	sw	a0, -52(s0)
	j	.LBB0_4
.LBB0_15:                               # %for.end30
                                        #   in Loop: Header=BB0_1 Depth=1
	li	a0, 0
	sw	a0, -60(s0)
	j	.LBB0_16
.LBB0_16:                               # %for.cond32
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_18 Depth 3
	lw	a0, -60(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_23
	j	.LBB0_17
.LBB0_17:                               # %for.body34
                                        #   in Loop: Header=BB0_16 Depth=2
	li	a0, 0
	sw	a0, -64(s0)
	j	.LBB0_18
.LBB0_18:                               # %for.cond36
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_16 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -64(s0)
	lw	a1, -28(s0)
	andi	a1, a1, 3
	bgeu	a0, a1, .LBB0_21
	j	.LBB0_19
.LBB0_19:                               # %for.body39
                                        #   in Loop: Header=BB0_18 Depth=3
	lw	a0, -12(s0)
	lw	a1, -64(s0)
	addi	a1, a1, 44
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -20(s0)
	lw	a2, -40(s0)
	addi	a2, a2, 43
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	lw	a0, -12(s0)
	lw	a1, -48(s0)
	addi	a1, a1, 2
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -44(s0)
	xor	a1, a1, a0
	add	a0, a0, a1
	sw	a0, -44(s0)
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_20
.LBB0_20:                               # %for.inc53
                                        #   in Loop: Header=BB0_18 Depth=3
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB0_18
.LBB0_21:                               # %for.end55
                                        #   in Loop: Header=BB0_16 Depth=2
	j	.LBB0_22
.LBB0_22:                               # %for.inc56
                                        #   in Loop: Header=BB0_16 Depth=2
	lw	a0, -60(s0)
	addi	a0, a0, 1
	sw	a0, -60(s0)
	j	.LBB0_16
.LBB0_23:                               # %for.end58
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -16(s0)
	lw	a2, -36(s0)
	addi	a1, a2, 19
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -20(s0)
	addi	a2, a2, 12
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB0_40
.LBB0_24:                               # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	li	a0, 0
	sw	a0, -68(s0)
	j	.LBB0_25
.LBB0_25:                               # %for.cond66
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_27 Depth 3
	lw	a0, -68(s0)
	lw	a1, -28(s0)
	bgeu	a0, a1, .LBB0_39
	j	.LBB0_26
.LBB0_26:                               # %for.body68
                                        #   in Loop: Header=BB0_25 Depth=2
	li	a0, 0
	sw	a0, -72(s0)
	j	.LBB0_27
.LBB0_27:                               # %for.cond70
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_25 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	a0, -72(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_32
	j	.LBB0_28
.LBB0_28:                               # %for.body72
                                        #   in Loop: Header=BB0_27 Depth=3
	lw	a0, -16(s0)
	lw	a1, -48(s0)
	addi	a1, a1, 48
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -40(s0)
	add	a0, a0, a1
	sw	a0, -40(s0)
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	addi	a1, a1, 3
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 7
	bnez	a0, .LBB0_30
	j	.LBB0_29
.LBB0_29:                               # %if.then82
                                        #   in Loop: Header=BB0_27 Depth=3
	j	.LBB0_31
.LBB0_30:                               # %if.end83
                                        #   in Loop: Header=BB0_27 Depth=3
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_31
.LBB0_31:                               # %for.inc87
                                        #   in Loop: Header=BB0_27 Depth=3
	lw	a0, -72(s0)
	addi	a0, a0, 1
	sw	a0, -72(s0)
	j	.LBB0_27
.LBB0_32:                               # %for.end89
                                        #   in Loop: Header=BB0_25 Depth=2
	lw	a0, -36(s0)
	addi	a0, a0, 330
	sw	a0, -36(s0)
	lw	a0, -36(s0)
	andi	a0, a0, 1
	beqz	a0, .LBB0_36
	j	.LBB0_33
.LBB0_33:                               # %if.then94
                                        #   in Loop: Header=BB0_25 Depth=2
	lw	a0, -12(s0)
	lw	a1, -68(s0)
	addi	a1, a1, 32
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -20(s0)
	lw	a2, -36(s0)
	addi	a2, a2, 44
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	lw	a0, -16(s0)
	lw	a1, -36(s0)
	addi	a1, a1, 5
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 7
	bnez	a0, .LBB0_35
	j	.LBB0_34
.LBB0_34:                               # %if.then106
                                        #   in Loop: Header=BB0_25 Depth=2
	j	.LBB0_38
.LBB0_35:                               # %if.end107
                                        #   in Loop: Header=BB0_25 Depth=2
	j	.LBB0_37
.LBB0_36:                               # %if.else108
                                        #   in Loop: Header=BB0_25 Depth=2
	lw	a0, -20(s0)
	lw	a1, -68(s0)
	addi	a1, a1, 15
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a1, a1, a0
	li	a0, 70
	sw	a0, 0(a1)
	j	.LBB0_37
.LBB0_37:                               # %if.end112
                                        #   in Loop: Header=BB0_25 Depth=2
	j	.LBB0_38
.LBB0_38:                               # %for.inc113
                                        #   in Loop: Header=BB0_25 Depth=2
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	j	.LBB0_25
.LBB0_39:                               # %for.end115
                                        #   in Loop: Header=BB0_1 Depth=1
	j	.LBB0_40
.LBB0_40:                               # %if.end116
                                        #   in Loop: Header=BB0_1 Depth=1
	j	.LBB0_41
.LBB0_41:                               # %for.inc117
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -48(s0)
	addi	a0, a0, 1
	sw	a0, -48(s0)
	j	.LBB0_1
.LBB0_42:                               # %for.end119
	li	a0, 0
	sw	a0, -76(s0)
	j	.LBB0_43
.LBB0_43:                               # %for.cond121
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_45 Depth 2
	lw	a0, -76(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB0_50
	j	.LBB0_44
.LBB0_44:                               # %for.body123
                                        #   in Loop: Header=BB0_43 Depth=1
	lw	a0, -44(s0)
	slli	a0, a0, 1
	lw	a1, -40(s0)
	srli	a1, a1, 31
	or	a0, a0, a1
	sw	a0, -44(s0)
	li	a0, 0
	sw	a0, -80(s0)
	j	.LBB0_45
.LBB0_45:                               # %for.cond128
                                        #   Parent Loop BB0_43 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a1, -80(s0)
	li	a0, 2
	bltu	a0, a1, .LBB0_48
	j	.LBB0_46
.LBB0_46:                               # %for.body130
                                        #   in Loop: Header=BB0_45 Depth=2
	lw	a0, -12(s0)
	lw	a1, -76(s0)
	addi	a1, a1, 52
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -36(s0)
	xor	a1, a1, a0
	add	a0, a0, a1
	sw	a0, -36(s0)
	j	.LBB0_47
.LBB0_47:                               # %for.inc136
                                        #   in Loop: Header=BB0_45 Depth=2
	lw	a0, -80(s0)
	addi	a0, a0, 1
	sw	a0, -80(s0)
	j	.LBB0_45
.LBB0_48:                               # %for.end138
                                        #   in Loop: Header=BB0_43 Depth=1
	j	.LBB0_49
.LBB0_49:                               # %for.inc139
                                        #   in Loop: Header=BB0_43 Depth=1
	lw	a0, -76(s0)
	addi	a0, a0, 1
	sw	a0, -76(s0)
	j	.LBB0_43
.LBB0_50:                               # %for.end141
	li	a0, 0
	sw	a0, -84(s0)
	j	.LBB0_51
.LBB0_51:                               # %for.cond143
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_59 Depth 2
	lw	a0, -84(s0)
	lw	a1, -28(s0)
	andi	a1, a1, 3
	bgeu	a0, a1, .LBB0_65
	j	.LBB0_52
.LBB0_52:                               # %for.body146
                                        #   in Loop: Header=BB0_51 Depth=1
	lw	a2, -12(s0)
	lw	a0, -44(s0)
	addi	a0, a0, 49
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a2
	lw	a0, 0(a0)
	lw	a1, -40(s0)
	addi	a3, a1, 46
	andi	a3, a3, 63
	slli	a3, a3, 2
	add	a2, a2, a3
	lw	a2, 0(a2)
	add	a0, a0, a2
	xor	a0, a0, a1
	andi	a0, a0, 7
	bnez	a0, .LBB0_54
	j	.LBB0_53
.LBB0_53:                               # %if.then157
                                        #   in Loop: Header=BB0_51 Depth=1
	j	.LBB0_64
.LBB0_54:                               # %if.end158
                                        #   in Loop: Header=BB0_51 Depth=1
	lw	a0, -16(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 1
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 1
	beqz	a0, .LBB0_56
	j	.LBB0_55
.LBB0_55:                               # %if.then164
                                        #   in Loop: Header=BB0_51 Depth=1
	lw	a0, -36(s0)
	xori	a1, a0, 37
	lw	a0, -40(s0)
	add	a0, a0, a1
	sw	a0, -40(s0)
	j	.LBB0_63
.LBB0_56:                               # %if.else167
                                        #   in Loop: Header=BB0_51 Depth=1
	lw	a0, -16(s0)
	lw	a1, -40(s0)
	addi	a1, a1, 12
	andi	a1, a1, 63
	slli	a1, a1, 2
	add	a0, a0, a1
	lbu	a0, 0(a0)
	andi	a0, a0, 7
	bnez	a0, .LBB0_58
	j	.LBB0_57
.LBB0_57:                               # %if.then173
                                        #   in Loop: Header=BB0_51 Depth=1
	j	.LBB0_64
.LBB0_58:                               # %if.end174
                                        #   in Loop: Header=BB0_51 Depth=1
	li	a0, 0
	sw	a0, -88(s0)
	j	.LBB0_59
.LBB0_59:                               # %for.cond176
                                        #   Parent Loop BB0_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a0, -88(s0)
	lw	a1, -24(s0)
	addi	a1, a1, 1
	bgeu	a0, a1, .LBB0_62
	j	.LBB0_60
.LBB0_60:                               # %for.body179
                                        #   in Loop: Header=BB0_59 Depth=2
	j	.LBB0_61
.LBB0_61:                               # %for.inc180
                                        #   in Loop: Header=BB0_59 Depth=2
	lw	a0, -88(s0)
	addi	a0, a0, 1
	sw	a0, -88(s0)
	j	.LBB0_59
.LBB0_62:                               # %for.end182
                                        #   in Loop: Header=BB0_51 Depth=1
	j	.LBB0_63
.LBB0_63:                               # %if.end183
                                        #   in Loop: Header=BB0_51 Depth=1
	j	.LBB0_64
.LBB0_64:                               # %for.inc184
                                        #   in Loop: Header=BB0_51 Depth=1
	lw	a0, -84(s0)
	addi	a0, a0, 1
	sw	a0, -84(s0)
	j	.LBB0_51
.LBB0_65:                               # %for.end186
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
