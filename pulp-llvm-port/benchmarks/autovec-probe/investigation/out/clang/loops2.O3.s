	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.text
	.globl	add16                           # -- Begin function add16
	.p2align	1
	.type	add16,@function
add16:                                  # @add16
# %bb.0:                                # %entry
	blez	a3, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	add	a4, a4, a5
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB0_2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	add16, .Lfunc_end0-add16
                                        # -- End function
	.globl	add8                            # -- Begin function add8
	.p2align	1
	.type	add8,@function
add8:                                   # @add8
# %bb.0:                                # %entry
	blez	a3, .LBB1_3
# %bb.1:                                # %for.body.preheader
	add	a3, a3, a0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a4, 1(a1!)
	p.lbu	a5, 1(a2!)
	add	a4, a4, a5
	p.sb	a4, 1(a0!)
	bne	a0, a3, .LBB1_2
.LBB1_3:                                # %for.cond.cleanup
	ret
.Lfunc_end1:
	.size	add8, .Lfunc_end1-add8
                                        # -- End function
	.globl	sub16                           # -- Begin function sub16
	.p2align	1
	.type	sub16,@function
sub16:                                  # @sub16
# %bb.0:                                # %entry
	blez	a3, .LBB2_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB2_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	sub	a4, a4, a5
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB2_2
.LBB2_3:                                # %for.cond.cleanup
	ret
.Lfunc_end2:
	.size	sub16, .Lfunc_end2-sub16
                                        # -- End function
	.globl	and16                           # -- Begin function and16
	.p2align	1
	.type	and16,@function
and16:                                  # @and16
# %bb.0:                                # %entry
	blez	a3, .LBB3_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB3_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	and	a4, a4, a5
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB3_2
.LBB3_3:                                # %for.cond.cleanup
	ret
.Lfunc_end3:
	.size	and16, .Lfunc_end3-and16
                                        # -- End function
	.globl	min16                           # -- Begin function min16
	.p2align	1
	.type	min16,@function
min16:                                  # @min16
# %bb.0:                                # %entry
	blez	a3, .LBB4_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB4_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a4, 2(a1!)
	p.lh	a5, 2(a2!)
	p.min	a4, a4, a5
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB4_2
.LBB4_3:                                # %for.cond.cleanup
	ret
.Lfunc_end4:
	.size	min16, .Lfunc_end4-min16
                                        # -- End function
	.globl	max8                            # -- Begin function max8
	.p2align	1
	.type	max8,@function
max8:                                   # @max8
# %bb.0:                                # %entry
	blez	a3, .LBB5_3
# %bb.1:                                # %for.body.preheader
	add	a3, a3, a0
.LBB5_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lb	a4, 1(a1!)
	p.lb	a5, 1(a2!)
	p.max	a4, a4, a5
	p.sb	a4, 1(a0!)
	bne	a0, a3, .LBB5_2
.LBB5_3:                                # %for.cond.cleanup
	ret
.Lfunc_end5:
	.size	max8, .Lfunc_end5-max8
                                        # -- End function
	.globl	maxu8                           # -- Begin function maxu8
	.p2align	1
	.type	maxu8,@function
maxu8:                                  # @maxu8
# %bb.0:                                # %entry
	blez	a3, .LBB6_3
# %bb.1:                                # %for.body.preheader
	add	a3, a3, a0
.LBB6_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a4, 1(a1!)
	p.lbu	a5, 1(a2!)
	p.maxu	a4, a4, a5
	p.sb	a4, 1(a0!)
	bne	a0, a3, .LBB6_2
.LBB6_3:                                # %for.cond.cleanup
	ret
.Lfunc_end6:
	.size	maxu8, .Lfunc_end6-maxu8
                                        # -- End function
	.globl	abs16                           # -- Begin function abs16
	.p2align	1
	.type	abs16,@function
abs16:                                  # @abs16
# %bb.0:                                # %entry
	blez	a2, .LBB7_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a0
.LBB7_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a3, 2(a1!)
	p.abs	a3, a3
	p.sh	a3, 2(a0!)
	bne	a0, a2, .LBB7_2
.LBB7_3:                                # %for.cond.cleanup
	ret
