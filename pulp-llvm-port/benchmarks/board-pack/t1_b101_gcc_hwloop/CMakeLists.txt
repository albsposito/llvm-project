# Test 1 (B101): GAP9 GCC hardware-loop count bug. GCC-only test (no clang involved).
cmake_minimum_required(VERSION 3.19)
set(TARGET_NAME "t1_b101_gcc_hwloop")
include($ENV{GAP_SDK_HOME}/utils/cmake/setup.cmake)
project(${TARGET_NAME} C ASM)
include(${CMAKE_CURRENT_SOURCE_DIR}/../common/pack.cmake)
add_executable(${TARGET_NAME} main.c b101_Os.c b101_O2.c b101_O2_nohwloop.c b101_O3.c b101_O3_nohwloop.c)
# The SDK compiles with -Os; these per-file options come after it and override it.
pack_opt(b101_O2.c -O2)
pack_opt(b101_O2_nohwloop.c -O2 -mnohwloop)
pack_opt(b101_O3.c -O3)
pack_opt(b101_O3_nohwloop.c -O3 -mnohwloop)
pack_app(${TARGET_NAME})
