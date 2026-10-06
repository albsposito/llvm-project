# Test 8 (B151): sign of the packed fp16 instructions vfmre.h / vfmre.ah. Raw-instruction
# probes (.word and mnemonic) plus the compiled C pattern. GAP9 GCC builds it; no clang needed.
cmake_minimum_required(VERSION 3.19)
set(TARGET_NAME "t8_vfmre_sign_b151")
include($ENV{GAP_SDK_HOME}/utils/cmake/setup.cmake)
project(${TARGET_NAME} C ASM)
include(${CMAKE_CURRENT_SOURCE_DIR}/../common/pack.cmake)
add_executable(${TARGET_NAME} main.c)
pack_opt(main.c -O2)
pack_app(${TARGET_NAME})
