/* Analysis variant of k02 (not SDK code): KerFirSeqf32 rewritten by hand to model one compiler
 * transformation; VARIANT=pcout. pc = carry In1[4j+4] (== In2[4j+3]) into the next iteration
 * (GCC -O3 predictive commoning); out = Out written through a post-incremented pointer. */
#include "at_api.h"
#define KerFirSeqf32 KerFirSeqf32_orig
#include "FilteringFunctions/FirBasicKernelsf32.c"
#undef KerFirSeqf32
void KerFirSeqf32(float *DelayLine, float *Coeffs, float *Out, int NCoeffs, int NSamples)
{
        int i,j; float *O = Out;
        for (i=0; i<(NSamples/2); i++) {
                int Acc1 = 0, Acc2 = 0;
                float *In1 = &DelayLine[2*i];
#if 1
                float x0 = In1[0];
                for (j=0; j<(NCoeffs/4); j++) {
                        float x1 = In1[4*j+1], x2 = In1[4*j+2], x3 = In1[4*j+3], x4 = In1[4*j+4];
                        Acc1 += x0 * Coeffs[4*j+0]; Acc1 += x1 * Coeffs[4*j+1];
                        Acc1 += x2 * Coeffs[4*j+2]; Acc1 += x3 * Coeffs[4*j+3];
                        Acc2 += x1 * Coeffs[4*j+0]; Acc2 += x2 * Coeffs[4*j+1];
                        Acc2 += x3 * Coeffs[4*j+2]; Acc2 += x4 * Coeffs[4*j+3];
                        x0 = x4;
                }
#else
                float *In2 = &DelayLine[2*i+1];
                for (j=0; j<(NCoeffs/4); j++) {
                        Acc1 += In1[4*j+0] * Coeffs[4*j+0]; Acc1 += In1[4*j+1] * Coeffs[4*j+1];
                        Acc1 += In1[4*j+2] * Coeffs[4*j+2]; Acc1 += In1[4*j+3] * Coeffs[4*j+3];
                        Acc2 += In2[4*j+0] * Coeffs[4*j+0]; Acc2 += In2[4*j+1] * Coeffs[4*j+1];
                        Acc2 += In2[4*j+2] * Coeffs[4*j+2]; Acc2 += In2[4*j+3] * Coeffs[4*j+3];
                }
#endif
                for (j=(NCoeffs/4)*4; j<NCoeffs; j++) {
                        Acc1 += DelayLine[2*i  + j] * Coeffs[j];
                        Acc2 += DelayLine[2*i+1+ j] * Coeffs[j];
                }
#if 1
                *O++ = Acc1; *O++ = Acc2;
#else
                Out[2*i] = Acc1; Out[2*i+1] = Acc2;
#endif
        }
        if (NSamples & 0x1) {
                int Acc1 = 0;
                for (j=0; j<NCoeffs; j++) Acc1 += DelayLine[NSamples-1 + j] * Coeffs[j];
                Out[NSamples-1] = Acc1;
        }
        for (i=0; i<(NCoeffs-1); i++) DelayLine[i] = DelayLine[NSamples + i];
}
