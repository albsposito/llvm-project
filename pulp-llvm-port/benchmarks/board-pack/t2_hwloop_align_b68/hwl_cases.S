/* Test 2 (backlog B68): hardware loops whose lp.setup (and so the loop body) is, or is not,
 * 4-byte aligned. Assembled by GAP9 GCC (binutils), so the placement is exact.
 *
 * Every case is emitted twice by the CASE_* macros:
 *   <name>_A : lp.setup at an address = 0 mod 4 (what the fork's LLVM enforces with a c.nop)
 *   <name>_M : lp.setup at an address = 2 mod 4 (what GAP9 GCC emits freely; no padding)
 * <name>_lp is a global label on the (first) setup instruction and <name>_body on the first
 * instruction of the (inner) loop body, so main.c can print their alignment.
 *
 * C prototype of every case: void f(uint32_t n, uint32_t out[3], const uint32_t *arr);
 * a0 = trip count, a1 = out, a2 = array (only "ld"). out[] = a3, a4, a5 after the loop.
 * Loop-end labels point at the LAST instruction of the body (GNU as convention for PULP). */

	.text
	.option norvc          /* everything is 32-bit unless written as c.xxx under .option rvc */

.macro PROLOGUE name, pad
	.balign 4
	.globl \name
	.type \name, @function
\name:
	addi a3, x0, 0
	addi a4, x0, 0
	addi a5, x0, 0
	.if \pad
	.option rvc
	c.nop                  /* shifts everything below by 2 bytes */
	.option norvc
	.endif
.endm

.macro EPILOGUE name
	sw a3, 0(a1)
	sw a4, 4(a1)
	sw a5, 8(a1)
	jalr x0, 0(ra)
	.size \name, .-\name
.endm

/* c2: minimum body, 2 compressed instructions (body = 4 bytes) */
.macro CASE_c2 name, pad
	PROLOGUE \name, \pad
	.globl \name\()_lp
\name\()_lp:
	lp.setup x1, a0, 1f
	.globl \name\()_body
\name\()_body:
	.option rvc
	c.addi a3, 1
1:	c.addi a4, 3
	.option norvc
	EPILOGUE \name
.endm

/* w2: minimum body, 2 x 32-bit instructions */
.macro CASE_w2 name, pad
	PROLOGUE \name, \pad
	.globl \name\()_lp
\name\()_lp:
	lp.setup x1, a0, 1f
	.globl \name\()_body
\name\()_body:
	addi a3, a3, 1
1:	addi a4, a4, 3
	EPILOGUE \name
.endm

/* cw: compressed then 32-bit; the last instruction straddles a word boundary in _A */
.macro CASE_cw name, pad
	PROLOGUE \name, \pad
	.globl \name\()_lp
\name\()_lp:
	lp.setup x1, a0, 1f
	.globl \name\()_body
\name\()_body:
	.option rvc
	c.addi a3, 1
	.option norvc
1:	addi a4, a4, 3
	EPILOGUE \name
.endm

/* wc: 32-bit then compressed */
.macro CASE_wc name, pad
	PROLOGUE \name, \pad
	.globl \name\()_lp
\name\()_lp:
	lp.setup x1, a0, 1f
	.globl \name\()_body
\name\()_body:
	addi a3, a3, 1
	.option rvc
1:	c.addi a4, 3
	.option norvc
	EPILOGUE \name
.endm

/* mix3: 3 instructions c / w / c; a5 accumulates the running count: n(n+1)/2 */
.macro CASE_mix3 name, pad
	PROLOGUE \name, \pad
	.globl \name\()_lp
\name\()_lp:
	lp.setup x1, a0, 1f
	.globl \name\()_body
\name\()_body:
	.option rvc
	c.addi a3, 1
	.option norvc
	addi a4, a4, 3
	.option rvc
1:	c.add a5, a3
	.option norvc
	EPILOGUE \name
.endm

/* ld: post-increment load + compressed add (a typical DSP inner loop): a5 = sum(arr[0..n-1]) */
.macro CASE_ld name, pad
	PROLOGUE \name, \pad
	.globl \name\()_lp
\name\()_lp:
	lp.setup x1, a0, 1f
	.globl \name\()_body
\name\()_body:
	p.lw t0, 4(a2!)
	.option rvc
1:	c.add a5, t0
	.option norvc
	EPILOGUE \name
.endm

/* seti: lp.setupi with an immediate trip count of 7 (a0 ignored) */
.macro CASE_seti name, pad
	PROLOGUE \name, \pad
	.globl \name\()_lp
\name\()_lp:
	lp.setupi x1, 7, 1f
	.globl \name\()_body
\name\()_body:
	.option rvc
	c.addi a3, 1
1:	c.addi a4, 3
	.option norvc
	EPILOGUE \name
.endm

/* long: lp.starti / lp.endi / lp.count; in _M a c.nop between lp.count and the body makes
 * the body start at 2 mod 4 (the c.nop itself runs once, outside the loop) */
.macro CASE_long name, pad
	.balign 4
	.globl \name
	.type \name, @function
\name:
	addi a3, x0, 0
	addi a4, x0, 0
	addi a5, x0, 0
	.globl \name\()_lp
\name\()_lp:
	lp.starti x1, 2f
	lp.endi x1, 1f
	lp.count x1, a0
	.if \pad
	.option rvc
	c.nop
	.option norvc
	.endif
2:
	.globl \name\()_body
\name\()_body:
	.option rvc
	c.addi a3, 1
1:	c.addi a4, 3
	.option norvc
	EPILOGUE \name
.endm

/* nest: outer loop x1 (n iterations), inner loop x0 (3 iterations).
 * padO shifts the outer lp.setup, padI shifts the inner lp.setup (inside the outer body).
 * out = { 3n, 6n, n } */
.macro CASE_nest name, padO, padI
	PROLOGUE \name, \padO
	.globl \name\()_lp
\name\()_lp:
	lp.setup x1, a0, 2f
	addi t1, x0, 3
	.if \padI
	.option rvc
	c.nop
	.option norvc
	.endif
	.globl \name\()_lpi
\name\()_lpi:
	lp.setup x0, t1, 1f
	.globl \name\()_body
\name\()_body:
	.option rvc
	c.addi a3, 1
1:	c.addi a4, 2
2:	c.addi a5, 1
	.option norvc
	EPILOGUE \name
.endm

	CASE_c2   c2_A, 0
	CASE_c2   c2_M, 1
	CASE_w2   w2_A, 0
	CASE_w2   w2_M, 1
	CASE_cw   cw_A, 0
	CASE_cw   cw_M, 1
	CASE_wc   wc_A, 0
	CASE_wc   wc_M, 1
	CASE_mix3 mix3_A, 0
	CASE_mix3 mix3_M, 1
	CASE_ld   ld_A, 0
	CASE_ld   ld_M, 1
	CASE_seti seti_A, 0
	CASE_seti seti_M, 1
	CASE_long long_A, 0
	CASE_long long_M, 1
	CASE_nest nest_AA, 0, 0
	CASE_nest nest_AM, 0, 1
	CASE_nest nest_MA, 1, 0
	CASE_nest nest_MM, 1, 1
