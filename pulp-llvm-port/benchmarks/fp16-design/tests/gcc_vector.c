/* What GAP9 GCC emits for v2h / v2ah (packed 2 x 16-bit float). */
typedef float16    v2h  __attribute__((vector_size (4)));
typedef float16alt v2ah __attribute__((vector_size (4)));
typedef short v2s __attribute__((vector_size (4)));
v2h vh_add(v2h a, v2h b) { return a + b; }
v2h vh_sub(v2h a, v2h b) { return a - b; }
v2h vh_mul(v2h a, v2h b) { return a * b; }
v2h vh_div(v2h a, v2h b) { return a / b; }
v2h vh_mac(v2h a, v2h b, v2h c) { return a * b + c; }
v2h vh_scal(v2h a, float16 s) { return a * (v2h){s, s}; }
v2h vh_scal2(v2h a, float16 s) { return a * s; }
v2ah va_add(v2ah a, v2ah b) { return a + b; }
v2ah va_mul(v2ah a, v2ah b) { return a * b; }
v2ah va_mac(v2ah a, v2ah b, v2ah c) { return a * b + c; }
v2h vh_pack(float16 x, float16 y) { return (v2h){x, y}; }
v2h vh_packf(float x, float y) { return (v2h){(float16)x, (float16)y}; }
float16 vh_ext0(v2h a) { return a[0]; }
float16 vh_ext1(v2h a) { return a[1]; }
float16 vh_hsum(v2h a) { return a[0] + a[1]; }
v2h vh_ins(v2h a, float16 x) { a[1] = x; return a; }
v2s vh_lt(v2h a, v2h b) { return a < b; }
v2h vh_neg(v2h a) { return -a; }
v2h vh_max(v2h a, v2h b) { return __builtin_pulp_f16max2(a, b); }
v2ah va_max(v2ah a, v2ah b) { return __builtin_pulp_f16altmax2(a, b); }
float16 h_max(float16 a, float16 b) { return __builtin_pulp_f16max(a, b); }
float16alt a_abs(float16alt a) { return __builtin_pulp_f16altabs(a); }
float16 h_sqrt(float16 a) { return __builtin_pulp_f16sqrt(a); }
v2s cvt_v2h_v2s(v2h a) { return (v2s)__builtin_pulp_v2hftov2hi(a); }
v2h cvt_v2s_v2h(v2s a) { return (v2h)__builtin_pulp_v2hitov2hf(a); }
v2ah cvt_v2h_v2ah(v2h a) { return (v2ah)__builtin_pulp_v2hftov2ohf(a); }
v2h shuf(v2h a, v2h b) { return __builtin_shuffle(a, b, (v2s){1, 2}); }
v2h shuf1(v2h a) { return __builtin_shuffle(a, (v2s){1, 0}); }
void vdot(v2h *y, const v2h *x, const v2h *w, int n) { v2h acc = {0,0}; for (int i=0;i<n;i++) acc += x[i]*w[i]; *y = acc; }
void vcopy(v2h *d, const v2h *s) { d[0] = s[0]; d[1] = s[1]; }
extern v2h ext_v(v2h, v2ah, int);
v2h call_v(v2h a, v2ah b) { return ext_v(a, b, 2); }
