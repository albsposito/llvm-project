#include "bench.h"
/* bf16: 1.0 = 0x3F80, -1.0 = 0xBF80. rs1 = {+1,+1}, rs2 = {lane0:+1, lane1:-1} */
static unsigned sgnj(unsigned a, unsigned b)  { unsigned r; __asm__ volatile("vfsgnj.ah %0,%1,%2"   : "=r"(r) : "r"(a), "r"(b)); return r; }
static unsigned sgnjr(unsigned a, unsigned b) { unsigned r; __asm__ volatile("vfsgnj.r.ah %0,%1,%2" : "=r"(r) : "r"(a), "r"(b)); return r; }
static unsigned sgnjn(unsigned a, unsigned b) { unsigned r; __asm__ volatile("vfsgnjn.ah %0,%1,%2"  : "=r"(r) : "r"(a), "r"(b)); return r; }
int main(void) {
  volatile unsigned a = 0x3F803F80u, b = 0xBF803F80u;
  bench_puts("vfsgnj.ah   = 0x"); bench_print_hex(sgnj(a, b));  bench_puts("  (expected 0xbf803f80: per-lane sign)\n");
  bench_puts("vfsgnj.r.ah = 0x"); bench_print_hex(sgnjr(a, b)); bench_puts("  (expected 0x3f803f80: lane-0 sign replicated)\n");
  bench_puts("vfsgnjn.ah  = 0x"); bench_print_hex(sgnjn(a, b)); bench_puts("  (expected 0x3f80bf80: control, per-lane negated sign)\n");
  return 0;
}
