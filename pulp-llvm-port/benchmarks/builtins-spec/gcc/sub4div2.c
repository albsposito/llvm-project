/* GCC reference test for __builtin_pulp_sub4div2. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap8 -O2 -S sub4div2.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

v4s t_sub4div2(v4s a0, v4s a1) { return __builtin_pulp_sub4div2(a0, a1); }
