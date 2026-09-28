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
	beqz	a3, .LBB0_31
# %bb.1:                                # %for.body.lr.ph
	li	t0, 0
	addi	t1, a3, 51
	li	s5, 1
	li	a6, 2
	li	a7, 3
	j	.LBB0_3
.LBB0_2:                                # %for.inc212
                                        #   in Loop: Header=BB0_3 Depth=1
	addi	t0, t0, 1
	beq	t0, a3, .LBB0_32
.LBB0_3:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_6 Depth 2
                                        #       Child Loop BB0_9 Depth 3
	addi	a5, a7, 5
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lbu	a5, 0(a5)
	andi	a5, a5, 7
	beqz	a5, .LBB0_2
# %bb.4:                                # %for.body
                                        #   in Loop: Header=BB0_3 Depth=1
	beqz	a4, .LBB0_2
# %bb.5:                                # %for.body6.lr.ph
                                        #   in Loop: Header=BB0_3 Depth=1
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
# %bb.50:                               # %for.body6.lr.ph
                                        #   in Loop: Header=BB0_3 Depth=1
	lp.setup	x1, a4, .LBB0_45
.LBB0_6:                                # %for.body6
                                        #   Parent Loop BB0_3 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_9 Depth 3
	addi	a5, a6, 52
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lbu	a5, 0(a5)
	andi	a5, a5, 1
	bnez	a5, .LBB0_25
# %bb.7:                                # %if.else
                                        #   in Loop: Header=BB0_6 Depth=2
	addi	s3, a7, 29
	addi	s4, a7, 44
	addi	s6, a7, 54
	addi	a5, t2, -1
	andi	s0, s3, 63
	andi	s1, s4, 63
	andi	s3, s6, 63
	andi	a5, a5, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	slli	s3, s3, 2
	slli	a5, a5, 2
	add	s0, s0, a0
	add	s1, s1, a1
	add	s3, s3, a0
	add	s4, a1, a5
	lw	s6, 0(s0)
	lw	s1, 0(s1)
	lw	a5, 0(s3)
	lw	s0, 0(s4)
	add	s1, s1, s6
	slli	a5, a5, 1
	add	a5, a5, s0
	sub	a5, a5, s1
	andi	a5, a5, 7
	beqz	a5, .LBB0_30
# %bb.8:                                # %for.cond36.preheader
                                        #   in Loop: Header=BB0_6 Depth=2
	addi	a5, t2, 36
	addi	s0, t2, 60
	li	s9, 51
	andi	a5, a5, 63
	andi	s0, s0, 63
	sub	s6, t1, s9
	slli	a5, a5, 2
	slli	s0, s0, 2
	add	s3, a0, a5
	add	s4, a0, s0
	li	s8, 33
	.p2align	2
# %bb.51:                               # %for.cond36.preheader
                                        #   in Loop: Header=BB0_6 Depth=2
	lp.setup	x0, s6, .LBB0_46
.LBB0_9:                                # %for.body39
                                        #   Parent Loop BB0_3 Depth=1
                                        #     Parent Loop BB0_6 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	addi	s0, s9, -24
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lbu	s0, 0(s0)
	andi	s0, s0, 1
	bnez	s0, .LBB0_12
# %bb.10:                               # %if.else101
                                        #   in Loop: Header=BB0_9 Depth=3
	lw	s0, 0(s3)
	xor	s0, s0, a6
	andi	s0, s0, 1
	bnez	s0, .LBB0_15
# %bb.11:                               # %if.else129
                                        #   in Loop: Header=BB0_9 Depth=3
	addi	a5, a7, 33
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	slli	a7, a7, 1
	p.addun	s0, a5, a6, 31
	add	a6, a6, a5
	or	a7, a7, s0
	addi	s5, s5, 82
	j	.LBB0_22
.LBB0_12:                               # %if.then46
                                        #   in Loop: Header=BB0_9 Depth=3
	addi	s0, s9, -16
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lbu	s0, 0(s0)
	andi	s0, s0, 1
	bnez	s0, .LBB0_17
# %bb.13:                               # %if.else56
                                        #   in Loop: Header=BB0_9 Depth=3
	addi	s0, s9, -25
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	s0, 0(s0)
	xor	s0, s0, a6
	andi	s0, s0, 1
	bnez	s0, .LBB0_18
# %bb.14:                               # %if.else68
                                        #   in Loop: Header=BB0_9 Depth=3
	lw	s0, 0(t3)
	add	a7, a7, s0
	addi	a7, a7, 58
	j	.LBB0_19
