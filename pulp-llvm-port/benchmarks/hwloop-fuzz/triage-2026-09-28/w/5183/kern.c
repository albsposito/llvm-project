#include <stdint.h>
__attribute__((noinline)) unsigned kern(unsigned *A, unsigned *B, unsigned *out, unsigned n, unsigned m, unsigned k) {
unsigned acc = 1, s = 2, t = 3;
for (unsigned i0 = 0; i0 < n; i0++) { t += 52u; }
for (unsigned i0 = 0; i0 < k; i0++) { t += 79u; }
for (unsigned i0 = 0; i0 < n; i0++) { t += (61u * 5u); t += 26u; s += B[((i0 + 12u) & 63u)]; }
return acc ^ s ^ t;}
