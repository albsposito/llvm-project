	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"v2bf16.fdiv.ll"
	.text
	.globl	f                               # -- Begin function f
	.p2align	1
	.type	f,@function
f:                                      # @f
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -16
	.cfi_def_cfa_offset 16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	sw	s1, 4(sp)                       # 4-byte Folded Spill
	sw	s2, 0(sp)                       # 4-byte Folded Spill
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	.cfi_offset s1, -12
	.cfi_offset s2, -16
                                        # kill: def $x13_w killed $x13_w def $x13
	mv	s2, a2
                                        # kill: def $x11_w killed $x11_w def $x11
	mv	s1, a0
	slli	a3, a3, 16
	slli	a1, a1, 16
	fdiv.s	a0, a1, a3
	call	__truncsfbf2
	slli	s0, a0, 16
	slli	s2, s2, 16
	slli	s1, s1, 16
	fdiv.s	a0, s1, s2
	call	__truncsfbf2
	p.bset	a0, a0, 15, 16
	pv.extract.h	a1, s0, 1
	p.bset	a1, a1, 15, 16
                                        # kill: def $x10_w killed $x10_w killed $x10
                                        # kill: def $x11_w killed $x11_w killed $x11
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	lw	s1, 4(sp)                       # 4-byte Folded Reload
	lw	s2, 0(sp)                       # 4-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	.cfi_restore s1
	.cfi_restore s2
	addi	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
