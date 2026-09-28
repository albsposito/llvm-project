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
	beqz	a3, .LBB0_31
# %bb.1:                                # %for.body.lr.ph
	beqz	a4, .LBB0_48
# %bb.2:                                # %for.body.us.preheader
	li	t0, 0
	addi	t1, a3, 51
	li	s8, 1
	li	a6, 2
	li	a7, 3
	j	.LBB0_4
.LBB0_3:                                # %for.inc212.us
                                        #   in Loop: Header=BB0_4 Depth=1
	addi	t0, t0, 1
	beq	t0, a3, .LBB0_32
.LBB0_4:                                # %for.body.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_9 Depth 2
                                        #       Child Loop BB0_15 Depth 3
	addi	s1, a7, 5
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lbu	s1, 0(s1)
	andi	s1, s1, 7
	beqz	s1, .LBB0_3
# %bb.5:                                # %for.cond3.preheader.us
                                        #   in Loop: Header=BB0_4 Depth=1
	li	t2, 0
	addi	t3, t0, 8
	addi	t4, t0, 52
	addi	t5, t0, 41
	addi	a5, t0, 22
	andi	s1, t3, 63
	andi	s0, t4, 63
	andi	t3, t5, 63
	andi	a5, a5, 63
	slli	s1, s1, 2
	slli	s0, s0, 2
	slli	t5, t3, 2
	slli	a5, a5, 2
	add	t3, a1, s1
	add	t4, a0, s0
	add	t5, t5, a0
	add	t6, a1, a5
	add	s2, a2, s0
	.p2align	2
# %bb.61:                               # %for.cond3.preheader.us
                                        #   in Loop: Header=BB0_4 Depth=1
	lp.setup	x1, a4, .LBB0_52
.LBB0_9:                                # %for.body6.us
                                        #   Parent Loop BB0_4 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_15 Depth 3
	addi	s0, a6, 52
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lbu	s0, 0(s0)
	andi	s0, s0, 1
	bnez	s0, .LBB0_27
# %bb.10:                               # %if.else.us
                                        #   in Loop: Header=BB0_9 Depth=2
	addi	s3, a7, 29
	addi	s4, a7, 44
	addi	s5, a7, 54
	addi	s1, t2, -1
	andi	s0, s3, 63
	andi	s3, s4, 63
	andi	s4, s5, 63
	andi	s1, s1, 63
	slli	s0, s0, 2
	slli	s3, s3, 2
	slli	s4, s4, 2
	slli	s1, s1, 2
	add	s0, s0, a0
	add	s3, s3, a1
	add	s4, s4, a0
	add	s6, a1, s1
	lw	s5, 0(s0)
	lw	s0, 0(s3)
	lw	s1, 0(s4)
	lw	s3, 0(s6)
	add	s0, s0, s5
	slli	s1, s1, 1
	add	s1, s1, s3
	sub	s1, s1, s0
	andi	s1, s1, 7
	beqz	s1, .LBB0_8
# %bb.11:                               # %for.cond36.preheader.us
                                        #   in Loop: Header=BB0_9 Depth=2
	addi	a5, t2, 36
	addi	s0, t2, 60
	li	s7, 51
	andi	a5, a5, 63
	andi	s0, s0, 63
	sub	s1, t1, s7
	slli	a5, a5, 2
	slli	s0, s0, 2
	add	s3, a0, a5
	add	s4, a0, s0
	.p2align	2
# %bb.62:                               # %for.cond36.preheader.us
                                        #   in Loop: Header=BB0_9 Depth=2
	lp.setup	x0, s1, .LBB0_53
.LBB0_15:                               # %for.body39.us
                                        #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_9 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	addi	s1, s7, -24
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lbu	s1, 0(s1)
	andi	s1, s1, 1
	bnez	s1, .LBB0_19
# %bb.16:                               # %if.else101.us
                                        #   in Loop: Header=BB0_15 Depth=3
	lw	s1, 0(s3)
	xor	s1, s1, a6
	andi	s1, s1, 1
	beqz	s1, .LBB0_12
# %bb.17:                               # %if.then108.us
                                        #   in Loop: Header=BB0_15 Depth=3
	addi	s1, a7, 27
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lw	s5, 0(s1)
	slli	s1, s5, 1
	add	s1, s1, s5
	xor	s1, s1, s8
	andi	s1, s1, 7
	beqz	s1, .LBB0_14
