/* GCC reference test for __builtin_pulp_mul64hus. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S mul64hus.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_mul64hus(int a0, int a1) { return __builtin_pulp_mul64hus(a0, a1); }
int t_mul64hus_const(void) { return __builtin_pulp_mul64hus(0x12345678, -7); }
