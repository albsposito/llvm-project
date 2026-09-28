/* GCC reference test for __builtin_pulp_cplxmulsdiv2. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap8 -O2 -S cplxmulsdiv2.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

v2s t_cplxmulsdiv2(v2s a0, v2s a1) { return __builtin_pulp_cplxmulsdiv2(a0, a1); }
