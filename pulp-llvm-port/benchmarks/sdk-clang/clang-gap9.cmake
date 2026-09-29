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
# GAP_CLANG_COMPAT, GAP_CLANG_MARCH, GAP_CLANG_MPE, GAP_CLANG_GCC7COMPAT,
# GAP_CLANG_LENIENT from the environment at build time (see
# bin/riscv32-unknown-elf-clang).  With a current integration compiler use
# GAP_CLANG_MARCH=rv32imc_xgap9: no macro shim, native -mPE=N (F018), and no
# compat header needed (F016).
#
# Diagnostics (-Werror): the SDK compiles with -Wall -Wextra -Werror unless
# CONFIG_DISABLE_WERROR=y.  The wrapper, not this file, adds the flags that
# make clang stop the build exactly where GAP9 GCC 7.1.1 would, because the
# SDK passes its warning options per target and only the wrapper sees the
# final command line (the flags depend on whether -Werror is on it).  The
# single source of truth, with the reason for every flag, is the "Diagnostics"
# block of bin/riscv32-unknown-elf-clang; in short:
#   * -Wno-discarded-qualifiers -> -Wno-incompatible-pointer-types-discards-qualifiers
#     (clang's name for the SDK's own option);
#   * -Wall/-Wextra moved in front of explicit -Wno-X (GCC's precedence rule);
#   * without -Werror only: -Wno-error= for implicit-function-declaration,
#     implicit-int, int-conversion, incompatible-function-pointer-types,
#     return-mismatch (errors in clang 20, warnings in GCC 7);
#   * always: -Wno-typedef-redefinition, and -Wno-error= for unknown-attributes,
#     enum-conversion, compound-token-split-by-macro, self-assign,
#     header-guard, deprecated-non-prototype, implicit-const-int-float-conversion,
#     constant-conversion, pointer-bool-conversion, tautological-pointer-compare,
#     empty-body (clang warnings GCC 7 does not emit for the SDK's code);
#   * a call to a __builtin_* clang does not know always fails the compile
#     (stderr check, plus nm -u on the object for pragma-silenced cases);
#   * -ffp-contract=fast (GCC's default; owner decision D6/Q5).  Not added:
#     -fno-math-errno (GAP9 GCC keeps -fmath-errno, and so does clang).
# With them, clang-only warnings no longer need CONFIG_DISABLE_WERROR=y
# (GAP_CLANG_GCC7COMPAT=0 turns them off).  Deliberately NOT covered, so they
# still stop a -Werror build: real SDK bugs that GCC 7 misses (uninitialized
# uses in bsp/fs/read_fs/read_fs.c, bsp/fs/lfs/pi_lfs.c, bsp/ota/ota.c,
# bsp/ota/updater.c) and the int32_t = int (clang) vs long (GCC) printf
# mismatch in malloc_internal.c.  Apps using read_fs need an SDK fix or
# CONFIG_DISABLE_WERROR=y.

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
