# Test 5 (B113): pv.shuffle2.b/.h source order. GCC-only test (inline asm + GCC C).
cmake_minimum_required(VERSION 3.19)
set(TARGET_NAME "t5_shuffle2_order_b113")
include($ENV{GAP_SDK_HOME}/utils/cmake/setup.cmake)
project(${TARGET_NAME} C ASM)
include(${CMAKE_CURRENT_SOURCE_DIR}/../common/pack.cmake)
add_executable(${TARGET_NAME} main.c)
pack_opt(main.c -O2)
pack_app(${TARGET_NAME})
