# ########################################################################
# Copyright (C) 2025 None, get fucked. Coyrighting a cmake file, wtf?


set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR AMD64)
set(LLVM_TARGET_ARCH "X86" CACHE STRING "" FORCE)

# Force using MSVC-style linking
set(CMAKE_LINKER "lld-link" CACHE STRING "")
set(CMAKE_C_COMPILER_TARGET "x86_64-pc-windows-msvc")
set(CMAKE_CXX_COMPILER_TARGET "x86_64-pc-windows-msvc")

# Set exact VS2022 and Windows Kit paths
set(VS_PATH "C:/vs22/VC/Tools/MSVC/14.43.34618")
set(WIN_KIT_PATH "C:/win-kit/Lib/10.0.26085.0/ucrt/x64")

# Set CRT paths
set(MSVC_CRT_PATH "${VS_PATH}/lib/x64")
set(WIN_KIT_CRT_PATH "${WIN_KIT_PATH}")

# Add MSVC CRT libraries
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} \
    ${MSVC_CRT_PATH}/msvcrtd.lib \
    ${WIN_KIT_CRT_PATH}/ucrtd.lib \
    ${MSVC_CRT_PATH}/vcruntimed.lib")

#add_definitions(
#    -D_DLL 
#    -D_MT
#    -D_CRT_SECURE_NO_WARNINGS
#)

#string(REPLACE "-Wl,--gc-sections" "-dead_strip" CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")

if (DEFINED ENV{HIP_PATH})
  file(TO_CMAKE_PATH "$ENV{HIP_PATH}" HIP_DIR)
  set(rocm_bin "${HIP_DIR}/bin")
elseif (DEFINED ENV{HIP_DIR})
  file(TO_CMAKE_PATH "$ENV{HIP_DIR}" HIP_DIR)
  set(rocm_bin "${HIP_DIR}/bin")
else()
  set(HIP_DIR "c:/Progra~1/AMD/ROCm/6.2")
  set(rocm_bin "c:/Progra~1/AMD/ROCm/6.2/bin")
endif()

set(CMAKE_CXX_COMPILER "${rocm_bin}/clang++.exe")
set(CMAKE_C_COMPILER "${rocm_bin}/clang.exe")
#set(CMAKE_CXX_COMPILER_TARGET x86_64-pc-windows-msvc)

if (NOT python)
  set(python "python") # take default for windows
endif()

# our usage flags

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DWIN32 -DWIN32_LEAN_AND_MEAN -DNOMINMAX -D_CRT_SECURE_NO_WARNINGS -D_SILENCE_EXPERIMENTAL_FILESYSTEM_DEPRECATION_WARNING")

# flags for clang direct use

# -Wno-ignored-attributes to avoid warning: __declspec attribute 'dllexport' is not supported [-Wignored-attributes] which is used by msvc compiler
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-ignored-attributes")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DHIP_CLANG_HCC_COMPAT_MODE=1")

# args also in hipcc.bat
#set(CMAKE_CXX_FLAGS_INIT "-fms-compatibility-version=19.20")
#set(CMAKE_C_FLAGS_INIT "-fms-compatibility-version=19.20")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_INIT} -fms-extensions -D__HIP_ROCclr__=1 -D__HIP_PLATFORM_AMD__=1 ")
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS_INIT}")

# Explicit MSVC runtime linking (DLL version)
#set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL$<$<CONFIG:Debug>:Debug>")

# Clang-specific CRT controls
#add_compile_options(
#  $<$<COMPILE_LANGUAGE:C,CXX>:-Xclang --dependent-lib=msvcrt>
#  $<$<CONFIG:Debug>:-Xclang --dependent-lib=msvcrtd>
#)

if (DEFINED ENV{OPENBLAS_DIR})
  file(TO_CMAKE_PATH "$ENV{OPENBLAS_DIR}" OPENBLAS_DIR)
else()
  set(OPENBLAS_DIR "C:/vcpkg/packages/openblas_x64-windows")
endif()

if (DEFINED ENV{VCPKG_PATH})
  file(TO_CMAKE_PATH "$ENV{VCPKG_PATH}" VCPKG_PATH)
else()
  set(VCPKG_PATH "C:/vcpkg")
endif()
include("${VCPKG_PATH}/scripts/buildsystems/vcpkg.cmake")

set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
set(CMAKE_STATIC_LIBRARY_PREFIX "static_")
set(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")
set(CMAKE_SHARED_LIBRARY_PREFIX "")

set(BUILD_FORTRAN_CLIENTS OFF)