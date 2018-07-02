# this one is important
SET(CMAKE_SYSTEM_NAME Windows)
#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)

# specify the cross compiler
SET(PL_TOOLS_ROOT        C:/tools/pl-build-tools)
SET(GCC_ROOT             C:/tools/mingw32)
SET(CMAKE_C_COMPILER     ${GCC_ROOT}/bin/gcc.exe)
SET(CMAKE_CXX_COMPILER   ${GCC_ROOT}/bin/g++.exe)

# where is the target environment
SET(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${PL_TOOLS_ROOT})

# CMAKE_CXX_COMPILER_ARCHITECTURE_ID is set for MSVC but not mingw gcc. Some
# CMake modules (FindBoost, for example) use it to construct library pathnames;
# Set it explicitly.
SET(CMAKE_CXX_COMPILER_ARCHITECTURE_ID X86)
