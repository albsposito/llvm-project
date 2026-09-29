# Runner for prebuilt ELFs: cmake -B build -DPACK_PREBUILT_ELF=<elf> ...; cmake --build build --target run
cmake_minimum_required(VERSION 3.19)
set(TARGET_NAME "pack_runner")
include($ENV{GAP_SDK_HOME}/utils/cmake/setup.cmake)
project(${TARGET_NAME} C ASM)
include(${CMAKE_CURRENT_SOURCE_DIR}/../pack.cmake)
add_executable(${TARGET_NAME} main.c)
pack_app(${TARGET_NAME})
