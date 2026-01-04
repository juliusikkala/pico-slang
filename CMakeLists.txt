cmake_minimum_required(VERSION 3.13)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

option(OVERCLOCK "Overclock & overvolt the microcontroller to 532 MHz/1.60 V" OFF)

# pico_sdk_import.cmake is a single file copied from this SDK
# note: this must happen before project()
include(cmake/pico_sdk_import.cmake)

project(PicoSlang LANGUAGES C CXX Slang)

# initialize the Raspberry Pi Pico SDK
pico_sdk_init()

file(GLOB shader_sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/shaders/*.glsl")

set(i 0)
set(shader_binaries)
set(shader_runners "")
add_custom_target(shaders_target)
foreach(source ${shader_sources})
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/shader${i}.o
        COMMAND ${CMAKE_Slang_COMPILER} -target shader-object-code -emit-cpu-via-llvm -fp-mode fast -DPICOTOY_RUNNER_INCLUDE="${source}" -DPICOTOY_RUNNER_MAIN=runner${i}Main -llvm-target-triple thumb-v8-eabi -llvm-cpu cortex-m33 -llvm-features armv8-m.main,fp-armv8,dsp -Xllvm... -function-sections -data-sections -float-abi=soft --stack-size-section -X. -allow-glsl -O3 -g0 ${CMAKE_CURRENT_SOURCE_DIR}/runner.slang -o ${CMAKE_CURRENT_BINARY_DIR}/shader${i}.o
        COMMAND_EXPAND_LISTS
        MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/runner.slang
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/runner.slang ${file}
        IMPLICIT_DEPENDS Slang ${CMAKE_CURRENT_SOURCE_DIR}/runner.slang ${file}
        VERBATIM
    )
    add_custom_target(shader${i}_target DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/shader${i}.o)
    list(APPEND shader_binaries ${CMAKE_CURRENT_BINARY_DIR}/shader${i}.o)
    add_dependencies(shaders_target shader${i}_target)
    string(APPEND shader_runners " X(${i})")
    math(EXPR i "${i} + 1")
endforeach()

set(shader_count ${i})

add_library(picotoy-slang STATIC picotoy.slang st7789.slang)
target_compile_options(picotoy-slang PRIVATE -DSHADER_COUNT=${shader_count} -DSHADER_RUNNERS=${shader_runners})

if(OVERCLOCK)
    target_compile_options(picotoy-slang PRIVATE -DOVERCLOCK)
endif()

add_executable(picotoy export_inline_functions.c)

add_dependencies(picotoy shaders_target)

# Add pico_stdlib library which aggregates commonly used features
target_link_libraries(picotoy hardware_spi pico_stdlib pico_multicore pico_sync pico_cyw43_arch_none ${shader_binaries} picotoy-slang)

pico_enable_stdio_usb(picotoy 1)

# create map/bin/hex/uf2 file in addition to ELF.
pico_add_extra_outputs(picotoy)
