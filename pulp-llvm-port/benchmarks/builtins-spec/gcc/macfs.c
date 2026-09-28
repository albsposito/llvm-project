/* GCC reference test for __builtin_pulp_macfs. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S macfs.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_macfs(int a0, int a1, int a2) { return __builtin_pulp_macfs(a0, a1, a2); }
