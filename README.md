Slang on Raspberry Pico 2 W
===========================

This is a proof-of-concept of compiling and running [Slang](https://github.com/shader-slang/slang)
and GLSL code on a microcontroller. It is able to run Shadertoy shaders on the
microcontroller! Although, performance is measured in minutes per frame.

| ![photo of a small LCD showing an alien landscape](images/a_dead_planet_of_silicon_dreams.jpg) |
| --- |
| The program running ["A Dead Planet of Silicon Dreams"](https://www.shadertoy.com/view/WfGfzK) by mrange |

**NOTE** that none of the code in the `shaders` folder is mine; they're just
example shaders from Shadertoy that work with this program! Their respective
licenses are found at the beginning of the shader files. You can add more
shaders in that directory and they will automatically be compiled into the
program.

## What's special about this?

Slang (in its current form) is a shading language. This means that it's usually
used to run code on GPUs. The "special" part of this project is running that GPU
code on something it's absolutely not meant to be run on: an underpowered
microcontroller, without any operating system or interpreter!

`slangc`, the Slang compiler, also supports compiling GLSL and HLSL code; this
means that in addition to Slang, it is possible to compile GLSL and HLSL into
CPU programs on bare metal now.

This is not a simple transpiler hack - the Slang/GLSL code is never compiled
into C or C++ or any other high-level language. Instead, the new LLVM emitter
of `slangc` is used to directly emit object code for the microcontroller.

As of writing, this doesn't yet work on the upstream Slang compiler; it requires
PRs [9491](https://github.com/shader-slang/slang/pull/9491),
[9492](https://github.com/shader-slang/slang/pull/9492), and
[9493](https://github.com/shader-slang/slang/pull/9493).

## Build

To test this out, create a new branch from the `master` branch of Slang and
locally merge the PRs listed above.

This has only been tested on a single setup:
* Host: OpenSUSE Tumbleweed, x86\_64
* Microcontroller: Raspberry Pico 2 W

The GCC 15 toolchain is used for pico-sdk, and the Slang compiler is using
LLVM 21. `slangc` must be in `PATH` and `PICO_SDK_PATH` must be visible for the
build. Other than that, there shouldn't be anything special.

The [`pico.slang`](pico.slang) bindings to pico-sdk have been generated with
[this binding generator](https://github.com/juliusikkala/slang-cpu-utils/tree/llvm/bindgen-llvm).
It has been generated using flags that are specifically correct for the
Pico 2 W, so this project only works on that device currently.

## Hardware

* Raspberry Pi Pico 2 W
    - Using the Cortex M33 CPU, no RISC-V support yet
* [Adafruit 2.0" 240x320 IPS TFT LCD](https://www.adafruit.com/product/4311)
    - Display SPI pins connected to Pico's SPI0
    - D/C in GPIO 21, RESET in GPIO 20
* Two push buttons to cycle between shaders
    - They connect GPIO 14 & 15 to ground when connected
    - Internal pull-up resistors are used, you don't need external resistors
