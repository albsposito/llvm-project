/* Numeric-equivalence probe: GAP9 GCC float16/float16alt vs clang _Float16/__bf16.
 * Build with -DT=<type> -DALT=0|1 (ALT=1: bfloat16 layout 1/8/7, ALT=0: IEEE half 1/5/10).
 * Prints one hash per kernel; two builds agree bit-for-bit iff every line matches. */
#include "bench.h"
#ifndef T
#error define T
#endif
#define N 256
typedef unsigned short u16;
static inline u16 bits(T x) { union { T t; u16 u; } c; c.t = x; return c.u; }
static inline T mk(u16 b) { union { T t; u16 u; } c; c.u = b; return c.t; }

static unsigned lcg = 12345;
static unsigned rnd(void) { lcg = lcg * 1103515245u + 12345u; return lcg >> 8; }
/* random value with magnitude in about [2^-3, 2^3) */
static u16 rbits(void) {
  unsigned r = rnd();
  unsigned s = (r >> 20) & 1;
#if ALT
  unsigned e = 124 + (r >> 12) % 6, m = r & 0x7f;
  return (u16)((s << 15) | (e << 7) | m);
#else
  unsigned e = 12 + (r >> 12) % 6, m = r & 0x3ff;
  return (u16)((s << 15) | (e << 10) | m);
#endif
}

T a[N], b[N], c[N], r[N];
float fa[N], fb[N];
int ri[N], ii[N];
static unsigned H;
static void mix(unsigned v) { H = H * 31u + v; }
static void hash_r(const char *name) {
  H = 0; for (int i = 0; i < N; i++) mix(bits(r[i]));
  bench_puts(name); bench_puts(" "); bench_print_hex(H); bench_puts("\n");
}

__attribute__((noinline)) void k_expr(void) { for (int i = 0; i < N; i++) r[i] = (a[i] + b[i]) * c[i] - a[i]; }
__attribute__((noinline)) void k_div(void)  { for (int i = 0; i < N; i++) r[i] = a[i] * b[i] * c[i] + a[i] / b[i]; }
__attribute__((noinline)) T k_dot(void)     { T acc = 0; for (int i = 0; i < N; i++) acc = acc + a[i] * b[i]; return acc; }
__attribute__((noinline)) T k_dot_sep(void) { T acc = 0; for (int i = 0; i < N; i++) { T t = a[i] * b[i]; acc = acc + t; } return acc; }
__attribute__((noinline)) void k_toint(void){ for (int i = 0; i < N; i++) ri[i] = (int)(a[i] * (T)8); }
__attribute__((noinline)) void k_fromf(void){ for (int i = 0; i < N; i++) r[i] = (T)(fa[i] * fb[i]); }
__attribute__((noinline)) void k_tof(void)  { for (int i = 0; i < N; i++) fa[i] = (float)a[i] * (float)b[i]; }
__attribute__((noinline)) void k_fromi(void){ for (int i = 0; i < N; i++) r[i] = (T)ii[i]; }
__attribute__((noinline)) int  k_cmp(void)  { int n = 0; for (int i = 0; i < N; i++) n += a[i] < b[i]; return n; }

int main(void) {
  for (int i = 0; i < N; i++) { a[i] = mk(rbits()); b[i] = mk(rbits()); c[i] = mk(rbits()); }
  for (int i = 0; i < N; i++) { fa[i] = (float)(int)(rnd() % 20000 - 10000) / 997.0f; fb[i] = (float)(int)(rnd() % 20000 - 10000) / 991.0f;
                                ii[i] = (i & 1) ? (int)((rnd() << 8) ^ rnd()) : (int)(rnd() % 70000) - 35000; }
  k_expr(); hash_r("expr   ");
  k_div();  hash_r("div    ");
  { T d = k_dot();     bench_puts("dot     "); bench_print_hex(bits(d)); bench_puts("\n"); }
  { T d = k_dot_sep(); bench_puts("dot_sep "); bench_print_hex(bits(d)); bench_puts("\n"); }
  k_toint(); H = 0; for (int i = 0; i < N; i++) mix((unsigned)ri[i]); bench_puts("toint   "); bench_print_hex(H); bench_puts("\n");
  k_fromf(); hash_r("fromf  ");
  k_fromi(); hash_r("fromi  ");
  k_tof(); H = 0; for (int i = 0; i < N; i++) { union { float f; unsigned u; } q; q.f = fa[i]; mix(q.u); } bench_puts("tof     "); bench_print_hex(H); bench_puts("\n");
  bench_puts("cmp     "); bench_print_i32(k_cmp()); bench_puts("\n");
  /* single values for eyeballing */
  bench_puts("toint(2.75) "); { volatile T x = (T)2.75f; bench_print_i32((int)x); } bench_puts("\n");
  bench_puts("toint(-2.75) "); { volatile T x = (T)-2.75f; bench_print_i32((int)x); } bench_puts("\n");
  bench_puts("toint(2.5) "); { volatile T x = (T)2.5f; bench_print_i32((int)x); } bench_puts("\n");
  return 0;
}
