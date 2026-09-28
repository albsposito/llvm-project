/* GCC diagnostic probe: cplxmuls2_const */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
v2s f(void){return __builtin_pulp_cplxmuls2((v2s){16384,0},(v2s){16384,16384});}
