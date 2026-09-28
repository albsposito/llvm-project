/* Current port-20 clang (int-20, 7459255b6120) on _Float16/__bf16 and their 2-wide vectors.
 * Output: clang_probe.s (-march=rv32imc_zfinx_zhinx_xpulpv2 -O2). */
_Float16 h_add(_Float16 a, _Float16 b) { return a + b; }
_Float16 h_expr(_Float16 a, _Float16 b, _Float16 c) { return (a + b) * c - a; }
_Float16 h_fma(_Float16 a, _Float16 b, _Float16 c) { return a * b + c; }
__bf16 a_add(__bf16 a, __bf16 b) { return a + b; }
__bf16 a_expr(__bf16 a, __bf16 b, __bf16 c) { return (a + b) * c - a; }
int a2i(__bf16 a) { return a; }
float a2f(__bf16 a) { return a; }
__bf16 f2a(float a) { return a; }
typedef _Float16 v2h __attribute__((vector_size(4)));
typedef __bf16 v2ah __attribute__((vector_size(4)));
v2h vh_add(v2h a, v2h b) { return a + b; }
v2ah va_add(v2ah a, v2ah b) { return a + b; }
