	.file	"vitsel2.c"
	.option nopic
	.text
	.align	1
	.globl	t_vitsel2
	.type	t_vitsel2, @function
t_vitsel2:
	pv.vitop.sel 	a0,a0,a1	 # Vect 2 Viterbi select
	ret
	.size	t_vitsel2, .-t_vitsel2
	.ident	"GCC: (GNU) 7.1.1 20170509"
