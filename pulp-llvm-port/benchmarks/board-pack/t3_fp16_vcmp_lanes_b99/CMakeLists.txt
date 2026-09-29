# Test 3 (Q2/B99): packed fp16 compare lane values. GCC-only test (inline asm + GCC C).
cmake_minimum_required(VERSION 3.19)
set(TARGET_NAME "t3_fp16_vcmp_lanes_b99")
include($ENV{GAP_SDK_HOME}/utils/cmake/setup.cmake)
project(${TARGET_NAME} C ASM)
include(${CMAKE_CURRENT_SOURCE_DIR}/../common/pack.cmake)
add_executable(${TARGET_NAME} main.c)
pack_opt(main.c -O2)
pack_app(${TARGET_NAME})
