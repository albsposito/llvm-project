#include "bench.h"
__attribute__((noinline))
unsigned checksum(const unsigned char *buf, unsigned len, unsigned rounds) {
  unsigned acc = 0, key = 0;
  if (len) key = 5;
  for (unsigned r = 0; r < rounds; r++) key ^= 79u;
  for (unsigned i = 0; i < len; i++) acc += buf[i];
  return acc ^ key;
}
unsigned char data[4] = {1, 2, 3, 4};
volatile unsigned vlen = 4, vrounds = 3;
int main(void) {
  unsigned r = checksum(data, vlen, vrounds);
  bench_puts("checksum = 0x"); bench_print_hex(r); bench_puts("\n");
  return 0;
}
