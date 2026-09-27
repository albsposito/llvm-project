/* Kernel 11: int8 dot product with gap_sumdotp4 (DotProd pattern). Written for
 * this sweep; the SDK DotProd example is AutoTiler-generated. */
#include "at_api.h"
int dotprod_i8(const v4s *__restrict__ A, const v4s *__restrict__ B, int N)
{
	int Acc = 0;
	for (int i = 0; i < N; i++) Acc = gap_sumdotp4(A[i], B[i], Acc);
	return Acc;
}
