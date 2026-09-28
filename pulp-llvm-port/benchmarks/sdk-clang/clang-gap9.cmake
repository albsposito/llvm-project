# Make a GAP9 SDK CMake app build with our clang instead of GAP9 GCC.
#
# Use as an initial-cache script (NOT as CMAKE_TOOLCHAIN_FILE):
#
#   cmake -B build -C /path/to/sdk-clang/clang-gap9.cmake [-DCONFIG_...]
#
# Why -C: the SDK's setup.cmake runs before project() and its
# setupcrosscompile macro (utils/cmake/macros.cmake) does
#   find_program(GAP_RISCV_CC riscv32-unknown-elf-gcc)
#   set(CMAKE_C_COMPILER ${GAP_RISCV_CC}) ...
# find_program() keeps a cache entry that already exists, so pre-seeding the
# GAP_RISCV_* cache entries swaps the compiler without editing the SDK.  A
# CMAKE_TOOLCHAIN_FILE is only read inside project(), after the SDK has already
# chosen GCC.
#
# The wrapper reads GAP_CLANG_ROOT, GAP_CLANG_LINKER, GAP_CLANG_AS,
# GAP_CLANG_COMPAT, GAP_CLANG_LENIENT from the environment at build time
# (see bin/riscv32-unknown-elf-clang).

get_filename_component(_SDK_CLANG_DIR "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)

if(DEFINED ENV{GAP_CLANG_ROOT})
  set(_CLANG_BIN "$ENV{GAP_CLANG_ROOT}/bin")
else()
  set(_CLANG_BIN "${_SDK_CLANG_DIR}/snap/bin")
endif()

set(GAP_RISCV_CC      "${_SDK_CLANG_DIR}/bin/riscv32-unknown-elf-clang" CACHE FILEPATH "GAP9 C compiler (clang wrapper)")
set(GAP_RISCV_CXX     "${_SDK_CLANG_DIR}/bin/riscv32-unknown-elf-clang" CACHE FILEPATH "GAP9 C++ compiler (clang wrapper, C++ untested)")
set(GAP_RISCV_AR      "${_CLANG_BIN}/llvm-ar"      CACHE FILEPATH "")
set(GAP_RISCV_OBJDUMP "${_CLANG_BIN}/llvm-objdump" CACHE FILEPATH "")
set(GAP_RISCV_NM      "${_CLANG_BIN}/llvm-nm"      CACHE FILEPATH "")
set(GAP_RISCV_SIZE    "${_CLANG_BIN}/llvm-size"    CACHE FILEPATH "")
# The SDK never sets CMAKE_AR; CMake would look for "ar" next to the wrapper.
set(CMAKE_AR          "${_CLANG_BIN}/llvm-ar"      CACHE FILEPATH "")
set(CMAKE_RANLIB      "${_CLANG_BIN}/llvm-ranlib"  CACHE FILEPATH "")
# ccache would be picked up by setupcrosscompile; harmless, but keep builds
# comparable and avoid caching across compiler snapshots.
set(CCACHE_FOUND      "OFF"                        CACHE STRING "")
