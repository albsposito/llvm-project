/* Checks how GAP9 float16alt (bfloat16) arithmetic rounds on GVSoC: GCC's native
 * fadd.ah / fmul.ah / fcvt.ah.s against float arithmetic + explicit round-to-nearest-even
 * (RNE) or truncation (RTZ) to bfloat16. Build with GAP9 GCC only. */
#include "bench.h"
typedef unsigned short u16; typedef unsigned u32;
static inline u16 ab(float16alt x) { union { float16alt t; u16 u; } c; c.t = x; return c.u; }
static inline float16alt mka(u16 b) { union { float16alt t; u16 u; } c; c.u = b; return c.t; }
static inline u32 fb(float x) { union { float f; u32 u; } c; c.f = x; return c.u; }
static inline float bf(u32 u) { union { float f; u32 u; } c; c.u = u; return c.f; }
static u16 rne(float f) { u32 u = fb(f); u32 lsb = (u >> 16) & 1; u += 0x7fff + lsb; return u >> 16; }
static u16 rtz(float f) { return fb(f) >> 16; }
static unsigned lcg = 777;
static unsigned rnd(void) { lcg = lcg * 1103515245u + 12345u; return lcg >> 8; }
static u16 rbits(void) { unsigned r = rnd(); return (u16)((((r >> 20) & 1) << 15) | ((124 + (r >> 12) % 6) << 7) | (r & 0x7f)); }
volatile float16alt va, vb; volatile float vf;
int main(void) {
  int add_rne = 0, add_rtz = 0, mul_rne = 0, mul_rtz = 0, cvt_rne = 0, cvt_rtz = 0, n = 2000, shown = 0;
  for (int i = 0; i < n; i++) {
    u16 x = rbits(), y = rbits();
    va = mka(x); vb = mka(y);
    u16 s = ab(va + vb), p = ab(va * vb);
    float fx = bf((u32)x << 16), fy = bf((u32)y << 16);
    add_rne += s == rne(fx + fy); add_rtz += s == rtz(fx + fy);
    mul_rne += p == rne(fx * fy); mul_rtz += p == rtz(fx * fy);
    vf = fx * 1.2345f; u16 c = ab((float16alt)vf);
    cvt_rne += c == rne(vf); cvt_rtz += c == rtz(vf);
    if (s != rne(fx + fy) && shown < 3) { shown++; bench_puts("add "); bench_print_hex(x); bench_puts(" "); bench_print_hex(y);
      bench_puts(" hw="); bench_print_hex(s); bench_puts(" rne="); bench_print_hex(rne(fx + fy)); bench_puts(" rtz="); bench_print_hex(rtz(fx + fy)); bench_puts("\n"); }
  }
  bench_puts("of "); bench_print_i32(n); bench_puts(" samples, results equal to RNE / RTZ reference:\n");
  bench_puts("fadd.ah   "); bench_print_i32(add_rne); bench_puts(" / "); bench_print_i32(add_rtz); bench_puts("\n");
  bench_puts("fmul.ah   "); bench_print_i32(mul_rne); bench_puts(" / "); bench_print_i32(mul_rtz); bench_puts("\n");
  bench_puts("fcvt.ah.s "); bench_print_i32(cvt_rne); bench_puts(" / "); bench_print_i32(cvt_rtz); bench_puts("\n");
  return 0;
}
