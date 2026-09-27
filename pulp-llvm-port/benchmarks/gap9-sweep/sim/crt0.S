/* Minimal bare-metal startup for the GVSoC2 ri5ky_testbench target.
 * Boot address is 0x80 (RTL BOOT_ADDR); link.ld places .text.init there. */
    .section .text.init, "ax"
    .globl _start
    .type _start, @function
_start:
    .option push
    .option norelax
    la      gp, __global_pointer$
    .option pop
    la      sp, __stack_top
    /* clear .bss */
    la      t0, __bss_start
    la      t1, __bss_end
1:  bgeu    t0, t1, 2f
    sw      zero, 0(t0)
    addi    t0, t0, 4
    j       1b
2:
#ifdef BENCH_FAST_MODE
    /* leave PCMR.active = 0: GVSoC fast (functional) executor */
#else
    /* PCER = all events, PCMR = active: counters on and GVSoC forced onto the
     * slow cycle-accurate executor (see gvsoc2/pulp/tests/ri5ky_testbench/calibration/calib.h). */
    li      t0, 0xFFF
    csrw    0xCC0, t0
    li      t0, 1
    csrw    0xCC1, t0
#endif
    li      a0, 0
    li      a1, 0
    call    main
    /* exit(code): MMIO 0x10000004 */
    li      t0, 0x10000000
    sw      a0, 4(t0)
3:  j       3b
    .size _start, .-_start
