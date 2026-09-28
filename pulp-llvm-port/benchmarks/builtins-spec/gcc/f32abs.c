/* GCC reference test for __builtin_pulp_f32abs. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S f32abs.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

float t_f32abs(float a0) { return __builtin_pulp_f32abs(a0); }
float t_f32abs_const(void) { return __builtin_pulp_f32abs(2.5f); }
