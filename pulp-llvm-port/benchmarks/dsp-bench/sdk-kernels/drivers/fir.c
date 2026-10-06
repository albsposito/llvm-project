/* Fir benchmark app kernels (examples/gap9/dsp/benchmarks/Fir/Test.c).
 * Same problem as the app: N_TAPS=64, BUFFER_SIZE=100 (Kconfig defaults), Norm=0,
 * coefficients {1,0,0,...}, input ramp BufferIn[i]=i. The app times KerFirSeqBaseline, KerFirSeq
 * and KerFirPar (8 cores); here each runs on one core (KerFirPar through the one-core shim).
 * As in the app, KerFirInit reloads the delay line before a run (untimed here, before every call).
 * DT=3 (f16alt): the app does not select it, but its CMakeLists compiles FirBasicKernelsf16a.c. */
#include "kb.h"
#include "DspLib.h"
#define N_TAPS 64
#define BUFFER_SIZE 100
#if DT == DT_F32
#define IN_T float
#define OUT_T float
#define FIR_INIT_FN KerFirInitf32
#define FIR_PAR_FN KerFirParf32
#define FIR_SEQ_BASE_FN(d, c, o, nc, ns, norm) KerFirSeqBaselinef32(d, c, o, nc, ns)
#define FIR_SEQ_OPT_FN(d, c, o, nc, ns, norm) KerFirSeqf32(d, c, o, nc, ns)
#define SUF "f32"
#elif DT == DT_F16
#define IN_T f16
#define OUT_T f16
#define FIR_INIT_FN KerFirInitf16
#define FIR_PAR_FN KerFirParf16
#define FIR_SEQ_BASE_FN(d, c, o, nc, ns, norm) KerFirSeqBaselinef16(d, c, o, nc, ns)
#define FIR_SEQ_OPT_FN(d, c, o, nc, ns, norm) KerFirSeqf16(d, c, o, nc, ns)
#define SUF "f16"
#elif DT == DT_F16A
#define IN_T f16a
#define OUT_T f16a
#define FIR_INIT_FN KerFirInitf16a
#define FIR_PAR_FN KerFirParf16a
#define FIR_SEQ_BASE_FN(d, c, o, nc, ns, norm) KerFirSeqBaselinef16a(d, c, o, nc, ns)
#define FIR_SEQ_OPT_FN(d, c, o, nc, ns, norm) KerFirSeqf16a(d, c, o, nc, ns)
#define SUF "f16a"
#else
#define IN_T int16_t
#define OUT_T int
#define FIR_INIT_FN KerFirInit
#define FIR_PAR_FN KerFirPar
#define FIR_SEQ_BASE_FN(d, c, o, nc, ns, norm) KerFirSeqBaseline(d, c, o, nc, ns, norm)
#define FIR_SEQ_OPT_FN(d, c, o, nc, ns, norm) KerFirSeq(d, c, o, nc, ns, norm)
#define SUF ""
#endif

static IN_T MyFir[N_TAPS], BufferIn[BUFFER_SIZE], DelayLine[BUFFER_SIZE + N_TAPS - 1];
static OUT_T BufferOut[BUFFER_SIZE];

RT_UNTIMED static void prep(uint32_t taps, uint32_t n)
{
    for (uint32_t i = 0; i < taps; i++) MyFir[i] = 0;
    MyFir[0] = 1;
#if DT == DT_F16A
    for (uint32_t i = 0; i < n; i++) KB_SET_BF16(BufferIn[i], (int)i);
#else
    for (uint32_t i = 0; i < n; i++) BufferIn[i] = (IN_T)(int)i;
#endif
}
RT_UNTIMED static uint32_t cks(void)
{ return rt_hash(BufferOut, sizeof BufferOut) * 31u + rt_hash(DelayLine, sizeof DelayLine); }

#define RUN(sel, name, call) if (KSEL < 0 || KSEL == (sel)) {                              \
        kb_acc_t acc = {0, 0, 0}; uint32_t h = 0, reps = rt_reps_v;                        \
        for (uint32_t r = 0; r <= reps; r++) {                                             \
            FIR_INIT_FN(DelayLine, BufferIn, taps, n);                                     \
            KB_TIME(KB_ACC(r, acc), call);                                                 \
            h = h * 31u + cks();                                                           \
        }                                                                                  \
        kb_result(name, n, &acc, h);                                                       \
        if (DT_IS_FLOAT) kb_dump(name, n, BufferOut, n, sizeof(OUT_T));                    \
    }
#ifndef KSEL
#define KSEL -1
#endif
int main(void)
{
    int taps = rt_n(N_TAPS), n = rt_n(BUFFER_SIZE), Norm = rt_n(0);
    prep(taps, n);
    RUN(0, "Fir.KerFirSeqBaseline" SUF, FIR_SEQ_BASE_FN(DelayLine, MyFir, BufferOut, taps, n, Norm));
    RUN(1, "Fir.KerFirSeq" SUF, FIR_SEQ_OPT_FN(DelayLine, MyFir, BufferOut, taps, n, Norm));
    KerFirPar_ArgT FirArgs = { .Coeffs = MyFir, .DelayLine = DelayLine, .Out = BufferOut,
                               .NCoeffs = taps, .NSamples = n, .Norm = Norm };
    RUN(2, "Fir.KerFirPar" SUF, FIR_PAR_FN(&FirArgs));
    return 0;
}
