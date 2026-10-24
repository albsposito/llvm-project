// GAP9 GCC (newlib) defines [u]int32_t and [u]int_least32_t as [unsigned]
// long and [u]int_fast32_t as [unsigned] int. With xgap9 ("xgap") clang
// predefines the same types; without it the RISC-V default (int) is kept.
// Sizes and alignment do not change. Hand-written CHECK lines: no update
// script applies to -dM output.
// RUN: %clang_cc1 -triple riscv32-unknown-elf -target-feature +xpulpv \
// RUN:   -target-feature +xgap -E -dM %s -o - | FileCheck --check-prefix=GAP9 %s
// RUN: %clang_cc1 -triple riscv32-unknown-elf -target-feature +xpulpv \
// RUN:   -E -dM %s -o - | FileCheck --check-prefix=PLAIN %s
// RUN: %clang_cc1 -triple riscv32-unknown-elf -target-feature +xpulpv \
// RUN:   -target-feature +xgap -fsyntax-only -verify %s

// expected-no-diagnostics
_Static_assert(sizeof(__INT32_TYPE__) == 4 && _Alignof(__INT32_TYPE__) == 4, "");
_Static_assert(sizeof(long) == 4 && _Alignof(long) == 4, "");
_Static_assert(__builtin_types_compatible_p(__INT32_TYPE__, long), "");
_Static_assert(__builtin_types_compatible_p(__UINT32_TYPE__, unsigned long), "");
_Static_assert(__builtin_types_compatible_p(__INT_LEAST32_TYPE__, long), "");
_Static_assert(__builtin_types_compatible_p(__INT_FAST32_TYPE__, int), "");
_Static_assert(__builtin_types_compatible_p(__typeof__(__INT32_MAX__), long), "");
_Static_assert(__builtin_types_compatible_p(__typeof__(__UINT32_C(1)), unsigned long), "");

// GAP9-DAG: #define __INT32_C(c) c##L
// GAP9-DAG: #define __INT32_C_SUFFIX__ L
// GAP9-DAG: #define __INT32_FMTd__ "ld"
// GAP9-DAG: #define __INT32_FMTi__ "li"
// GAP9-DAG: #define __INT32_MAX__ 2147483647L
// GAP9-DAG: #define __INT32_TYPE__ long int
// GAP9-DAG: #define __UINT32_C(c) c##UL
// GAP9-DAG: #define __UINT32_C_SUFFIX__ UL
// GAP9-DAG: #define __UINT32_FMTu__ "lu"
// GAP9-DAG: #define __UINT32_FMTx__ "lx"
// GAP9-DAG: #define __UINT32_MAX__ 4294967295UL
// GAP9-DAG: #define __UINT32_TYPE__ long unsigned int
// GAP9-DAG: #define __INT_LEAST32_FMTd__ "ld"
// GAP9-DAG: #define __INT_LEAST32_MAX__ 2147483647L
// GAP9-DAG: #define __INT_LEAST32_TYPE__ long int
// GAP9-DAG: #define __UINT_LEAST32_FMTu__ "lu"
// GAP9-DAG: #define __UINT_LEAST32_MAX__ 4294967295UL
// GAP9-DAG: #define __UINT_LEAST32_TYPE__ long unsigned int
// GAP9-DAG: #define __INT_FAST32_FMTd__ "d"
// GAP9-DAG: #define __INT_FAST32_MAX__ 2147483647{{$}}
// GAP9-DAG: #define __INT_FAST32_TYPE__ int
// GAP9-DAG: #define __UINT_FAST32_MAX__ 4294967295U{{$}}
// GAP9-DAG: #define __UINT_FAST32_TYPE__ unsigned int
// GAP9-DAG: #define __INT16_TYPE__ short
// GAP9-DAG: #define __INT64_TYPE__ long long int
// GAP9-DAG: #define __INTPTR_TYPE__ int
// GAP9-DAG: #define __SIZE_TYPE__ unsigned int
// GAP9-DAG: #define __SIZEOF_LONG__ 4
// GAP9-NOT: #define __INT32_TYPE__ int

// PLAIN-DAG: #define __INT32_C(c) c{{$}}
// PLAIN-DAG: #define __INT32_FMTd__ "d"
// PLAIN-DAG: #define __INT32_MAX__ 2147483647{{$}}
// PLAIN-DAG: #define __INT32_TYPE__ int
// PLAIN-DAG: #define __UINT32_C(c) c##U{{$}}
// PLAIN-DAG: #define __UINT32_MAX__ 4294967295U{{$}}
// PLAIN-DAG: #define __UINT32_TYPE__ unsigned int
// PLAIN-DAG: #define __INT_LEAST32_TYPE__ int
// PLAIN-DAG: #define __UINT_LEAST32_TYPE__ unsigned int
// PLAIN-DAG: #define __INT_FAST32_TYPE__ int
// PLAIN-DAG: #define __UINT_FAST32_TYPE__ unsigned int
