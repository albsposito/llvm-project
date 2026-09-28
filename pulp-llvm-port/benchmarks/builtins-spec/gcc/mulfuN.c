/* GCC reference test for __builtin_pulp_mulfuN. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S mulfuN.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_mulfuN_n1(int a0, int a1) { return __builtin_pulp_mulfuN(a0, a1, 1); }
int t_mulfuN_n5(int a0, int a1) { return __builtin_pulp_mulfuN(a0, a1, 5); }
int t_mulfuN_n11(int a0, int a1) { return __builtin_pulp_mulfuN(a0, a1, 11); }
int t_mulfuN_n15(int a0, int a1) { return __builtin_pulp_mulfuN(a0, a1, 15); }
int t_mulfuN_n16(int a0, int a1) { return __builtin_pulp_mulfuN(a0, a1, 16); }
int t_mulfuN_n31(int a0, int a1) { return __builtin_pulp_mulfuN(a0, a1, 31); }
/* non-constant N (see mulfuN_bad.c for diagnostics) */
