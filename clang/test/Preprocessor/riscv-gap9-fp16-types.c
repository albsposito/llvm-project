// GAP9 half-precision type names. GAP9 GCC (-march=rv32imcxgap9) predeclares
// float16 (IEEE binary16) and float16alt (bfloat16); clang maps them onto
// _Float16 and __bf16 when the GAP9 half-precision extensions are on, and
// never otherwise.

// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -E -dM %s \
// RUN:   -o - | FileCheck --check-prefixes=BOTH %s
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_zfinx_zhinx_xpulpv2_xpulpfvec \
// RUN:   -E -dM %s -o - | FileCheck --check-prefixes=F16ONLY %s
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpf16alt \
// RUN:   -E -dM %s -o - | FileCheck --check-prefixes=ALTONLY %s
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_zfinx_zhinx \
// RUN:   -E -dM %s -o - | FileCheck --check-prefixes=NONE %s
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imc_zfinx_zhinx_xpulpv2 \
// RUN:   -E -dM %s -o - | FileCheck --check-prefixes=NONE %s
// RUN: %clang --target=riscv32-unknown-elf -march=rv32imafc_zfh \
// RUN:   -E -dM %s -o - | FileCheck --check-prefixes=NONE %s

// BOTH-DAG: #define __gap9__ 1
// BOTH-DAG: #define float16 _Float16
// BOTH-DAG: #define float16alt __bf16

// F16ONLY: #define float16 _Float16
// F16ONLY-NOT: #define float16alt

// ALTONLY-NOT: #define float16 {{.*}}
// ALTONLY: #define float16alt __bf16
// ALTONLY-NOT: #define float16 {{.*}}

// NONE-NOT: #define float16