.Lfunc_end7:
	.size	abs16, .Lfunc_end7-abs16
                                        # -- End function
	.globl	shr16                           # -- Begin function shr16
	.p2align	1
	.type	shr16,@function
shr16:                                  # @shr16
# %bb.0:                                # %entry
	blez	a2, .LBB8_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a0
.LBB8_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a3, 2(a1!)
	srli	a3, a3, 3
	p.sh	a3, 2(a0!)
	bne	a0, a2, .LBB8_2
.LBB8_3:                                # %for.cond.cleanup
	ret
.Lfunc_end8:
	.size	shr16, .Lfunc_end8-shr16
                                        # -- End function
	.globl	shl8                            # -- Begin function shl8
	.p2align	1
	.type	shl8,@function
shl8:                                   # @shl8
# %bb.0:                                # %entry
	blez	a2, .LBB9_3
# %bb.1:                                # %for.body.preheader
	add	a2, a2, a0
.LBB9_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a3, 1(a1!)
	slli	a3, a3, 2
	p.sb	a3, 1(a0!)
	bne	a0, a2, .LBB9_2
.LBB9_3:                                # %for.cond.cleanup
	ret
.Lfunc_end9:
	.size	shl8, .Lfunc_end9-shl8
                                        # -- End function
	.globl	shrv16                          # -- Begin function shrv16
	.p2align	1
	.type	shrv16,@function
shrv16:                                 # @shrv16
# %bb.0:                                # %entry
	blez	a3, .LBB10_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB10_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a4, 2(a1!)
	sra	a4, a4, a2
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB10_2
.LBB10_3:                               # %for.cond.cleanup
	ret
.Lfunc_end10:
	.size	shrv16, .Lfunc_end10-shrv16
                                        # -- End function
	.globl	addc16                          # -- Begin function addc16
	.p2align	1
	.type	addc16,@function
addc16:                                 # @addc16
# %bb.0:                                # %entry
	blez	a2, .LBB11_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a0
.LBB11_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a3, 2(a1!)
	addi	a3, a3, 5
	p.sh	a3, 2(a0!)
	bne	a0, a2, .LBB11_2
.LBB11_3:                               # %for.cond.cleanup
	ret
.Lfunc_end11:
	.size	addc16, .Lfunc_end11-addc16
                                        # -- End function
	.globl	adds16                          # -- Begin function adds16
	.p2align	1
	.type	adds16,@function
adds16:                                 # @adds16
# %bb.0:                                # %entry
	blez	a3, .LBB12_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB12_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	add	a4, a4, a2
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB12_2
.LBB12_3:                               # %for.cond.cleanup
	ret
.Lfunc_end12:
	.size	adds16, .Lfunc_end12-adds16
                                        # -- End function
	.globl	scale16                         # -- Begin function scale16
	.p2align	1
	.type	scale16,@function
scale16:                                # @scale16
# %bb.0:                                # %entry
	blez	a2, .LBB13_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a0
.LBB13_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a3, 2(a1!)
	slli	a4, a3, 1
	add	a3, a3, a4
	p.sh	a3, 2(a0!)
	bne	a0, a2, .LBB13_2
.LBB13_3:                               # %for.cond.cleanup
	ret
.Lfunc_end13:
	.size	scale16, .Lfunc_end13-scale16
                                        # -- End function
	.globl	scaleq15                        # -- Begin function scaleq15
	.p2align	1
	.type	scaleq15,@function
scaleq15:                               # @scaleq15
# %bb.0:                                # %entry
	blez	a3, .LBB14_3
# %bb.1:                                # %for.body.lr.ph
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB14_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a4, 2(a1!)
	mul	a4, a4, a2
	srli	a4, a4, 15
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB14_2
.LBB14_3:                               # %for.cond.cleanup
	ret
.Lfunc_end14:
	.size	scaleq15, .Lfunc_end14-scaleq15
                                        # -- End function
	.globl	mul16                           # -- Begin function mul16
	.p2align	1
	.type	mul16,@function
mul16:                                  # @mul16
# %bb.0:                                # %entry
	blez	a3, .LBB15_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB15_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	mul	a4, a5, a4
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB15_2
.LBB15_3:                               # %for.cond.cleanup
	ret
