# Test 6: our clang vs GAP9 GCC on 12 real kernels. The PMSIS app is built by GAP9 GCC; the
# kernel library is built by the compiler under test.
#   -DPACK_KERNELS=gcc-O2 (default) | gcc-O3   build the library here with GAP9 GCC
#   -DPACK_KERNELS=clang-O2 | clang-O3         use the prebuilt clang library in
#                                              ../prebuilt/kernels/<name>/libpack_kernels.a,
#                                              or rebuild it with -DPACK_CLANG=<clang binary>
#   -DPACK_KERNELS_LIB=<file.a>                use any prebuilt library
cmake_minimum_required(VERSION 3.19)
set(TARGET_NAME "t6_kernels_clang_vs_gcc")
include($ENV{GAP_SDK_HOME}/utils/cmake/setup.cmake)
project(${TARGET_NAME} C ASM)
include(${CMAKE_CURRENT_SOURCE_DIR}/../common/pack.cmake)
add_executable(${TARGET_NAME} main.c)

if(NOT PACK_KERNELS)
  set(PACK_KERNELS gcc-O2)
endif()
string(REGEX MATCH "^(gcc|clang)-(O2|O3)$" _ok "${PACK_KERNELS}")
if(NOT _ok AND NOT PACK_KERNELS_LIB)
  message(FATAL_ERROR "PACK_KERNELS must be gcc-O2, gcc-O3, clang-O2 or clang-O3")
endif()
set(_kind ${CMAKE_MATCH_1})
set(_opt ${CMAKE_MATCH_2})
set(_kdir ${CMAKE_CURRENT_SOURCE_DIR}/kernels)
file(GLOB _ksrc ${_kdir}/src/*.c ${_kdir}/drivers/*.c ${_kdir}/gen/*.c ${_kdir}/*.h ${_kdir}/shim/*.h)

if(PACK_KERNELS_LIB)
  set(_klib ${PACK_KERNELS_LIB})
elseif(_kind STREQUAL "gcc" OR PACK_CLANG)
  set(_kout ${CMAKE_BINARY_DIR}/klib-${PACK_KERNELS})
  set(_klib ${_kout}/libpack_kernels.a)
  if(_kind STREQUAL "gcc")
    set(_kcc "")
  else()
    set(_kcc ${PACK_CLANG})
  endif()
  add_custom_command(OUTPUT ${_klib}
    COMMAND ${_kdir}/build_kernels.sh ${_kind} ${_opt} ${_kout} ${_kcc}
    DEPENDS ${_ksrc} ${_kdir}/build_kernels.sh
    COMMENT "board-pack: building the kernel library (${PACK_KERNELS})")
  add_custom_target(pack_kernels_lib DEPENDS ${_klib})
  add_dependencies(${TARGET_NAME} pack_kernels_lib)
else()
  set(_klib ${CMAKE_CURRENT_SOURCE_DIR}/../prebuilt/kernels/${PACK_KERNELS}/libpack_kernels.a)
endif()
message(STATUS "board-pack: kernel library ${_klib}")
target_link_libraries(${TARGET_NAME} PRIVATE ${_klib})
pack_app(${TARGET_NAME})
