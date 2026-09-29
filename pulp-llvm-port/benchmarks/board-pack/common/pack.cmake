# Shared CMake for the board-pack apps. A test's CMakeLists.txt does:
#
#   cmake_minimum_required(VERSION 3.19)
#   set(TARGET_NAME t1_b101_gcc_hwloop)
#   include($ENV{GAP_SDK_HOME}/utils/cmake/setup.cmake)
#   project(${TARGET_NAME} C ASM)
#   include(${CMAKE_CURRENT_SOURCE_DIR}/../common/pack.cmake)
#   add_executable(${TARGET_NAME} main.c ...)
#   pack_app(${TARGET_NAME})
#
# Options (cmake -D...):
#   PACK_PREBUILT_ELF=<file>  after linking, replace the freshly built ELF with <file>, so that
#                             the SDK's `run` target flashes/loads the prebuilt ELF instead
#                             (used for the ELFs built with our clang, which the laptop does
#                             not have). The local build still has to succeed first.

get_filename_component(PACK_COMMON "${CMAKE_CURRENT_LIST_DIR}" ABSOLUTE)

# pack_opt(<source> <options...>): per-file compile options. They come after the SDK's
# CMAKE_C_FLAGS (-Os ...) on the command line, so e.g. -O2 overrides the SDK's -Os.
macro(pack_opt SRC)
  set_source_files_properties(${SRC} PROPERTIES COMPILE_OPTIONS "${ARGN}")
endmacro()

macro(pack_app TARGET)
  target_sources(${TARGET} PRIVATE ${PACK_COMMON}/pack.c)
  target_include_directories(${TARGET} PRIVATE ${PACK_COMMON})
  if(PACK_PREBUILT_ELF)
    get_filename_component(_pack_elf "${PACK_PREBUILT_ELF}" ABSOLUTE)
    if(NOT EXISTS "${_pack_elf}")
      message(FATAL_ERROR "PACK_PREBUILT_ELF=${_pack_elf} does not exist")
    endif()
    add_custom_command(TARGET ${TARGET} POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy "${_pack_elf}" "$<TARGET_FILE:${TARGET}>"
      COMMENT "board-pack: replacing ${TARGET} with prebuilt ${_pack_elf}")
    message(STATUS "board-pack: the run target will use the prebuilt ELF ${_pack_elf}")
  endif()
  setupos(${TARGET})
endmacro()
