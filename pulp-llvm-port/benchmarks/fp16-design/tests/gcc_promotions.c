void vf(int,...);
void g(float16alt b){vf(1,b);}
int s(float16 a, float16alt b){return sizeof(a+b);} int t(float16 a, float16alt b){ return __builtin_types_compatible_p(__typeof__(a+b), float16alt);}
float16alt k(float16alt a){ return a*2.0; }
float16 k2(float16 a){ return a*2.5; }
float16 k3(float16 a){ return a*(float16)2.5; }
float16 k4(float16 a, float f){ return a*f; }
