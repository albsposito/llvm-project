/* GCC reference test for __builtin_pulp_cplxmuls2div8. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S cplxmuls2div8.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

v2s t_cplxmuls2div8(v2s a0, v2s a1) { return __builtin_pulp_cplxmuls2div8(a0, a1); }