.LBB0_15:                               # %if.then108
                                        #   in Loop: Header=BB0_9 Depth=3
	addi	s0, a7, 27
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lw	a5, 0(s0)
	slli	s0, a5, 1
	add	a5, a5, s0
	xor	a5, a5, s5
	andi	a5, a5, 7
	beqz	a5, .LBB0_23
# %bb.16:                               # %if.end118
                                        #   in Loop: Header=BB0_9 Depth=3
	addi	a5, a7, 1
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	s0, 0(t6)
	lw	a5, 0(a5)
	add	a5, a5, s0
	andi	s0, s8, 63
	slli	s0, s0, 2
	add	s0, s0, a2
	sw	a5, 0(s0)
	j	.LBB0_22
.LBB0_17:                               # %if.then52
                                        #   in Loop: Header=BB0_9 Depth=3
	xori	s6, s5, 343
	addi	s0, a7, 56
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a2
	sw	s6, 0(s0)
	j	.LBB0_20
.LBB0_18:                               # %if.then63
                                        #   in Loop: Header=BB0_9 Depth=3
	addi	s0, a7, 3
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	add	a7, a7, s0
.LBB0_19:                               # %if.end74
                                        #   in Loop: Header=BB0_9 Depth=3
	addi	a6, a6, 51
	andi	s0, a6, 63
	slli	s0, s0, 2
	add	s7, a0, s0
	lw	s6, 0(t4)
	lw	s0, 0(t5)
	lw	s7, 0(s7)
	add	s5, s5, s6
	add	s0, s0, s5
	add	s0, s0, s7
	addi	s5, s0, 208
.LBB0_20:                               # %if.end89
                                        #   in Loop: Header=BB0_9 Depth=3
	addi	s0, s9, -33
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a0
	lbu	s0, 0(s0)
	andi	s0, s0, 4
	beqz	s0, .LBB0_22
# %bb.21:                               # %if.then95
                                        #   in Loop: Header=BB0_9 Depth=3
	addi	s0, a6, 16
	andi	s0, s0, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	add	a7, a7, s0
.LBB0_22:                               # %if.end136
                                        #   in Loop: Header=BB0_9 Depth=3
	srli	a5, a6, 31
	andi	s0, s9, 63
	slli	s0, s0, 2
	add	s0, s0, a1
	lw	s0, 0(s0)
	lw	s1, 0(s4)
	slli	a7, a7, 1
	or	a7, a7, a5
	xor	a5, s0, a7
	add	s1, s1, s5
	add	s5, s1, a5
.LBB0_23:                               # Block address taken
                                        # %for.inc
                                        #   in Loop: Header=BB0_9 Depth=3
                                        # Label of block must be emitted
	addi	s9, s9, 1
.LBB0_46:                               #   in Loop: Header=BB0_9 Depth=3
                                        # Label of block must be emitted
	addi	s8, s8, 1
# %bb.24:                               # %for.cond.cleanup38
                                        #   in Loop: Header=BB0_6 Depth=2
	addi	a5, t2, 59
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	add	a6, a6, a5
	j	.LBB0_26
.LBB0_25:                               # %if.then11
                                        #   in Loop: Header=BB0_6 Depth=2
	addi	a5, t2, 37
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	add	s5, s5, a5
.LBB0_26:                               # %if.end153
                                        #   in Loop: Header=BB0_6 Depth=2
	addi	a5, t2, 51
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	xor	a5, a5, s5
	andi	a5, a5, 1
	bnez	a5, .LBB0_28
# %bb.27:                               # %for.cond.cleanup186
                                        #   in Loop: Header=BB0_6 Depth=2
	srli	a5, a6, 31
	slli	a7, a7, 1
	or	a7, a7, a5
	j	.LBB0_29
.LBB0_28:                               # %if.then161
                                        #   in Loop: Header=BB0_6 Depth=2
	addi	s3, s5, 11
	addi	s4, a7, 31
	addi	s6, t2, 52
	addi	a5, s5, 46
	andi	s0, s3, 63
	andi	s1, s4, 63
	andi	s3, s6, 63
	andi	a5, a5, 63
	slli	s0, s0, 2
	slli	s1, s1, 2
	slli	s3, s3, 2
	slli	s4, a5, 2
	add	s0, s0, a0
	add	s1, s1, a0
	add	s3, s3, a0
	lw	s6, 0(s0)
	lw	s1, 0(s1)
	lw	a5, 0(s3)
	add	s4, s4, a0
	lw	s0, 0(s4)
	add	a5, a5, s1
	add	a5, a5, s6
	add	a5, a5, s0
	sw	a5, 0(s2)
	addi	a6, a6, 5
