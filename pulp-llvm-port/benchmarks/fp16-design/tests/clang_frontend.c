/* Front-end probe: GCC-style float16/float16alt code accepted by clang when mapped to _Float16/__bf16.
 * Emit IR (clang_frontend.ll) to see the mixed-type rule (f2) and variadic passing (f9).
 * Adding  v2ah f6(v2h a) { return __builtin_convertvector(a, v2ah); }  crashes clang 20 (Invalid cast! in VisitConvertVectorExpr). */
typedef _Float16 float16; typedef __bf16 float16alt;
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
v2h f1(float16 b) { v2h z = (v2h)0; v2h s = (v2h){b, 0.0}; return z + s * b; }
float16 f2(float16 a, float16alt b) { return a + b; }
v2ah f3(v2ah a, float16alt s) { return a * s; }
v2s f4(v2h a, v2h b) { return a < b; }
v2ah f5(v2h a) { return (v2ah)a; }
float16alt f7(float16alt a) { return a > 0 ? a : -a; }
double f8(float16alt a) { return a; }
void vf(int, ...); void f9(float16 a, float16alt b) { vf(1, a, b); }
