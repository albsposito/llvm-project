#ifdef HOST
#include <stdio.h>
#define OUT(r) printf("RES 0x%08x\n", r)
#else
#include "bench.h"
#define OUT(r) do { bench_puts("RES "); bench_print_hex(r); bench_puts("\n"); } while (0)
#endif
unsigned kern(unsigned *A, unsigned *B, unsigned n, unsigned k);
static unsigned A[64], B[64];
volatile unsigned vn = 5, vk = 1;
int main(void) {
  for (volatile int i = 0; i < 64; i++) { A[i] = i * 2654435761u; B[i] = i * 40503u + 7; }
  OUT(kern(A, B, vn, vk));
  return 0;
}
