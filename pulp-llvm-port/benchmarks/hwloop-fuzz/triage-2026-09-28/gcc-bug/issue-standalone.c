/* GAP9 GCC 7.1.1 hardware-loop miscompile at -O2 / -O3.
 * Build: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -O2 ...
 * Expected output: checksum = 0x40   (sum 1+2+3+4 = 10, key 5^79^79^79 = 74, 10^74 = 0x40)
 * GAP9 GCC -O2/-O3: checksum = 0x4b  (the byte loop runs only once: 1^74 = 0x4b)
 * GAP9 GCC -O0, -O1, -Os, -O2 -mnohwloop give 0x40. */
#include <stdio.h>

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
  printf("checksum = 0x%x\n", checksum(data, vlen, vrounds));
  return 0;
}
