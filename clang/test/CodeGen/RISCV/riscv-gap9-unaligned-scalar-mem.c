// Driver to assembly: with -march=rv32imc_xgap9 the driver enables
// unaligned-scalar-mem (B158), so packed-struct fields and small memcpy are
// single lw/sw/lh/lhu/sh, as with GAP9 GCC. -mstrict-align and
// -mscalar-strict-align bring back byte accesses and keep the GAP9-only
// instructions (pv.add.h.div2). Without xgap9 (plain PULPv2) accesses are
// byte-split. Plain llc/opt do not get the feature: they need
// -mattr=+unaligned-scalar-mem.
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -O2 -S -o - %s \
// RUN:   | FileCheck %s -check-prefixes=CHECK,GAP9
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -Os -S -o - %s \
// RUN:   | FileCheck %s -check-prefixes=CHECK,GAP9
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -mstrict-align -O2 -S -o - %s \
// RUN:   | FileCheck %s -check-prefixes=CHECK,STRICT,STRICTG9
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -mscalar-strict-align -O2 -S -o - %s \
// RUN:   | FileCheck %s -check-prefixes=CHECK,STRICT,STRICTG9
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_xpulpv2 -DNO_GAP9 -O2 -S -o - %s \
// RUN:   | FileCheck %s -check-prefixes=CHECK,STRICT

struct __attribute__((packed)) rec {
  unsigned char tag;
  int w;
  short h;
  unsigned short uh;
};

// CHECK-LABEL: get_w:
// GAP9:         lw a0, 1(a0)
// GAP9-NEXT:    ret
// STRICT-COUNT-4: lbu
// STRICT-NOT:   lw
// STRICT:       ret
int get_w(struct rec *r) { return r->w; }

// CHECK-LABEL: get_h:
// GAP9:         lh a0, 5(a0)
// GAP9-NEXT:    ret
// STRICT:       lb
// STRICT-NOT:   lh
// STRICT:       ret
int get_h(struct rec *r) { return r->h; }

// CHECK-LABEL: get_uh:
// GAP9:         lhu a0, 7(a0)
// GAP9-NEXT:    ret
// STRICT-COUNT-2: lbu
// STRICT-NOT:   lhu
// STRICT:       ret
unsigned get_uh(struct rec *r) { return r->uh; }

// CHECK-LABEL: set_w:
// GAP9:         sw a1, 1(a0)
// GAP9-NEXT:    ret
// STRICT-COUNT-4: sb
// STRICT-NOT:   sw
// STRICT:       ret
void set_w(struct rec *r, int v) { r->w = v; }

// CHECK-LABEL: set_h:
// GAP9:         sh a1, 5(a0)
// GAP9-NEXT:    ret
// STRICT-COUNT-2: sb
// STRICT-NOT:   sh
// STRICT:       ret
void set_h(struct rec *r, short v) { r->h = v; }

// CHECK-LABEL: cpy8:
// GAP9-COUNT-2: lw
// GAP9-NOT:     lbu
// GAP9:         ret
// STRICT-COUNT-8: lbu
// STRICT:       ret
void cpy8(void *d, const void *s) { __builtin_memcpy(d, s, 8); }

#ifndef NO_GAP9
typedef short v2s __attribute__((vector_size(4)));
// GAP9-LABEL:     add2div2:
// GAP9:           pv.add.h.div2 a0, a0, a1
// STRICTG9-LABEL: add2div2:
// STRICTG9:       pv.add.h.div2 a0, a0, a1
v2s add2div2(v2s a, v2s b) { return __builtin_pulp_add2div2(a, b); }

// GAP9-LABEL:     asm_div2:
// GAP9:           pv.add.h.div2
// STRICTG9-LABEL: asm_div2:
// STRICTG9:       pv.add.h.div2
int asm_div2(int a, int b) {
  int r;
  __asm__("pv.add.h.div2 %0, %1, %2" : "=r"(r) : "r"(a), "r"(b));
  return r;
}
#endif
