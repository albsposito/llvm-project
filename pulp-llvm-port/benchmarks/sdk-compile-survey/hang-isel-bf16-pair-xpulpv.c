void f(__bf16 *restrict a, __bf16 *restrict b) { __bf16 x = a[0], y = a[1]; b[0] = x; b[1] = y; }
