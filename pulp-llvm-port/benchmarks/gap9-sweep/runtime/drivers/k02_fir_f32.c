/* k02 KerFirSeqf32 (fp32 FIR under Zfinx): 256 samples x 32 taps.
 * SDK quirk: the accumulators are declared `int` (Acc1 += float*float truncates to int after every
 * tap), so inputs in [-1,1) would give all-zero outputs. The driver therefore uses integer-valued
 * floats (int16-audio-like samples in [-2048,2047], taps in [-127,127]): every product, partial
 * sum (< 2^23) and conversion is exact, so fused/unfused multiply-add and host/target all agree
 * bit for bit. Streaming delay line as in k01. KerFirSeqBaselinef32 runs once untimed on a copy;
 * both outputs are checksummed and the timed output is dumped (OUTF) for the fp tolerance check. */
#include "rt.h"
extern void KerFirSeqf32(float *DelayLine, float *Coeffs, float *Out, int NCoeffs, int NSamples);
extern void KerFirSeqBaselinef32(float *DelayLine, float *Coeffs, float *Out, int NCoeffs, int NSamples);
#define NS 256
#define NC 32
static float DL[NC - 1 + NS], DL2[NC - 1 + NS], Co[NC], Out[NS], Out2[NS];
RT_UNTIMED static void fill_int_f32(float *p, uint32_t n, int32_t lo, int32_t hi)
{ for (uint32_t i = 0; i < n; i++) p[i] = (float)rt_range(lo, hi); }
RT_UNTIMED static void copy_f32(float *d, const float *s, uint32_t n) { for (uint32_t i = 0; i < n; i++) d[i] = s[i]; }
int main(void)
{
    rt_seed(0x1002u); fill_int_f32(DL, rt_n(NC - 1 + NS), -2048, 2047);
    rt_seed(0x2002u); fill_int_f32(Co, rt_n(NC), -127, 127);
    copy_f32(DL2, DL, rt_n(NC - 1 + NS));
    int nc = rt_n(NC), ns = rt_n(NS);
    KerFirSeqBaselinef32(DL2, Co, Out2, nc, ns);                    /* untimed cross-check */
    RT_BENCH(KerFirSeqf32(DL, Co, Out, nc, ns));
    uint32_t h = rt_hash(Out, sizeof Out);
    h = h * 31u + rt_hash(Out2, sizeof Out2);
    h = h * 31u + rt_hash(DL, sizeof DL) + rt_hash(DL2, sizeof DL2);
    rt_result("k02_fir_f32", h);
    rt_dump_f32(Out, rt_n(NS));
    return 0;
}
