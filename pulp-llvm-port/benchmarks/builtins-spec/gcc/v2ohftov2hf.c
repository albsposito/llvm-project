/* GCC reference test for __builtin_pulp_v2ohftov2hf. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S v2ohftov2hf.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));

v2h t_v2ohftov2hf(v2ah a0) { return __builtin_pulp_v2ohftov2hf(a0); }
