	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"v2bf16.fabs.ll"
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
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	.cfi_offset s1, -12
                                        # kill: def $x11_w killed $x11_w def $x11
	mv	s0, a0
	slli	a0, a1, 17
	srli	a0, a0, 1
                                        # kill: def $x10_w killed $x10_w killed $x10
	call	__truncsfbf2
	slli	s1, a0, 16
	slli	a0, s0, 17
	srli	a0, a0, 1
                                        # kill: def $x10_w killed $x10_w killed $x10
	call	__truncsfbf2
	p.bset	a0, a0, 15, 16
	pv.extract.h	a1, s1, 1
	p.bset	a1, a1, 15, 16
                                        # kill: def $x10_w killed $x10_w killed $x10
                                        # kill: def $x11_w killed $x11_w killed $x11
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	lw	s1, 4(sp)                       # 4-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	.cfi_restore s1
	addi	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
