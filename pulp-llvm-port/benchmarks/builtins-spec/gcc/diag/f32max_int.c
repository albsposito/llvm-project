/* GCC diagnostic probe: f32max_int */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
float f(int a,int b){return __builtin_pulp_f32max(a,b);}
