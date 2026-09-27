#include "bench.h"
unsigned kern(unsigned *A, unsigned *B, unsigned *out, unsigned n, unsigned m, unsigned k);
static unsigned A[64], B[64], out[64];
volatile unsigned vn = N_, vm = M_, vk = K_;
int main(void) {
  unsigned x = 0x12345u;
  for (volatile int i = 0; i < 64; i++) { x ^= x << 13; x ^= x >> 17; x ^= x << 5; A[i] = x; x ^= x << 13; x ^= x >> 17; x ^= x << 5; B[i] = x; out[i]=0; }
  unsigned r = kern(A, B, out, vn, vm, vk);
  unsigned h = 2166136261u;
  for (volatile int i = 0; i < 64; i++) { h ^= out[i]; h *= 16777619u; }
  bench_puts("RES "); bench_print_hex(r); bench_puts(" "); bench_print_hex(h); bench_puts("\n");
  return 0;
}
