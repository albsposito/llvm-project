# Test 4 (B114): pv.shuffle.sci.h immediate layout. GCC-only test (inline asm + GCC C).
cmake_minimum_required(VERSION 3.19)
set(TARGET_NAME "t4_shuffle_sci_h_b114")
include($ENV{GAP_SDK_HOME}/utils/cmake/setup.cmake)
project(${TARGET_NAME} C ASM)
include(${CMAKE_CURRENT_SOURCE_DIR}/../common/pack.cmake)
add_executable(${TARGET_NAME} main.c)
pack_opt(main.c -O2)
pack_app(${TARGET_NAME})
