/* GCC reference test for __builtin_pulp_CoreCount_m1. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S CoreCount_m1.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_CoreCount_m1(void) { return __builtin_pulp_CoreCount_m1(); }
