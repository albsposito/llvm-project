/* GCC reference test for __builtin_pulp_mul64hs. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S mul64hs.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_mul64hs(int a0, int a1) { return __builtin_pulp_mul64hs(a0, a1); }
int t_mul64hs_const(void) { return __builtin_pulp_mul64hs(0x12345678, -7); }