.Lfunc_end15:
	.size	mul16, .Lfunc_end15-mul16
                                        # -- End function
	.globl	copy16                          # -- Begin function copy16
	.p2align	1
	.type	copy16,@function
copy16:                                 # @copy16
# %bb.0:                                # %entry
	blez	a2, .LBB16_2
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	tail	memcpy
.LBB16_2:                               # %for.cond.cleanup
	ret
.Lfunc_end16:
	.size	copy16, .Lfunc_end16-copy16
                                        # -- End function
	.globl	set16                           # -- Begin function set16
	.p2align	1
	.type	set16,@function
set16:                                  # @set16
# %bb.0:                                # %entry
	blez	a2, .LBB17_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a0
.LBB17_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.sh	a1, 2(a0!)
	bne	a0, a2, .LBB17_2
.LBB17_3:                               # %for.cond.cleanup
	ret
.Lfunc_end17:
	.size	set16, .Lfunc_end17-set16
                                        # -- End function
	.globl	avg8                            # -- Begin function avg8
	.p2align	1
	.type	avg8,@function
avg8:                                   # @avg8
# %bb.0:                                # %entry
	blez	a3, .LBB18_3
# %bb.1:                                # %for.body.preheader
	add	a3, a3, a0
	li	a6, 1
.LBB18_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a5, 1(a1!)
	p.lbu	a4, 1(a2!)
	add	a4, a4, a5
	p.addun	a4, a4, a6, 1
	p.sb	a4, 1(a0!)
	bne	a0, a3, .LBB18_2
.LBB18_3:                               # %for.cond.cleanup
	ret
.Lfunc_end18:
	.size	avg8, .Lfunc_end18-avg8
                                        # -- End function
	.globl	sat16                           # -- Begin function sat16
	.p2align	1
	.type	sat16,@function
sat16:                                  # @sat16
# %bb.0:                                # %entry
	blez	a3, .LBB19_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB19_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a4, 2(a1!)
	p.lh	a5, 2(a2!)
	add	a4, a4, a5
	p.clip	a4, a4, 16
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB19_2
.LBB19_3:                               # %for.cond.cleanup
	ret
.Lfunc_end19:
	.size	sat16, .Lfunc_end19-sat16
                                        # -- End function
	.globl	clip16                          # -- Begin function clip16
	.p2align	1
	.type	clip16,@function
clip16:                                 # @clip16
# %bb.0:                                # %entry
	blez	a2, .LBB20_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a0
.LBB20_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a3, 2(a1!)
	p.clip	a3, a3, 9
	p.sh	a3, 2(a0!)
	bne	a0, a2, .LBB20_2
.LBB20_3:                               # %for.cond.cleanup
	ret
.Lfunc_end20:
	.size	clip16, .Lfunc_end20-clip16
                                        # -- End function
	.globl	relu8                           # -- Begin function relu8
	.p2align	1
	.type	relu8,@function
relu8:                                  # @relu8
# %bb.0:                                # %entry
	blez	a2, .LBB21_3
# %bb.1:                                # %for.body.preheader
	add	a2, a2, a0
.LBB21_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lb	a3, 1(a1!)
	p.max	a3, a3, zero
	p.sb	a3, 1(a0!)
	bne	a0, a2, .LBB21_2
.LBB21_3:                               # %for.cond.cleanup
	ret
.Lfunc_end21:
	.size	relu8, .Lfunc_end21-relu8
                                        # -- End function
	.globl	sel16                           # -- Begin function sel16
	.p2align	1
	.type	sel16,@function
sel16:                                  # @sel16
# %bb.0:                                # %entry
	blez	a3, .LBB22_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a6, a0, a3
.LBB22_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a4, 2(a1!)
	p.lh	a5, 2(a2!)
	slt	a3, a5, a4
	sub	a4, a4, a5
	neg	a3, a3
	and	a3, a3, a4
	p.sh	a3, 2(a0!)
	bne	a0, a6, .LBB22_2
.LBB22_3:                               # %for.cond.cleanup
	ret
.Lfunc_end22:
	.size	sel16, .Lfunc_end22-sel16
                                        # -- End function
	.globl	dot16                           # -- Begin function dot16
	.p2align	1
	.type	dot16,@function
dot16:                                  # @dot16
# %bb.0:                                # %entry
	blez	a2, .LBB23_4
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a3, a1, a2
	sub	a2, a3, a1
	srli	a4, a2, 1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB23_5
