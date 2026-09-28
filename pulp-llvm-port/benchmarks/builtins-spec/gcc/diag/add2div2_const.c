/* GCC diagnostic probe: add2div2_const */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
v2s f(void){return __builtin_pulp_add2div2((v2s){0x7fff,-4},(v2s){1,-4});}
