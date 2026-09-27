/* clip probe: clip_s8 = __builtin_pulp_clip(x,-128,127), clipu_u8 = __builtin_pulp_clipu(x,0,255)
 * over 1024 inputs in [-400, 400] (both bounds are hit often). */
#include "rt.h"
extern int clip_s8(int x);
extern unsigned int clipu_u8(int x);
#define N 1024
static int32_t X[N], Y1[N];
static uint32_t Y2[N];
__attribute__((noinline)) static void run(uint32_t n)
{ for (uint32_t i = 0; i < n; i++) { Y1[i] = clip_s8(X[i]); Y2[i] = clipu_u8(X[i]); } }
int main(void)
{
    uint32_t n = rt_n(N);
    rt_seed(0x100cu); rt_fill_i32(X, n, -400, 400);
    RT_BENCH(run(n));
    rt_result("clip", rt_hash(Y1, sizeof Y1) ^ (rt_hash(Y2, sizeof Y2) * 3u));
    return 0;
}