.LBB23_2:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a4, 2(a0!)
	p.lh	a5, 2(a1!)
.LBB23_5:                               #   in Loop: Header=BB23_2 Depth=1
                                        # Label of block must be emitted
	p.mac	a2, a5, a4
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.LBB23_4:
	li	a0, 0
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end23:
	.size	dot16, .Lfunc_end23-dot16
                                        # -- End function
	.globl	dot8                            # -- Begin function dot8
	.p2align	1
	.type	dot8,@function
dot8:                                   # @dot8
# %bb.0:                                # %entry
	blez	a2, .LBB24_4
# %bb.1:                                # %for.body.preheader
	add	a3, a1, a2
	sub	a4, a3, a1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB24_5
.LBB24_2:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lb	a4, 1(a0!)
	p.lb	a5, 1(a1!)
.LBB24_5:                               #   in Loop: Header=BB24_2 Depth=1
                                        # Label of block must be emitted
	p.mac	a2, a5, a4
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.LBB24_4:
	li	a0, 0
	ret
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Lfunc_end24:
	.size	dot8, .Lfunc_end24-dot8
                                        # -- End function
	.globl	dotu8                           # -- Begin function dotu8
	.p2align	1
	.type	dotu8,@function
dotu8:                                  # @dotu8
# %bb.0:                                # %entry
	blez	a2, .LBB25_4
# %bb.1:                                # %for.body.preheader
	add	a3, a1, a2
	sub	a4, a3, a1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB25_5
.LBB25_2:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lbu	a4, 1(a0!)
	p.lbu	a5, 1(a1!)
.LBB25_5:                               #   in Loop: Header=BB25_2 Depth=1
                                        # Label of block must be emitted
	p.mac	a2, a5, a4
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.LBB25_4:
	li	a0, 0
	ret
.Ltmp2:                                 # Address of block that was removed by CodeGen
.Lfunc_end25:
	.size	dotu8, .Lfunc_end25-dotu8
                                        # -- End function
	.globl	sum16                           # -- Begin function sum16
	.p2align	1
	.type	sum16,@function
sum16:                                  # @sum16
# %bb.0:                                # %entry
	blez	a1, .LBB26_4
# %bb.1:                                # %for.body.preheader
	slli	a1, a1, 1
	add	a2, a0, a1
	sub	a1, a2, a0
	srli	a3, a1, 1
	li	a1, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB26_5
.LBB26_2:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a3, 2(a0!)
.LBB26_5:                               #   in Loop: Header=BB26_2 Depth=1
                                        # Label of block must be emitted
	add	a1, a1, a3
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a1
	ret
.LBB26_4:
	li	a0, 0
	ret
.Ltmp3:                                 # Address of block that was removed by CodeGen
.Lfunc_end26:
	.size	sum16, .Lfunc_end26-sum16
                                        # -- End function
	.globl	sum8                            # -- Begin function sum8
	.p2align	1
	.type	sum8,@function
sum8:                                   # @sum8
# %bb.0:                                # %entry
	blez	a1, .LBB27_4
# %bb.1:                                # %for.body.preheader
	add	a2, a0, a1
	sub	a3, a2, a0
	li	a1, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB27_5
.LBB27_2:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lb	a3, 1(a0!)
.LBB27_5:                               #   in Loop: Header=BB27_2 Depth=1
                                        # Label of block must be emitted
	add	a1, a1, a3
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a1
	ret
.LBB27_4:
	li	a0, 0
	ret
.Ltmp4:                                 # Address of block that was removed by CodeGen
.Lfunc_end27:
	.size	sum8, .Lfunc_end27-sum8
                                        # -- End function
	.globl	sum16n                          # -- Begin function sum16n
	.p2align	1
	.type	sum16n,@function
sum16n:                                 # @sum16n
# %bb.0:                                # %entry
	blez	a1, .LBB28_4
# %bb.1:                                # %for.body.preheader
	slli	a1, a1, 1
	add	a1, a1, a0
	sub	a2, a1, a0
	srli	a3, a2, 1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB28_5
.LBB28_2:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lhu	a3, 2(a0!)
.LBB28_5:                               #   in Loop: Header=BB28_2 Depth=1
                                        # Label of block must be emitted
	add	a2, a2, a3
