/* What does vflt.h put in each 16-bit lane on GVSoC (0/1 or 0/-1)? GAP9 GCC only. */
#include "bench.h"
typedef float16 v2h __attribute__((vector_size (4)));
typedef short v2s __attribute__((vector_size (4)));
volatile v2h A = {1.0, 3.0}, B = {2.0, 2.0};
int main(void) {
  v2h a = A, b = B;
  v2s m = a < b;                                   /* lane0: 1<2 true, lane1: 3<2 false */
  union { v2s v; unsigned u; } q; q.v = m;
  bench_puts("vflt.h lanes = "); bench_print_hex(q.u); bench_puts("\n");
  v2h s = (v2h)(((v2s)a & m) | ((v2s)b & ~m));    /* GCC-style select: expects {1.0, 2.0} */
  union { v2h v; unsigned u; } r; r.v = s;
  bench_puts("select       = "); bench_print_hex(r.u); bench_puts(" (want 0x40003c00)\n");
  return 0;
}