# %bb.18:                               # %if.end118.us
                                        #   in Loop: Header=BB0_15 Depth=3
	addi	s1, a7, 1
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s5, a1, s1
	lw	s6, 0(t6)
	lw	s1, 0(s5)
	add	s1, s1, s6
	addi	s0, s7, -18
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a2
	sw	s1, 0(s0)
	j	.LBB0_13
.LBB0_19:                               # %if.then46.us
                                        #   in Loop: Header=BB0_15 Depth=3
	addi	s1, s7, -16
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lbu	s1, 0(s1)
	andi	s1, s1, 1
	bnez	s1, .LBB0_22
# %bb.20:                               # %if.else56.us
                                        #   in Loop: Header=BB0_15 Depth=3
	addi	s1, s7, -25
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lw	s1, 0(s1)
	xor	s1, s1, a6
	andi	s1, s1, 1
	bnez	s1, .LBB0_23
# %bb.21:                               # %if.else68.us
                                        #   in Loop: Header=BB0_15 Depth=3
	lw	s1, 0(t3)
	add	a7, a7, s1
	addi	a7, a7, 58
	j	.LBB0_24
.LBB0_22:                               # %if.then52.us
                                        #   in Loop: Header=BB0_15 Depth=3
	xori	s5, s8, 343
	addi	s1, a7, 56
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a2
	sw	s5, 0(s1)
	j	.LBB0_25
.LBB0_23:                               # %if.then63.us
                                        #   in Loop: Header=BB0_15 Depth=3
	addi	s1, a7, 3
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lw	s1, 0(s1)
	add	a7, a7, s1
.LBB0_24:                               # %if.end74.us
                                        #   in Loop: Header=BB0_15 Depth=3
	addi	a6, a6, 51
	andi	s1, a6, 63
	slli	s1, s1, 2
	add	s6, a0, s1
	lw	s5, 0(t4)
	lw	s1, 0(t5)
	lw	s6, 0(s6)
	add	a5, s8, s5
	add	a5, a5, s1
	add	a5, a5, s6
	addi	s8, a5, 208
.LBB0_25:                               # %if.end89.us
                                        #   in Loop: Header=BB0_15 Depth=3
	addi	s1, s7, -33
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lbu	s1, 0(s1)
	andi	s1, s1, 4
	beqz	s1, .LBB0_13
# %bb.26:                               # %if.then95.us
                                        #   in Loop: Header=BB0_15 Depth=3
	addi	s1, a6, 16
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lw	s1, 0(s1)
	add	a7, a7, s1
	j	.LBB0_13
.LBB0_12:                               # %if.else129.us
                                        #   in Loop: Header=BB0_15 Depth=3
	addi	s0, a7, 33
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	slli	a7, a7, 1
	p.addun	s1, s0, a6, 31
	add	a6, a6, s0
	or	a7, a7, s1
	addi	s8, s8, 82
.LBB0_13:                               # %if.end136.us
                                        #   in Loop: Header=BB0_15 Depth=3
	srli	s0, a6, 31
	andi	s1, s7, 63
	slli	s1, s1, 2
	add	s1, s1, a1
	lw	s1, 0(s1)
	lw	a5, 0(s4)
	slli	a7, a7, 1
	or	a7, a7, s0
	xor	s0, s1, a7
	add	a5, a5, s8
	add	s8, a5, s0
.LBB0_14:                               # Block address taken
                                        # %for.inc.us
                                        #   in Loop: Header=BB0_15 Depth=3
                                        # Label of block must be emitted
.LBB0_53:                               #   in Loop: Header=BB0_15 Depth=3
                                        # Label of block must be emitted
	addi	s7, s7, 1
	j	.LBB0_28
.LBB0_27:                               # %if.then11.us
                                        #   in Loop: Header=BB0_9 Depth=2
	addi	s0, t2, 37
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	add	s8, s8, s0
	j	.LBB0_29
.LBB0_28:                               # %for.cond.cleanup38.us
                                        #   in Loop: Header=BB0_9 Depth=2
	addi	s0, t2, 59
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s0, 0(s0)
	add	a6, a6, s0
.LBB0_29:                               # %if.end153.us
                                        #   in Loop: Header=BB0_9 Depth=2
	addi	s0, t2, 51
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s0, 0(s0)
	xor	s0, s0, s8
	andi	s0, s0, 1
	bnez	s0, .LBB0_6
