# Test 7c (B107): cluster core count. Built entirely with GCC or entirely with our clang
# (see ../build_clang_app.sh).
cmake_minimum_required(VERSION 3.19)
set(TARGET_NAME "t7_corecount")
include($ENV{GAP_SDK_HOME}/utils/cmake/setup.cmake)
project(${TARGET_NAME} C ASM)
include(${CMAKE_CURRENT_SOURCE_DIR}/../../common/pack.cmake)
add_executable(${TARGET_NAME} main.c)
pack_app(${TARGET_NAME})
