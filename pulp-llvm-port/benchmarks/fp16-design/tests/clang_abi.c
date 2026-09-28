/* ABI probe: clang _Float16/__bf16 argument passing, compare with gcc_scalar.s (many, call_h). Output clang_abi.s */
typedef _Float16 float16; typedef __bf16 float16alt;
typedef float16 v2h __attribute__((vector_size(4)));
float16 many(float16 a0,float16 a1,float16 a2,float16 a3,float16 a4,float16 a5,float16 a6,float16 a7,float16 a8,float16 a9) { return a0+a9+a8; }
extern float16 ext_h(float16, float16alt, int, float16);
float16 call_h(float16 a, float16alt b) { return ext_h(a, b, 3, a); }
extern float16 ext10(float16,float16,float16,float16,float16,float16,float16,float16,float16,float16);
float16 call10(float16 x) { return ext10(x,x,x,x,x,x,x,x,x,(float16)2); }
float16alt manya(float16alt a0,float16alt a1,float16alt a2,float16alt a3,float16alt a4,float16alt a5,float16alt a6,float16alt a7,float16alt a8,float16alt a9) { return a9; }
v2h vret(v2h a, v2h b) { return b; }
