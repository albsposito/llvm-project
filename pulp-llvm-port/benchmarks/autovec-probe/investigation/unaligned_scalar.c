/* B156: do the two compilers already use misaligned 32-bit accesses in scalar code? */
void cp4(char *d, const char *s){ __builtin_memcpy(d, s, 4); }
struct __attribute__((packed)) P { char c; int v; };
int rd(const struct P *p){ return p->v; }
