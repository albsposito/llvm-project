/* dsp-bench/sdk-kernels: shared driver helpers on top of gap9-sweep's rt.h / bench.h.
 *
 * One ELF runs several kernel configurations (one app, one data type, all sizes) and prints
 * one RESULT line per configuration:
 *   RESULT kernel=<app>.<function>.N<size> cycles=<per call> instrs=<per call> checksum=0x.. reps=<n>
 * and, for floating-point outputs, one line with the raw output words for tolerance checks:
 *   OUTF <app>.<function>.N<size> <bits> <hex> <hex> ...
 *
 * Timing: each configuration is called 1 + RT_REPS times. Call 0 is the warm-up and is not
 * counted; the others are timed one by one (the input is restored, untimed, before every
 * call, because most kernels work in place). The timed window is
 *     csrr instr ; lw cycle ; <call> ; lw cycle ; csrr instr
 * so it includes the call/return and argument set-up and about 2 instructions of counter
 * reads. Cycles come from the simulator's MMIO cycle counter (low 32 bits), instructions
 * from RI5CY PCCR1. On the host build both read 0. */
#pragma once
#include "rt.h"
#ifdef RT_HOST
static inline uint32_t kb_cyc(void) { return 0; }
#else
static inline uint32_t kb_cyc(void) { return bench_cycles32(); }
#endif
typedef struct { uint32_t c, i, n; } kb_acc_t;
static kb_acc_t kb_dummy;
#define KB_TIME(acc, stmt) do {                                               \
        kb_acc_t *_a = (acc);                                                 \
        uint32_t _i0 = rt_instr(); uint32_t _c0 = kb_cyc();                   \
        stmt;                                                                 \
        uint32_t _c1 = kb_cyc(); uint32_t _i1 = rt_instr();                   \
        _a->c += _c1 - _c0; _a->i += _i1 - _i0; _a->n++;                      \
    } while (0)
/* r == 0 is the warm-up call */
#define KB_ACC(r, acc) ((r) ? &(acc) : &kb_dummy)

RT_UNTIMED static void kb_name(const char *name, uint32_t n)
{ rt_puts(name); rt_puts(".N"); rt_u64(n); }
RT_UNTIMED static void kb_result(const char *name, uint32_t n, const kb_acc_t *a, uint32_t cks)
{
    uint32_t reps = a->n ? a->n : 1;
    rt_puts("RESULT kernel="); kb_name(name, n);
    rt_puts(" cycles="); rt_u64(a->c / reps);
    rt_puts(" instrs="); rt_u64(a->i / reps);
    rt_puts(" checksum="); rt_hex(cks);
    rt_puts(" reps="); rt_u64(a->n);
    rt_puts(" total_cycles="); rt_u64(a->c);
    rt_puts("\n");
}
/* raw dump of `count` elements of `esz` bytes (2 or 4), little endian */
RT_UNTIMED static void kb_dump(const char *name, uint32_t n, const void *p, uint32_t count, uint32_t esz)
{
    const uint8_t *b = (const uint8_t *)p;
    rt_puts("OUTF "); kb_name(name, n); rt_puts(" "); rt_u64(esz * 8);
    for (uint32_t i = 0; i < count; i++) {
        uint32_t v = 0;
        for (uint32_t k = 0; k < esz; k++) v |= (uint32_t)b[i * esz + k] << (8 * k);
        rt_puts(" ");
        for (int s = (int)esz * 8 - 4; s >= 0; s -= 4) {
            char c[2] = { "0123456789abcdef"[(v >> s) & 0xf], 0 };
            rt_puts(c);
        }
    }
    rt_puts("\n");
}
RT_UNTIMED static void kb_copy(void *d, const void *s, uint32_t n)
{ uint8_t *a = (uint8_t *)d; const uint8_t *b = (const uint8_t *)s; for (uint32_t i = 0; i < n; i++) a[i] = b[i]; }

/* float -> bfloat16 (f16alt), round to nearest even, done with integer operations (finite inputs).
 * The drivers use this for every f16alt input conversion, on every compiler and on the host, so
 * that (a) all builds get bit-identical inputs and (b) the driver itself never needs a bfloat16
 * conversion helper: whether an f16alt program links then depends on the SDK kernel only. */
static inline uint16_t kb_bf16(float f)
{ union { float f; uint32_t u; } c; c.f = f; return (uint16_t)((c.u + 0x7fffu + ((c.u >> 16) & 1u)) >> 16); }
#define KB_SET_BF16(dst, v) do { uint16_t _b = kb_bf16((float)(v)); kb_copy(&(dst), &_b, 2); } while (0)

/* Data type selector: -DDT=0 fix16, 1 f32, 2 f16 (IEEE half), 3 f16alt (bfloat16) */
#define DT_FIX16 0
#define DT_F32   1
#define DT_F16   2
#define DT_F16A  3
#if DT == DT_F32 || DT == DT_F16 || DT == DT_F16A
#define DT_IS_FLOAT 1
#else
#define DT_IS_FLOAT 0
#endif
