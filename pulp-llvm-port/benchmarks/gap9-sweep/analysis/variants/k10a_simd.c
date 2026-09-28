/* Analysis variant of k10a (not SDK code): the last FFT layer written with v2s vector types to
 * model what SLP vectorisation into Xpulpv2 packed SIMD (GCC -O3: pv.add.h/pv.sub.h) gives. */
#include "at_api.h"
#define Radix2FFT_DIF_Scalar Radix2FFT_DIF_Scalar_orig
#include "k10a_fft_radix2_scalar.extract.c"
#undef Radix2FFT_DIF_Scalar
typedef short v2s_t __attribute__((vector_size(4)));
void Radix2FFT_DIF_Scalar(signed short *__restrict__ Data, signed short *__restrict__ Twiddles, int N_fft)
{
        int iLog2N  = gap_fl1(N_fft);
        int iCnt1, iCnt2, iCnt3, iQ, iL, iM, iA, iB;
        iL = 1; iM = N_fft / 2;
        for (iCnt1 = 0; iCnt1 < (iLog2N-1); iCnt1++) {
                iQ = 0;
                for (iCnt2 = 0; iCnt2 < iM; iCnt2++) {
                        short int Wr = Twiddles[2*iQ]; short int Wi = Twiddles[2*iQ+1];
                        iA = iCnt2;
                        for (iCnt3 = 0; iCnt3 < iL; iCnt3++) {
                                int Tmpr, Tmpi;
                                iB = iA + iM;
                                Tmpr = Data[2*iA  ] - Data[2*iB  ];
                                Tmpi = Data[2*iA+1] - Data[2*iB+1];
                                Data[2*iA  ] = (Data[2*iA  ] + Data[2*iB  ]) >> FFT2_SCALEDOWN;
                                Data[2*iA+1] = (Data[2*iA+1] + Data[2*iB+1]) >> FFT2_SCALEDOWN;
                                Data[2*iB  ] = (Tmpr*Wr - Tmpi*Wi)>>(15+FFT2_SCALEDOWN);
                                Data[2*iB+1] = (Tmpr*Wi + Tmpi*Wr)>>(15+FFT2_SCALEDOWN);
                                iA = iA + 2 * iM;
                        }
                        iQ += iL;
                }
                iL <<= 1; iM >>= 1;
        }
        v2s_t *D = (v2s_t *) Data;
        for (iCnt3 = 0; iCnt3 < (N_fft>>1); iCnt3++) {
                v2s_t a = D[2*iCnt3], b = D[2*iCnt3+1];
                D[2*iCnt3] = a + b; D[2*iCnt3+1] = a - b;
        }
}
