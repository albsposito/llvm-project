/* Do the ALTF (.ah) instructions, whose rm field is taken by the 0b101 format code, follow the
 * dynamic rounding mode in frm? Sets frm=RTZ and compares .h (rm=dyn) and .ah results. GAP9 GCC only. */
#include "bench.h"
typedef unsigned short u16;
static inline u16 hb(float16 x) { union { float16 t; u16 u; } c; c.t = x; return c.u; }
static inline u16 ab(float16alt x) { union { float16alt t; u16 u; } c; c.t = x; return c.u; }
volatile float16 h5 = 5.0, h1 = 1.0, h3 = 3.0; volatile float16alt a1 = 1.0f, a3 = 3.0f; volatile float16alt a275 = 2.75f;
static void run(const char *tag) {
  bench_puts(tag);
  bench_puts(" h: 5/3="); bench_print_hex(hb(h5 / h3));
  bench_puts(" ah: 1/3="); bench_print_hex(ab(a1 / a3));
  bench_puts(" (int)2.75ah="); bench_print_i32((int)a275);
  bench_puts("\n");
}
int main(void) {
  run("frm=RNE");
  __asm__ volatile("csrwi frm, 1");   /* RTZ */
  run("frm=RTZ");
  __asm__ volatile("csrwi frm, 2");   /* RDN */
  run("frm=RDN");
  return 0;
}
