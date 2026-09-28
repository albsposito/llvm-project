/* GCC diagnostic probe: f32sqrt_static_init */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
static float k = __builtin_pulp_f32max(1.0f, 2.0f); float f(void){return k;}
