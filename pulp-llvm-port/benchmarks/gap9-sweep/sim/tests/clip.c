#include "bench.h"
static const int32_t in[] = {-1000, -129, -128, -65, -64, 63, 64, 127, 128, 1000};
static volatile int32_t vin[10];
__attribute__((noinline)) int32_t do_clip(int32_t x) { return __builtin_pulp_clip(x, -128, 127); }
int main(void)
{
    int bad = 0;
    for (int i = 0; i < 10; i++) vin[i] = in[i];
    for (int i = 0; i < 10; i++) {
        int32_t x = vin[i];
        int32_t r = do_clip(x);
        int32_t e = x < -128 ? -128 : (x > 127 ? 127 : x);
        bench_puts("clip("); bench_print_i32(x); bench_puts(") = "); bench_print_i32(r);
        bench_puts("  expected "); bench_print_i32(e);
        bench_puts(r == e ? "  OK\n" : "  MISMATCH\n");
        bad += (r != e);
    }
    bench_puts(bad ? "CLIP: MISMATCHES=" : "CLIP: ALL OK, mismatches="); bench_print_i32(bad); bench_putchar('\n');
    return bad;
}
