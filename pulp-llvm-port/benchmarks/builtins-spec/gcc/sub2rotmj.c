/* GCC reference test for __builtin_pulp_sub2rotmj. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S sub2rotmj.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

v2s t_sub2rotmj(v2s a0, v2s a1) { return __builtin_pulp_sub2rotmj(a0, a1); }