# %bb.3:                                # %for.cond.cleanup
	p.exths	a0, a2
	ret
.LBB28_4:
	p.exths	a0, zero
	ret
.Ltmp5:                                 # Address of block that was removed by CodeGen
.Lfunc_end28:
	.size	sum16n, .Lfunc_end28-sum16n
                                        # -- End function
	.globl	max16r                          # -- Begin function max16r
	.p2align	1
	.type	max16r,@function
max16r:                                 # @max16r
# %bb.0:                                # %entry
	blez	a1, .LBB29_4
# %bb.1:                                # %for.body.preheader
	slli	a1, a1, 1
	add	a2, a0, a1
	sub	a1, a2, a0
	srli	a3, a1, 1
	lui	a1, 1048568
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB29_5
.LBB29_2:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a3, 2(a0!)
.LBB29_5:                               #   in Loop: Header=BB29_2 Depth=1
                                        # Label of block must be emitted
	p.max	a1, a1, a3
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a1
	ret
.LBB29_4:
	lui	a0, 1048568
	ret
.Ltmp6:                                 # Address of block that was removed by CodeGen
.Lfunc_end29:
	.size	max16r, .Lfunc_end29-max16r
                                        # -- End function
	.globl	max16rn                         # -- Begin function max16rn
	.p2align	1
	.type	max16rn,@function
max16rn:                                # @max16rn
# %bb.0:                                # %entry
	blez	a1, .LBB30_4
# %bb.1:                                # %for.body.preheader
	slli	a1, a1, 1
	add	a1, a1, a0
	sub	a2, a1, a0
	srli	a3, a2, 1
	lui	a2, 8
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB30_5
.LBB30_2:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a3, 2(a0!)
	p.exths	a2, a2
.LBB30_5:                               #   in Loop: Header=BB30_2 Depth=1
                                        # Label of block must be emitted
	p.max	a2, a3, a2
# %bb.3:                                # %for.cond.cleanup
	p.exths	a0, a2
	ret
.LBB30_4:
	lui	a2, 8
	p.exths	a0, a2
	ret
.Ltmp7:                                 # Address of block that was removed by CodeGen
.Lfunc_end30:
	.size	max16rn, .Lfunc_end30-max16rn
                                        # -- End function
	.globl	sad8                            # -- Begin function sad8
	.p2align	1
	.type	sad8,@function
sad8:                                   # @sad8
# %bb.0:                                # %entry
	blez	a2, .LBB31_4
# %bb.1:                                # %for.body.preheader
	add	a6, a1, a2
	sub	a4, a6, a1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB31_5
.LBB31_2:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lbu	a4, 1(a0!)
	p.lbu	a5, 1(a1!)
	p.minu	a3, a4, a5
	p.maxu	a4, a4, a5
	sub	a4, a4, a3
.LBB31_5:                               #   in Loop: Header=BB31_2 Depth=1
                                        # Label of block must be emitted
	add	a2, a2, a4
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.LBB31_4:
	li	a0, 0
	ret
.Ltmp8:                                 # Address of block that was removed by CodeGen
.Lfunc_end31:
	.size	sad8, .Lfunc_end31-sad8
                                        # -- End function
	.globl	add16_k64                       # -- Begin function add16_k64
	.p2align	1
	.type	add16_k64,@function
add16_k64:                              # @add16_k64
# %bb.0:                                # %entry
	addi	a3, a0, 128
.LBB32_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	add	a4, a4, a5
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB32_1
# %bb.2:                                # %for.cond.cleanup
	ret
.Lfunc_end32:
	.size	add16_k64, .Lfunc_end32-add16_k64
                                        # -- End function
	.globl	add16_k63                       # -- Begin function add16_k63
	.p2align	1
	.type	add16_k63,@function
add16_k63:                              # @add16_k63
# %bb.0:                                # %entry
	addi	a3, a0, 126
.LBB33_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	add	a4, a4, a5
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB33_1
# %bb.2:                                # %for.cond.cleanup
	ret
.Lfunc_end33:
	.size	add16_k63, .Lfunc_end33-add16_k63
                                        # -- End function
	.globl	add8_k4                         # -- Begin function add8_k4
	.p2align	1
	.type	add8_k4,@function