.LBB0_29:                               # %if.end202
                                        #   in Loop: Header=BB0_6 Depth=2
	addi	a5, a6, 37
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	addi	a5, a5, 11
	xor	a5, a5, s5
	add	a7, a7, a5
.LBB0_30:                               # Block address taken
                                        # %for.inc209
                                        #   in Loop: Header=BB0_6 Depth=2
                                        # Label of block must be emitted
.LBB0_45:                               #   in Loop: Header=BB0_6 Depth=2
                                        # Label of block must be emitted
	addi	t2, t2, 1
	j	.LBB0_2
.LBB0_31:
	li	a7, 3
	li	a6, 2
	li	s5, 1
.LBB0_32:                               # %for.cond216.preheader
	beqz	a4, .LBB0_41
# %bb.33:                               # %for.cond221.preheader.lr.ph
	li	t1, 0
	addi	a5, a6, 30
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	addi	t0, a3, 1
	xor	t4, a5, a6
	srli	t2, a6, 31
.LBB0_34:                               # %for.cond221.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_35 Depth 2
                                        #     Child Loop BB0_37 Depth 2
                                        #       Child Loop BB0_38 Depth 3
	mv	s1, t0
	p.beqimm	a3, -1, .LBB0_36
.LBB0_35:                               # %for.body225
                                        #   Parent Loop BB0_34 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	slli	a7, a7, 1
	addi	s1, s1, -1
	or	a7, a7, t2
	bnez	s1, .LBB0_35
.LBB0_36:                               # %for.cond233.preheader
                                        #   in Loop: Header=BB0_34 Depth=1
	li	t3, 0
	addi	s1, t1, 42
	andi	s1, s1, 63
	slli	s1, s1, 2
	add	s1, s1, a0
	lw	s0, 0(s1)
	slli	s1, s0, 1
	add	s1, s1, s0
	.p2align	2
# %bb.52:                               # %for.cond233.preheader
                                        #   in Loop: Header=BB0_34 Depth=1
	lp.setup	x1, a4, .LBB0_47
.LBB0_37:                               # %for.cond238.preheader
                                        #   Parent Loop BB0_34 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_38 Depth 3
	mv	s0, a4
	.p2align	2
# %bb.53:                               # %for.cond238.preheader
                                        #   in Loop: Header=BB0_37 Depth=2
	lp.setup	x0, a4, .LBB0_48
.LBB0_38:                               # Block address taken
                                        # %for.body241
                                        #   Parent Loop BB0_34 Depth=1
                                        #     Parent Loop BB0_37 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
                                        # Label of block must be emitted
	xor	a5, s1, s5
	add	a5, a5, s5
.LBB0_48:                               #   in Loop: Header=BB0_38 Depth=3
                                        # Label of block must be emitted
	add	s5, a5, t4
.LBB0_39:                               # Block address taken
                                        # %for.cond.cleanup240
                                        #   in Loop: Header=BB0_37 Depth=2
                                        # Label of block must be emitted
.LBB0_47:                               #   in Loop: Header=BB0_37 Depth=2
                                        # Label of block must be emitted
	addi	t3, t3, 1
# %bb.40:                               # %for.cond.cleanup235
                                        #   in Loop: Header=BB0_34 Depth=1
	addi	t1, t1, 1
	bne	t1, a4, .LBB0_34
.LBB0_41:                               # %for.cond263.preheader
	beqz	a3, .LBB0_44
# %bb.42:                               # %for.body266.lr.ph
	addi	a0, s5, 55
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	.p2align	2
# %bb.54:                               # %for.body266.lr.ph
	lp.setup	x0, a3, .LBB0_49
.LBB0_43:                               # Block address taken
                                        # %for.body266
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lw	a4, 0(a0)
	addi	a5, a7, 40
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a2
	sw	a4, 0(a5)
	addi	a4, a7, 62
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a4, a4, a1
	lw	a4, 0(a4)
	slli	a5, a4, 1
	slli	a4, a4, 3
	sub	a4, a4, a5
.LBB0_49:                               #   in Loop: Header=BB0_43 Depth=1
                                        # Label of block must be emitted
	add	a7, a7, a4
.LBB0_44:                               # %for.cond.cleanup265
	xor	a0, a6, s5
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
	lw	s9, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 48
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
