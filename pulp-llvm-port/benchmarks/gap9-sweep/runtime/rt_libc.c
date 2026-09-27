/* memcpy/memset for the bare-metal target (no libc is linked). Compiled with the same compiler
 * as the rest of the build, with -ffreestanding -fno-builtin so the loops are not turned back
 * into memcpy/memset calls. Only used outside the timed region (aggregate initialisers). */
#include <stddef.h>
void *memcpy(void *d, const void *s, size_t n)
{ unsigned char *a = d; const unsigned char *b = s; while (n--) *a++ = *b++; return d; }
void *memset(void *d, int c, size_t n)
{ unsigned char *a = d; while (n--) *a++ = (unsigned char)c; return d; }