# %bb.30:                               # %for.cond183.us.preheader
                                        #   in Loop: Header=BB0_9 Depth=2
	srli	s0, a6, 31
	slli	a7, a7, 1
	or	a7, a7, s0
	j	.LBB0_7
.LBB0_6:                                # %if.then161.us
                                        #   in Loop: Header=BB0_9 Depth=2
	addi	s3, s8, 11
	addi	s4, a7, 31
	addi	s5, t2, 52
	addi	s1, s8, 46
	andi	s0, s3, 63
	andi	s3, s4, 63
	andi	s4, s5, 63
	andi	s1, s1, 63
	slli	s0, s0, 2
	slli	s3, s3, 2
	slli	s4, s4, 2
	slli	s5, s1, 2
	add	s0, s0, a0
	add	s3, s3, a0
	add	s4, s4, a0
	lw	s6, 0(s0)
	lw	s3, 0(s3)
	lw	s0, 0(s4)
	add	s5, s5, a0
	lw	s1, 0(s5)
	add	s0, s0, s3
	add	s0, s0, s6
	add	s0, s0, s1
	sw	s0, 0(s2)
	addi	a6, a6, 5
.LBB0_7:                                # %if.end202.us
                                        #   in Loop: Header=BB0_9 Depth=2
	addi	s0, a6, 37
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	addi	s0, s0, 11
	xor	s0, s0, s8
	add	a7, a7, s0
.LBB0_8:                                # Block address taken
                                        # %for.inc209.us
                                        #   in Loop: Header=BB0_9 Depth=2
                                        # Label of block must be emitted
.LBB0_52:                               #   in Loop: Header=BB0_9 Depth=2
                                        # Label of block must be emitted
	addi	t2, t2, 1
	j	.LBB0_3
.LBB0_31:
	li	a7, 3
	li	a6, 2
	li	s8, 1
.LBB0_32:                               # %for.cond216.preheader
	beqz	a4, .LBB0_47
# %bb.33:                               # %for.cond221.preheader.lr.ph
	addi	a5, a6, 30
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	addi	t0, a3, 1
	xor	t4, a5, a6
	bnez	t0, .LBB0_39
.LBB0_34:                               # %for.cond221.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_35 Depth 2
                                        #       Child Loop BB0_36 Depth 3
	li	t1, 0
	addi	a5, t0, 42
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	s0, 0(a5)
	slli	a5, s0, 1
	add	s0, s0, a5
	.p2align	2
# %bb.63:                               # %for.cond221.preheader
                                        #   in Loop: Header=BB0_34 Depth=1
	lp.setup	x1, a4, .LBB0_54
.LBB0_35:                               # %for.cond238.preheader
                                        #   Parent Loop BB0_34 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_36 Depth 3
	mv	s1, a4
	.p2align	2
# %bb.64:                               # %for.cond238.preheader
                                        #   in Loop: Header=BB0_35 Depth=2
	lp.setup	x0, a4, .LBB0_55
.LBB0_36:                               # Block address taken
                                        # %for.body241
                                        #   Parent Loop BB0_34 Depth=1
                                        #     Parent Loop BB0_35 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
                                        # Label of block must be emitted
	xor	a5, s0, s8
	add	a5, a5, s8
.LBB0_55:                               #   in Loop: Header=BB0_36 Depth=3
                                        # Label of block must be emitted
	add	s8, a5, t4
.LBB0_37:                               # Block address taken
                                        # %for.cond.cleanup240
                                        #   in Loop: Header=BB0_35 Depth=2
                                        # Label of block must be emitted
.LBB0_54:                               #   in Loop: Header=BB0_35 Depth=2
                                        # Label of block must be emitted
	addi	t1, t1, 1
# %bb.38:                               # %for.cond.cleanup235
                                        #   in Loop: Header=BB0_34 Depth=1
	addi	t0, t0, 1
	bne	t0, a4, .LBB0_34
	j	.LBB0_47
.LBB0_39:                               # %for.cond221.preheader.us.preheader
	li	t1, 0
	srli	t2, a6, 31
.LBB0_40:                               # %for.cond221.preheader.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_41 Depth 2
                                        #     Child Loop BB0_43 Depth 2
                                        #       Child Loop BB0_44 Depth 3
	mv	s1, t0
	.p2align	2
