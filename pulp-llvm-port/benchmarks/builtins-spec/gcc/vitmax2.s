	.file	"vitmax2.c"
	.option nopic
	.text
	.align	1
	.globl	t_vitmax2
	.type	t_vitmax2, @function
t_vitmax2:
	pv.vitop.max 	a0,a0,a1	 # Vect 2 Viterbi max
	ret
	.size	t_vitmax2, .-t_vitmax2
	.ident	"GCC: (GNU) 7.1.1 20170509"
