/* Minimal bare-metal helpers for the GVSoC2 ri5ky_testbench target.
 * No libc required: everything is static inline. */
#pragma once
#include <stdint.h>

#define BENCH_MMIO_BASE   0x10000000u
#define BENCH_MMIO_PUTC   (*(volatile uint32_t *)(BENCH_MMIO_BASE + 0x0u))
#define BENCH_MMIO_EXIT   (*(volatile uint32_t *)(BENCH_MMIO_BASE + 0x4u))
#define BENCH_MMIO_CYC_LO (*(volatile uint32_t *)(BENCH_MMIO_BASE + 0x8u))
#define BENCH_MMIO_CYC_HI (*(volatile uint32_t *)(BENCH_MMIO_BASE + 0xCu))

static inline void bench_putchar(char c) { BENCH_MMIO_PUTC = (uint32_t)(unsigned char)c; }

static inline void bench_puts(const char *s) { while (*s) bench_putchar(*s++); }

static inline void bench_print_u64(uint64_t v)
{
    char buf[21]; int i = 20; buf[i] = 0;
    do { buf[--i] = (char)('0' + (unsigned)(v % 10u)); v /= 10u; } while (v);
    bench_puts(&buf[i]);
}

static inline void bench_print_u32(uint32_t v) { bench_print_u64(v); }

static inline void bench_print_i32(int32_t v)
{
    if (v < 0) { bench_putchar('-'); bench_print_u64((uint64_t)(-(int64_t)v)); }
    else bench_print_u64((uint64_t)v);
}

static inline void bench_print_hex(uint32_t v)
{
    bench_puts("0x");
    for (int s = 28; s >= 0; s -= 4) bench_putchar("0123456789abcdef"[(v >> s) & 0xf]);
}

/* 32-bit low half of the free-running simulator cycle counter (cheap: 1 load). */
static inline uint32_t bench_cycles32(void) { return BENCH_MMIO_CYC_LO; }

/* Full 64-bit counter, read hi/lo/hi and retry on carry between the halves. */
static inline uint64_t bench_cycles(void)
{
    uint32_t hi, lo, hi2;
    do {
        hi  = BENCH_MMIO_CYC_HI;
        lo  = BENCH_MMIO_CYC_LO;
        hi2 = BENCH_MMIO_CYC_HI;
    } while (hi != hi2);
    return ((uint64_t)hi << 32) | lo;
}

/* RI5CY PCCR[0] (cycle) / PCCR[1] (instr); only count while PCMR.active=1
 * (crt0.S sets it unless built with -DBENCH_FAST_MODE). */
static inline uint32_t bench_pccr_cycles(void) { uint32_t v; __asm__ volatile("csrr %0, 0x780" : "=r"(v)); return v; }
static inline uint32_t bench_pccr_instr(void)  { uint32_t v; __asm__ volatile("csrr %0, 0x781" : "=r"(v)); return v; }

static inline __attribute__((noreturn)) void bench_exit(int code)
{
    BENCH_MMIO_EXIT = (uint32_t)code;
    for (;;) { }
}
