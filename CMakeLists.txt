cmake_minimum_required(VERSION 3.13)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# pico_sdk_import.cmake is a single file copied from this SDK
# note: this must happen before project()
include(cmake/pico_sdk_import.cmake)

project(PicoSlang LANGUAGES C CXX Slang)

# initialize the Raspberry Pi Pico SDK
pico_sdk_init()

add_library(picotoy-slang STATIC picotoy.slang st7789.slang)

add_executable(picotoy)

# Add pico_stdlib library which aggregates commonly used features
target_link_libraries(picotoy picotoy-slang pico_stdlib pico_cyw43_arch_none)

pico_enable_stdio_usb(picotoy 1)

# create map/bin/hex/uf2 file in addition to ELF.
pico_add_extra_outputs(picotoy)
