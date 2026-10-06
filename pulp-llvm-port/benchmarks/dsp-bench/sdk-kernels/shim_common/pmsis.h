/* Stand-in for pmsis.h, only for the DftSimple app's generated TestData.h/.c (which include
 * "pmsis.h" for the PI_L2 section attribute). No PMSIS is linked in this benchmark. */
#pragma once
#include "at_api.h"
#ifndef PI_L2
#define PI_L2
#endif
