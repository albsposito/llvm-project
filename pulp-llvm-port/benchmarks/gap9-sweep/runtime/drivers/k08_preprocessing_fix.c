/* k08 MFCC front end, fixed point (PreProcessingFix.c): PreEmphasis (includes get_max: dynamic
 * shift to Q13, factor Q15(0.97)) followed by WindowingReal2Cmplx_Fix16 (400-sample Q15 window,
 * zero padded to a 512-point complex frame), both inside the timed region.
 * Frame: 512 int16 in [-4096,4095] (shift > 0 path). Window: integer Welch (parabolic) window,
 * w[i] = 32767*4*i*(N-1-i)/(N-1)^2, computed exactly in integers. PreEmphasis updates Arg->Prev
 * to the last input sample, so every timed call sees the same state as the one before it.
 * Checksum: pre-emphasised frame, windowed complex frame, the shift. */
#include "rt.h"
typedef struct { void *__restrict__ Frame; void *__restrict__ Out; short int Prev; short int PreempFactor;
                 short int *Shift; short int QIn_FFT; int FrameSize; int maxin[8]; } PreEmphasis_T;
typedef struct { void *__restrict__ Frame; void *__restrict__ OutFrame; void *__restrict__ Window;
                 int FrameSize; int WinSize; int NFrames; int FrameHop; } Windowing_T;
extern void PreEmphasis(PreEmphasis_T *Arg);
extern void WindowingReal2Cmplx_Fix16(Windowing_T *Arg);
#define FS 512
#define WS 400
static int16_t Frame[FS], Pre[FS], Win[WS], Cplx[2 * FS];
static int16_t Shift;
RT_UNTIMED static void welch(int16_t *w, uint32_t n)
{
    int64_t d = (int64_t)(n - 1) * (n - 1);
    for (uint32_t i = 0; i < n; i++) w[i] = (int16_t)((int64_t)32767 * 4 * i * (n - 1 - i) / d);
}
int main(void)
{
    rt_seed(0x1008u); rt_fill_i16(Frame, rt_n(FS), -4096, 4095);
    welch(Win, rt_n(WS));
    PreEmphasis_T p = { Frame, Pre, 0, 31785 /* Q15(0.97) */, &Shift, 13, FS, {0} };
    Windowing_T w = { Pre, Cplx, Win, FS, WS, 1, 0 };
    RT_BENCH((PreEmphasis(&p), WindowingReal2Cmplx_Fix16(&w)));
    uint32_t h = rt_hash(Pre, sizeof Pre);
    h = h * 31u + rt_hash(Cplx, sizeof Cplx);
    h = h * 31u + (uint16_t)Shift;
    rt_result("k08_preprocessing_fix", h);
    return 0;
}
