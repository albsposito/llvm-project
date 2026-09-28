/* GCC reference test for __builtin_pulp_rintsf2. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S rintsf2.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_rintsf2(float a0) { return __builtin_pulp_rintsf2(a0); }
int t_rintsf2_const(void) { return __builtin_pulp_rintsf2(2.5f); }
int t_rintsf2_scale(float x, float s) { return (int) __builtin_pulp_rintsf2(x*s); }
