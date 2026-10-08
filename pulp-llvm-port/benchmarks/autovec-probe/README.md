# Auto-vectorization probe (backlog B156)

Three plain C loops (`loops.c`): 16-bit add, 8-bit add, 16-bit dot product.

    clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -mPE=8 -mabi=ilp32 -O3 -S loops.c
    riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O3 -S loops.c

Result on 2026-10-07 (clang = int-20 26e7268c3127, GAP9 GCC 7.1.1), counting `pv.*` instructions:

| compiler | -O2 | -O3 |
|---|---|---|
| GAP9 GCC | 0 | `pv.add.h` (add16), `pv.add.b` (add8); dot16 not vectorized |
| clang | 0 | 0 |
