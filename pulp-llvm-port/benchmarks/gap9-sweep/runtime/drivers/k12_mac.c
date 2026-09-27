/* k12 anchor mac (19-vs-18/kernels.c): called once per element over N=1024 inputs; the
 * cycle count includes the driver's call loop (same compiler), not only the function body. */
#include "rt.h"
typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
extern unsigned mac(unsigned a, unsigned b, unsigned c);
#define N 1024
static uint32_t A[N], B[N], C[N], O[N];
__attribute__((noinline)) static void run(uint32_t n)
{ for (uint32_t i = 0; i < n; i++) { O[i] = mac(A[i], B[i], C[i]); } }
int main(void)
{
    uint32_t n = rt_n(N);
    rt_seed(0x1012u); rt_fill_u32(A, n);
    rt_seed(0x2012u); rt_fill_u32(B, n);
    rt_seed(0x3012u); rt_fill_u32(C, n);
    RT_BENCH(run(n));
    rt_result("k12_mac", rt_hash(O, sizeof O));
    return 0;
}
