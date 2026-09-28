/* GCC reference test for __builtin_pulp_mulfs. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S mulfs.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_mulfs(int a0, int a1) { return __builtin_pulp_mulfs(a0, a1); }
