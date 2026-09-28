/* What GAP9 GCC emits for scalar float16 / float16alt. */
float16 h_add(float16 a, float16 b) { return a + b; }
float16 h_mul(float16 a, float16 b) { return a * b; }
float16 h_fma(float16 a, float16 b, float16 c) { return a * b + c; }
float16 h_div(float16 a, float16 b) { return a / b; }
float16 h_expr(float16 a, float16 b, float16 c) { return (a + b) * c - a; }
int h_lt(float16 a, float16 b) { return a < b; }
float16alt a_add(float16alt a, float16alt b) { return a + b; }
float16alt a_mul(float16alt a, float16alt b) { return a * b; }
float16alt a_fma(float16alt a, float16alt b, float16alt c) { return a * b + c; }
float16alt a_expr(float16alt a, float16alt b, float16alt c) { return (a + b) * c - a; }
int a_lt(float16alt a, float16alt b) { return a < b; }
/* conversions */
float h2f(float16 a) { return a; }
float16 f2h(float a) { return a; }
float a2f(float16alt a) { return a; }
float16alt f2a(float a) { return a; }
float16alt h2a(float16 a) { return a; }
float16 a2h(float16alt a) { return a; }
int h2i(float16 a) { return a; }
float16 i2h(int a) { return a; }
unsigned h2u(float16 a) { return a; }
int a2i(float16alt a) { return a; }
float16alt i2a(int a) { return a; }
double h2d(float16 a) { return a; }
float16 d2h(double a) { return a; }
/* mixed with float: promotion rules */
float mix_hf(float16 a, float b) { return a * b; }
float16 mix_ha(float16 a, float16alt b) { return a + b; }
/* loads / stores */
void h_copy(float16 *d, const float16 *s) { d[0] = s[0]; d[1] = s[1]; }
void h_axpy(float16 *y, const float16 *x, float16 a, int n) { for (int i = 0; i < n; i++) y[i] += a * x[i]; }
void a_axpy(float16alt *y, const float16alt *x, float16alt a, int n) { for (int i = 0; i < n; i++) y[i] += a * x[i]; }
float16 h_const(void) { return 1.5; }
float16alt a_const(void) { return 3.14159f; }
/* sizes */
int sz[] = { sizeof(float16), _Alignof(float16), sizeof(float16alt), _Alignof(float16alt) };
/* calls: many args to see stack passing */
extern float16 ext_h(float16, float16alt, int, float16);
float16 call_h(float16 a, float16alt b) { return ext_h(a, b, 3, a) + (float16)1; }
float16 many(float16 a0,float16 a1,float16 a2,float16 a3,float16 a4,float16 a5,float16 a6,float16 a7,float16 a8,float16 a9) { return a0+a9+a8; }
/* variadic */
extern void vf(int, ...);
void call_var(float16 a) { vf(1, a); }
/* libm-ish */
float16 h_abs(float16 a) { return a < 0 ? -a : a; }
float16 h_neg(float16 a) { return -a; }
