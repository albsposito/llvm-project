/* Host-only wrapper around the SDK's PiecewiseMathf16.c / PiecewiseMathf16a.c (included unmodified).
 * The SDK's plain-C emulation defines Cvt_v2u_v2h(a) as the cast (v2h)(a), which for GNU C vectors
 * is a bit reinterpretation, not the integer -> float16 value conversion that the GAP9 builtin
 * __builtin_pulp_v2hitov2hf_u does. fastlog2_v2h() needs the value conversion, so with the SDK
 * macro the host log stage is garbage (measured: correlation -0.35 with the reference).
 * This wrapper replaces only that host emulation macro. The target builds do not use it. */
#include "at_api.h"
#include "DspLib.h"
#undef Cvt_v2u_v2h
#define Cvt_v2u_v2h(a) __builtin_convertvector((a), v2h)
#ifdef MFCC_F16A
#include "PiecewiseMathf16a.c"
#else
#include "PiecewiseMathf16.c"
#endif
