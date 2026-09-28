#include "bench.h"
unsigned kern(unsigned *B, unsigned n, unsigned k);
volatile unsigned vn = 4, vk = 3;
int main(void) {
  unsigned r = kern(0, vn, vk);   /* expected (0+1+2+3) ^ (5^79) = 6 ^ 74 = 0x4c */
  bench_puts("RES "); bench_print_hex(r); bench_puts("\n"); return 0;
}
