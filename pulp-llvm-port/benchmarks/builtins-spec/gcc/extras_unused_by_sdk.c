/* GAP9 GCC builtins in the same families that the SDK does not use (optional extras).
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S extras_unused_by_sdk.c */
typedef short v2s __attribute__((vector_size(4)));
v2s t_add2div8(v2s a, v2s b) { return __builtin_pulp_add2div8(a, b); }
v2s t_sub2div8(v2s a, v2s b) { return __builtin_pulp_sub2div8(a, b); }
int t_mulfuRN(int a, int b) { return __builtin_pulp_mulfuRN(a, b, 5, 16); }
