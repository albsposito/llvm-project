/* GCC diagnostic probe: f16altmax_f16 */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
float16alt f(float16 a,float16 b){return __builtin_pulp_f16altmax(a,b);}
