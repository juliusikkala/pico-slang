set(CMAKE_Slang_FLAGS_DEBUG_INIT "-O0 -g3")
set(CMAKE_Slang_FLAGS_RELEASE_INIT "-O3 -g0")
set(CMAKE_Slang_FLAGS_RELWITHDEBINFO_INIT "-O2 -g2")

set(CMAKE_INCLUDE_FLAG_Slang "-I")

cmake_initialize_per_config_variable(CMAKE_Slang_FLAGS "Flags used by the Slang compiler")

set(CMAKE_Slang_DEPFILE_FORMAT gcc)
set(CMAKE_Slang_DEPENDS_USE_COMPILER TRUE)
set(CMAKE_DEPFILE_FLAGS_Slang "-depfile <DEP_FILE>")

set(CMAKE_Slang_COMPILE_OBJECT
    "<CMAKE_Slang_COMPILER> <DEFINES> <INCLUDES> <FLAGS> <SOURCE> -o <OBJECT>"
)

set(CMAKE_Slang_OUTPUT_EXTENSION "-module")

set(CMAKE_Slang_CREATE_STATIC_LIBRARY
    "<CMAKE_Slang_COMPILER> -target host-object-code -emit-cpu-via-llvm -llvm-target-triple thumb-v8-eabi -llvm-cpu cortex-m33 -llvm-features armv8-m.main,fp-armv8,dsp -Xllvm... -function-sections -data-sections -float-abi=soft --stack-size-section -X. <CMAKE_Slang_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET>"
)

set(CMAKE_Slang_LINKER_PREFERENCE Slang) 
set(CMAKE_Slang_INFORMATION_LOADED 1)
