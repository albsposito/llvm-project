/* GAP9 GCC 7.1.1 vs GVSoC2 (ri5ky_testbench): `a*b - c` on a v2h (two float16) vector.
 * GCC emits `vfmre.h c, a, b` for msub() below; GVSoC executes vfmre.h as c - a*b, so msub() returns the
 * negated result (the same value as nmsub()). This makes GCC's f16/f16alt RFFT and IRFFT wrong on GVSoC
 * (see ../report.txt, "GCC f16 RFFT / IRFFT"). Which side is right needs a run on silicon.
 *
 *   S=benchmarks/gap9-sweep/sim
 *   riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -ffreestanding -fno-builtin -nostdlib -static \
 *       -I$S -T $S/link.ld $S/crt0.S gcc_vfmre_sign.c -lgcc -o t.elf && $S/run_sim.sh t.elf
 * Output on GVSoC2 (2026-10-06):
 *   msub  a*b-c 0x0000c100 0x00004540      <- expected 0x4100 0xc540 (2.5, -5.25)
 *   nmsub c-a*b 0x0000c100 0x00004540
 *   madd  a*b+c 0x00004300 0x0000c4c0
 */
#include "bench.h"
typedef float16 v2h __attribute__((vector_size(4)));
__attribute__((noinline)) v2h msub(v2h a, v2h b, v2h c) { return a * b - c; }     /* t1 = t2 - xA with t2 = xB*k */
__attribute__((noinline)) v2h nmsub(v2h a, v2h b, v2h c) { return c - a * b; }
__attribute__((noinline)) v2h madd(v2h a, v2h b, v2h c) { return a * b + c; }
static void pr(const char *n, v2h r) { union { v2h v; unsigned short s[2]; } u; u.v = r; bench_puts(n); bench_puts(" "); bench_print_hex(u.s[0]); bench_puts(" "); bench_print_hex(u.s[1]); bench_puts("\n"); }
int main(void) {
    volatile float16 a0 = 3.0f, a1 = 5.0f, b0 = 1.0f, b1 = -1.0f, c0 = 0.5f, c1 = 0.25f;
    v2h a = {a0, a1}, b = {b0, b1}, c = {c0, c1};
    pr("msub  a*b-c", msub(a, b, c));     /* expect 2.5 (0x4100), -5.25 (0xc540) */
    pr("nmsub c-a*b", nmsub(a, b, c));    /* expect -2.5 (0xc100), 5.25 (0x4540) */
    pr("madd  a*b+c", madd(a, b, c));     /* expect 3.5 (0x4300), -4.75 (0xc4c0) */
    return 0;
}
