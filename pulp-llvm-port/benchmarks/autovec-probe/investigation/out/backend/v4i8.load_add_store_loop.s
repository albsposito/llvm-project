	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"v4i8.load_add_store_loop.ll"
	.text
	.globl	f                               # -- Begin function f
	.p2align	1
	.type	f,@function
f:                                      # @f
	.cfi_startproc
# %bb.0:                                # %entry
	addi	a3, a3, -4
	andi	a3, a3, -4
	add	a3, a3, a0
	addi	a3, a3, 4
.LBB0_1:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	a4, 4(a1!)
	p.lw	a5, 4(a2!)
	pv.add.b	a4, a4, a5
	p.sw	a4, 4(a0!)
	bne	a0, a3, .LBB0_1
# %bb.2:                                # %exit
	ret
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
