// GAP9 does single misaligned scalar loads and stores correctly (board test t9,
// B158), so the driver adds +unaligned-scalar-mem when -march has xgap9, the
// way it does for Android. -mstrict-align / -mscalar-strict-align still win,
// and they must not remove the GAP9 extension itself. Vector (RVV) unaligned
// access is not enabled, and nothing is added without xgap9.

// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -### %s -fsyntax-only 2>&1 \
// RUN:   | FileCheck %s -check-prefixes=XGAP,FAST
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -mstrict-align -### %s -fsyntax-only 2>&1 \
// RUN:   | FileCheck %s -check-prefixes=XGAP,STRICT
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -mscalar-strict-align -### %s -fsyntax-only 2>&1 \
// RUN:   | FileCheck %s -check-prefixes=XGAP,STRICT
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -mstrict-align -mno-scalar-strict-align -### %s -fsyntax-only 2>&1 \
// RUN:   | FileCheck %s -check-prefixes=XGAP,FAST
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_xpulpv2 -### %s -fsyntax-only 2>&1 \
// RUN:   | FileCheck %s -check-prefix=NONE
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_zfinx_zhinx_xpulpv2 -### %s -fsyntax-only 2>&1 \
// RUN:   | FileCheck %s -check-prefix=NONE

// XGAP: "-target-feature" "+xgap"
// FAST: "-target-feature" "+unaligned-scalar-mem"
// FAST-NOT: "-target-feature" "+unaligned-vector-mem"
// STRICT: "-target-feature" "-unaligned-scalar-mem"
// STRICT-NOT: "-target-feature" "+unaligned-scalar-mem"
// NONE-NOT: "-target-feature" "+xgap"
// NONE-NOT: "-target-feature" "{{[+-]}}unaligned-scalar-mem"
