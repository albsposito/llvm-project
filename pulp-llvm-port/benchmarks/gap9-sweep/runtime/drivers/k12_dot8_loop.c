/* k12 anchor dot8_loop: sdotsp4 over 1024 v4s (4096 int8). */
#include "rt.h"
typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
extern int dot8_loop(const v4s *a, const v4s *b, unsigned n);
#define N 1024
static uint32_t A[N], B[N];
int main(void)
{
    uint32_t n = rt_n(N); int r = 0;
    rt_seed(0x1012u); rt_fill_u32(A, n);
    rt_seed(0x2012u); rt_fill_u32(B, n);
    RT_BENCH(r = dot8_loop((const v4s *)A, (const v4s *)B, n));
    rt_result("k12_dot8_loop", rt_hash(&r, sizeof r));
    return 0;
}
