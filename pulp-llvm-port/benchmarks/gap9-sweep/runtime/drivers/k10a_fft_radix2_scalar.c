/* k10a Radix2FFT_DIF_Scalar: 256-point complex int16 radix-2 DIF FFT, in place, output in
 * bit-reversed order (the SDK's SwapSamples step is a separate kernel, not part of this TU).
 * Twiddles: the SDK's R2_Twiddles_fix_256 (TransformFunctions/LUT_Tables/TwiddlesDef.c), copied
 * verbatim below (128 complex Q15 values). Input: 256 complex int16 in [-4096,4095]; the kernel
 * halves after each of the first 7 stages, so no int32/int16 overflow.
 * The FFT is in place, so the warm-up call and each timed call get their own copy of the same
 * input (Data[k], k advanced by one add per call); all five outputs are checksummed. */
#include "rt.h"
extern void Radix2FFT_DIF_Scalar(signed short *__restrict__ Data, signed short *__restrict__ Twiddles, int N_fft);
#define N 256
static short Tw[N] = {
    32767, 0, 32757, -804, 32727, -1607, 32678, -2410, 32609, -3211, 32520, -4011, 32412, -4807, 32284, -5601,
    32137, -6392, 31970, -7179, 31785, -7961, 31580, -8739, 31356, -9511, 31113, -10278, 30851, -11038, 30571, -11792,
    30272, -12539, 29955, -13278, 29621, -14009, 29268, -14732, 28897, -15446, 28510, -16150, 28105, -16845, 27683, -17530,
    27244, -18204, 26789, -18867, 26318, -19519, 25831, -20159, 25329, -20787, 24811, -21402, 24278, -22004, 23731, -22594,
    23169, -23169, 22594, -23731, 22004, -24278, 21402, -24811, 20787, -25329, 20159, -25831, 19519, -26318, 18867, -26789,
    18204, -27244, 17530, -27683, 16845, -28105, 16150, -28510, 15446, -28897, 14732, -29268, 14009, -29621, 13278, -29955,
    12539, -30272, 11792, -30571, 11038, -30851, 10278, -31113, 9511, -31356, 8739, -31580, 7961, -31785, 7179, -31970,
    6392, -32137, 5601, -32284, 4807, -32412, 4011, -32520, 3211, -32609, 2410, -32678, 1607, -32727, 804, -32757,
    0, -32767, -804, -32757, -1607, -32727, -2410, -32678, -3211, -32609, -4011, -32520, -4807, -32412, -5601, -32284,
    -6392, -32137, -7179, -31970, -7961, -31785, -8739, -31580, -9511, -31356, -10278, -31113, -11038, -30851, -11792, -30571,
    -12539, -30272, -13278, -29955, -14009, -29621, -14732, -29268, -15446, -28897, -16150, -28510, -16845, -28105, -17530, -27683,
    -18204, -27244, -18867, -26789, -19519, -26318, -20159, -25831, -20787, -25329, -21402, -24811, -22004, -24278, -22594, -23731,
    -23169, -23169, -23731, -22594, -24278, -22004, -24811, -21402, -25329, -20787, -25831, -20159, -26318, -19519, -26789, -18867,
    -27244, -18204, -27683, -17530, -28105, -16845, -28510, -16150, -28897, -15446, -29268, -14732, -29621, -14009, -29955, -13278,
    -30272, -12539, -30571, -11792, -30851, -11038, -31113, -10278, -31356, -9511, -31580, -8739, -31785, -7961, -31970, -7179,
    -32137, -6392, -32284, -5601, -32412, -4807, -32520, -4011, -32609, -3211, -32678, -2410, -32727, -1607, -32757, -804,
};
static int16_t Data[RT_REPS + 1][2 * N];
RT_UNTIMED static void prep(uint32_t n)
{
    rt_seed(0x100au); rt_fill_i16(Data[0], n, -4096, 4095);
    for (uint32_t k = 1; k < RT_REPS + 1; k++) for (uint32_t i = 0; i < n; i++) Data[k][i] = Data[0][i];
}
RT_UNTIMED static uint32_t cks(void)
{
    uint32_t h = rt_hash(Data[0], sizeof Data[0]);
    for (uint32_t k = 1; k < RT_REPS + 1; k++) h = h * 31u + rt_hash(Data[k], sizeof Data[k]);
    return h;
}
int main(void)
{
    prep(rt_n(2 * N));
    int n = rt_n(N);
    uint32_t k = 0;
    RT_BENCH(Radix2FFT_DIF_Scalar(Data[k++], Tw, n));
    rt_result("k10a_fft_radix2_scalar", cks());
    return 0;
}
