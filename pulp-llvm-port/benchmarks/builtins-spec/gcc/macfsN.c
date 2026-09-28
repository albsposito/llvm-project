/* GCC reference test for __builtin_pulp_macfsN. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S macfsN.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_macfsN_n1(int a0, int a1, int a2) { return __builtin_pulp_macfsN(a0, a1, a2, 1); }
int t_macfsN_n5(int a0, int a1, int a2) { return __builtin_pulp_macfsN(a0, a1, a2, 5); }
int t_macfsN_n11(int a0, int a1, int a2) { return __builtin_pulp_macfsN(a0, a1, a2, 11); }
int t_macfsN_n15(int a0, int a1, int a2) { return __builtin_pulp_macfsN(a0, a1, a2, 15); }
int t_macfsN_n16(int a0, int a1, int a2) { return __builtin_pulp_macfsN(a0, a1, a2, 16); }
int t_macfsN_n31(int a0, int a1, int a2) { return __builtin_pulp_macfsN(a0, a1, a2, 31); }
/* non-constant N (see macfsN_bad.c for diagnostics) */