add8_k4:                                # @add8_k4
# %bb.0:                                # %entry
	lbu	a6, 0(a1)
	lbu	a7, 1(a1)
	lbu	t0, 2(a1)
	lbu	a1, 3(a1)
	lbu	a3, 0(a2)
	lbu	a4, 1(a2)
	lbu	a5, 2(a2)
	lbu	a2, 3(a2)
	add	a3, a3, a6
	add	a4, a4, a7
	add	a5, a5, t0
	add	a1, a1, a2
	sb	a3, 0(a0)
	sb	a4, 1(a0)
	sb	a5, 2(a0)
	sb	a1, 3(a0)
	ret
.Lfunc_end34:
	.size	add8_k4, .Lfunc_end34-add8_k4
                                        # -- End function
	.globl	add16_k2                        # -- Begin function add16_k2
	.p2align	1
	.type	add16_k2,@function
add16_k2:                               # @add16_k2
# %bb.0:                                # %entry
	lh	a3, 0(a1)
	lh	a1, 2(a1)
	lh	a4, 0(a2)
	lh	a2, 2(a2)
	add	a3, a3, a4
	add	a1, a1, a2
	sh	a3, 0(a0)
	sh	a1, 2(a0)
	ret
.Lfunc_end35:
	.size	add16_k2, .Lfunc_end35-add16_k2
                                        # -- End function
	.globl	dot16_k64                       # -- Begin function dot16_k64
	.p2align	1
	.type	dot16_k64,@function
dot16_k64:                              # @dot16_k64
# %bb.0:                                # %entry
	addi	a3, a1, 128
	sub	a2, a3, a1
	srli	a4, a2, 1
	li	a2, 0
	.p2align	2
# %bb.4:                                # %entry
	lp.setup	x0, a4, .LBB36_3
.LBB36_1:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a4, 2(a0!)
	p.lh	a5, 2(a1!)
.LBB36_3:                               #   in Loop: Header=BB36_1 Depth=1
                                        # Label of block must be emitted
	p.mac	a2, a5, a4
# %bb.2:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.Ltmp9:                                 # Address of block that was removed by CodeGen
.Lfunc_end36:
	.size	dot16_k64, .Lfunc_end36-dot16_k64
                                        # -- End function
	.globl	add16_glob                      # -- Begin function add16_glob
	.p2align	1
	.type	add16_glob,@function
add16_glob:                             # @add16_glob
# %bb.0:                                # %entry
	lui	a1, %hi(.L_MergedGlobals)
	addi	a1, a1, %lo(.L_MergedGlobals)
	addi	a0, a1, 256
	addi	a1, a1, 384
	sub	a2, a1, a0
	srli	a2, a2, 1
	.p2align	2
# %bb.4:                                # %entry
	lp.setup	x0, a2, .LBB37_3
.LBB37_1:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a2, -256(a0)
	lh	a3, -128(a0)
	add	a2, a2, a3
	sh	a2, 0(a0)
.LBB37_3:                               #   in Loop: Header=BB37_1 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
# %bb.2:                                # %for.cond.cleanup
	ret
.Ltmp10:                                # Address of block that was removed by CodeGen
.Lfunc_end37:
	.size	add16_glob, .Lfunc_end37-add16_glob
                                        # -- End function
	.globl	add16_nr                        # -- Begin function add16_nr
	.p2align	1
	.type	add16_nr,@function
add16_nr:                               # @add16_nr
# %bb.0:                                # %entry
	blez	a3, .LBB38_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB38_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	add	a4, a4, a5
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB38_2
.LBB38_3:                               # %for.cond.cleanup
	ret
.Lfunc_end38:
	.size	add16_nr, .Lfunc_end38-add16_nr
                                        # -- End function
	.globl	add8_nr                         # -- Begin function add8_nr
	.p2align	1
	.type	add8_nr,@function
add8_nr:                                # @add8_nr
# %bb.0:                                # %entry
	blez	a3, .LBB39_3
# %bb.1:                                # %for.body.preheader
	add	a3, a3, a0
.LBB39_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a4, 1(a1!)
	p.lbu	a5, 1(a2!)
	add	a4, a4, a5
	p.sb	a4, 1(a0!)
	bne	a0, a3, .LBB39_2
