#include "bench.h"
__attribute__((noinline))
unsigned kern(unsigned *unused, unsigned n, unsigned k) {
  unsigned s = 0, t = 0;
  if (n) t = 5;
  for (unsigned i = 0; i < k; i++) t ^= 79u;
  for (unsigned i = 0; i < n; i++) s += i;
  return s ^ t;
}
volatile unsigned vn = 4, vk = 3;
int main(void) {
  unsigned r = kern(0, vn, vk);
  bench_puts("result = 0x"); bench_print_hex(r); bench_puts("\n");
  return 0;
}
