/* GCC reference test for __builtin_pulp_mulfu. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S mulfu.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_mulfu(int a0, int a1) { return __builtin_pulp_mulfu(a0, a1); }