.LBB39_3:                               # %for.cond.cleanup
	ret
.Lfunc_end39:
	.size	add8_nr, .Lfunc_end39-add8_nr
                                        # -- End function
	.globl	inplace16                       # -- Begin function inplace16
	.p2align	1
	.type	inplace16,@function
inplace16:                              # @inplace16
# %bb.0:                                # %entry
	blez	a2, .LBB40_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a0
.LBB40_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a3, 2(a1!)
	lh	a4, 0(a0)
	add	a3, a3, a4
	p.sh	a3, 2(a0!)
	bne	a0, a2, .LBB40_2
.LBB40_3:                               # %for.cond.cleanup
	ret
.Lfunc_end40:
	.size	inplace16, .Lfunc_end40-inplace16
                                        # -- End function
	.globl	slp_add16                       # -- Begin function slp_add16
	.p2align	1
	.type	slp_add16,@function
slp_add16:                              # @slp_add16
# %bb.0:                                # %entry
	lh	a3, 0(a1)
	lh	a1, 2(a1)
	lh	a4, 0(a2)
	lh	a2, 2(a2)
	add	a3, a3, a4
	add	a1, a1, a2
	sh	a3, 0(a0)
	sh	a1, 2(a0)
	ret
.Lfunc_end41:
	.size	slp_add16, .Lfunc_end41-slp_add16
                                        # -- End function
	.globl	slp_add8                        # -- Begin function slp_add8
	.p2align	1
	.type	slp_add8,@function
slp_add8:                               # @slp_add8
# %bb.0:                                # %entry
	lbu	a6, 0(a1)
	lbu	a7, 1(a1)
	lbu	t0, 2(a1)
	lbu	a1, 3(a1)
	lbu	a3, 0(a2)
	lbu	a4, 1(a2)
	lbu	a5, 2(a2)
	lbu	a2, 3(a2)
	add	a3, a3, a6
	add	a4, a4, a7
	add	a5, a5, t0
	add	a1, a1, a2
	sb	a3, 0(a0)
	sb	a4, 1(a0)
	sb	a5, 2(a0)
	sb	a1, 3(a0)
	ret
.Lfunc_end42:
	.size	slp_add8, .Lfunc_end42-slp_add8
                                        # -- End function
	.globl	slp_px                          # -- Begin function slp_px
	.p2align	1
	.type	slp_px,@function
slp_px:                                 # @slp_px
# %bb.0:                                # %entry
	lbu	a6, 0(a1)
	lbu	a7, 1(a1)
	lbu	t0, 2(a1)
	lbu	a1, 3(a1)
	lbu	a3, 0(a2)
	lbu	a4, 1(a2)
	lbu	a5, 2(a2)
	lbu	a2, 3(a2)
	add	a3, a3, a6
	add	a4, a4, a7
	add	a5, a5, t0
	add	a1, a1, a2
	sb	a3, 0(a0)
	sb	a4, 1(a0)
	sb	a5, 2(a0)
	sb	a1, 3(a0)
	ret
.Lfunc_end43:
	.size	slp_px, .Lfunc_end43-slp_px
                                        # -- End function
	.globl	add32                           # -- Begin function add32
	.p2align	1
	.type	add32,@function
add32:                                  # @add32
# %bb.0:                                # %entry
	blez	a3, .LBB44_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 2
	add	a3, a3, a0
.LBB44_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	a4, 4(a1!)
	p.lw	a5, 4(a2!)
	add	a4, a4, a5
	p.sw	a4, 4(a0!)
	bne	a0, a3, .LBB44_2
.LBB44_3:                               # %for.cond.cleanup
	ret
.Lfunc_end44:
	.size	add32, .Lfunc_end44-add32
                                        # -- End function
	.type	.L_MergedGlobals,@object        # @_MergedGlobals
	.local	.L_MergedGlobals
	.comm	.L_MergedGlobals,384,2
	.globl	GB
.set GB, .L_MergedGlobals
	.size	GB, 128
	.globl	GC
.set GC, .L_MergedGlobals+128
	.size	GC, 128
	.globl	GA
.set GA, .L_MergedGlobals+256
	.size	GA, 128
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym .L_MergedGlobals
