/* k01 KerFirSeq (int16 FIR, sumdotp2 inner loop): 256 samples x 32 taps, Norm 12.
 * DelayLine holds NCoeffs-1 history samples followed by the NSamples new ones; every call shifts
 * the last NCoeffs-1 samples to the front (streaming FIR), so the state after the warm-up call
 * is the same before each timed call. Samples in [-8192,8191], taps in [-4096,4095]:
 * |Acc| < 32*2^25 = 2^30 (no int32 overflow). KerFirSeq reads v2s at odd int16 offsets
 * (InV2 = &DelayLine[2i+1]): misaligned 32-bit loads, as in the SDK.
 * KerFirSeqBaseline (same TU, plain C) runs once untimed on a copy; both outputs are checksummed. */
#include "rt.h"
extern void KerFirSeq(short *DelayLine, short *Coeffs, int *Out, int NCoeffs, int NSamples, int Norm);
extern void KerFirSeqBaseline(short *DelayLine, short *Coeffs, int *Out, int NCoeffs, int NSamples, int Norm);
#define NS 256
#define NC 32
static int16_t DL[NC - 1 + NS], DL2[NC - 1 + NS], Co[NC];
static int32_t Out[NS], Out2[NS];
RT_UNTIMED static void copy_i16(int16_t *d, const int16_t *s, uint32_t n) { for (uint32_t i = 0; i < n; i++) d[i] = s[i]; }
int main(void)
{
    rt_seed(0x1001u); rt_fill_i16(DL, rt_n(NC - 1 + NS), -8192, 8191);
    rt_seed(0x2001u); rt_fill_i16(Co, rt_n(NC), -4096, 4095);
    copy_i16(DL2, DL, rt_n(NC - 1 + NS));
    int nc = rt_n(NC), ns = rt_n(NS), norm = rt_n(12);
    KerFirSeqBaseline(DL2, Co, Out2, nc, ns, norm);                 /* untimed cross-check */
    RT_BENCH(KerFirSeq(DL, Co, Out, nc, ns, norm));
    uint32_t h = rt_hash(Out, sizeof Out);
    h = h * 31u + rt_hash(Out2, sizeof Out2);
    h = h * 31u + rt_hash(DL, sizeof DL) + rt_hash(DL2, sizeof DL2);
    rt_result("k01_fir_fix16", h);
    return 0;
}
