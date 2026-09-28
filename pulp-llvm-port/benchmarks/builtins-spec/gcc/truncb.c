/* GCC reference test for __builtin_pulp_truncb. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S truncb.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

char t_truncb(int a0) { return __builtin_pulp_truncb(a0); }
char t_truncb_const(void) { return __builtin_pulp_truncb(0x12345678); }
