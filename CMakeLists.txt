cmake_minimum_required(VERSION 3.13)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# pico_sdk_import.cmake is a single file copied from this SDK
# note: this must happen before project()
include(cmake/pico_sdk_import.cmake)

project(PicoSlang LANGUAGES C CXX Slang)

# initialize the Raspberry Pi Pico SDK
pico_sdk_init()

add_library(picotoy-slang STATIC picotoy.slang st7789.slang)

add_executable(picotoy export_inline_functions.c)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/shader.o
    COMMAND ${CMAKE_Slang_COMPILER} -target shader-object-code -emit-cpu-via-llvm -llvm-target-triple thumb-v8-eabi -llvm-cpu cortex-m33 -llvm-features armv8-m.main,fp-armv8,dsp -Xllvm... -function-sections -data-sections -float-abi=soft --stack-size-section -X. -allow-glsl -O2 ${CMAKE_CURRENT_SOURCE_DIR}/runner.slang -o ${CMAKE_CURRENT_BINARY_DIR}/shader.o
    COMMAND_EXPAND_LISTS
    MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/runner.slang
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/runner.slang
    IMPLICIT_DEPENDS Slang ${CMAKE_CURRENT_SOURCE_DIR}/runner.slang
    VERBATIM
)

add_custom_target(shader_target DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/shader.o)
add_dependencies(picotoy shader_target)

# Add pico_stdlib library which aggregates commonly used features
target_link_libraries(picotoy hardware_spi pico_stdlib pico_cyw43_arch_none ${CMAKE_CURRENT_BINARY_DIR}/shader.o picotoy-slang)

pico_enable_stdio_usb(picotoy 1)

# create map/bin/hex/uf2 file in addition to ELF.
pico_add_extra_outputs(picotoy)