# %bb.65:                               # %for.cond221.preheader.us
                                        #   in Loop: Header=BB0_40 Depth=1
	lp.setup	x0, t0, .LBB0_56
.LBB0_60:                               #   in Loop: Header=BB0_40 Depth=1
	nop
.LBB0_41:                               # Block address taken
                                        # %for.body225.us
                                        #   Parent Loop BB0_40 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
                                        # Label of block must be emitted
	slli	a7, a7, 1
.LBB0_56:                               #   in Loop: Header=BB0_41 Depth=2
                                        # Label of block must be emitted
	or	a7, a7, t2
# %bb.42:                               # %for.cond221.for.cond233.preheader_crit_edge.us
                                        #   in Loop: Header=BB0_40 Depth=1
	li	t3, 0
	addi	a5, t1, 42
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	s0, 0(a5)
	slli	a5, s0, 1
	add	s0, s0, a5
	.p2align	2
# %bb.66:                               # %for.cond221.for.cond233.preheader_crit_edge.us
                                        #   in Loop: Header=BB0_40 Depth=1
	lp.setup	x1, a4, .LBB0_57
.LBB0_43:                               # %for.cond238.preheader.us
                                        #   Parent Loop BB0_40 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_44 Depth 3
	mv	s1, a4
	.p2align	2
# %bb.67:                               # %for.cond238.preheader.us
                                        #   in Loop: Header=BB0_43 Depth=2
	lp.setup	x0, a4, .LBB0_58
.LBB0_44:                               # Block address taken
                                        # %for.body241.us
                                        #   Parent Loop BB0_40 Depth=1
                                        #     Parent Loop BB0_43 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
                                        # Label of block must be emitted
	xor	a5, s0, s8
	add	a5, a5, s8
.LBB0_58:                               #   in Loop: Header=BB0_44 Depth=3
                                        # Label of block must be emitted
	add	s8, a5, t4
.LBB0_45:                               # Block address taken
                                        # %for.cond.cleanup240.us
                                        #   in Loop: Header=BB0_43 Depth=2
                                        # Label of block must be emitted
.LBB0_57:                               #   in Loop: Header=BB0_43 Depth=2
                                        # Label of block must be emitted
	addi	t3, t3, 1
# %bb.46:                               # %for.cond.cleanup235.us
                                        #   in Loop: Header=BB0_40 Depth=1
	addi	t1, t1, 1
	bne	t1, a4, .LBB0_40
.LBB0_47:                               # %for.cond263.preheader
	bnez	a3, .LBB0_49
	j	.LBB0_51
.LBB0_48:
	li	a6, 2
	li	s8, 1
	li	a7, 3
.LBB0_49:                               # %for.body266.lr.ph
	addi	a0, s8, 55
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	.p2align	2
# %bb.68:                               # %for.body266.lr.ph
	lp.setup	x0, a3, .LBB0_59
.LBB0_50:                               # Block address taken
                                        # %for.body266
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	addi	a4, a7, 40
	addi	a5, a7, 62
	andi	a4, a4, 63
	andi	a5, a5, 63
	slli	a4, a4, 2
	slli	a5, a5, 2
	add	a4, a4, a2
	add	a5, a5, a1
	sw	a0, 0(a4)
	lw	a4, 0(a5)
	slli	a5, a4, 1
	slli	a4, a4, 3
	sub	a4, a4, a5
.LBB0_59:                               #   in Loop: Header=BB0_50 Depth=1
                                        # Label of block must be emitted
	add	a7, a7, a4
.LBB0_51:                               # %for.cond.cleanup265
	xor	a0, a6, s8
	xor	a0, a0, a7
	lw	s0, 44(sp)                      # 4-byte Folded Reload
	lw	s1, 40(sp)                      # 4-byte Folded Reload
	lw	s2, 36(sp)                      # 4-byte Folded Reload
	lw	s3, 32(sp)                      # 4-byte Folded Reload
	lw	s4, 28(sp)                      # 4-byte Folded Reload
	lw	s5, 24(sp)                      # 4-byte Folded Reload
	lw	s6, 20(sp)                      # 4-byte Folded Reload
	lw	s7, 16(sp)                      # 4-byte Folded Reload
	lw	s8, 12(sp)                      # 4-byte Folded Reload
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
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
