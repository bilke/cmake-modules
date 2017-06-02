# Find Intel Math Karnel Library (MKL)
#
# Options
# - MKL_DIR      MKL root directory
# - MKL_OPENMP   use OpenMP threading
#
# Results
# - MKL_INCLUDE_DIR
# - MKL_LIBRARIES
#
# Copyright (c) 2012-2017, OpenGeoSys Community (http://www.opengeosys.org)
# Distributed under a Modified BSD License.
# See accompanying file LICENSE.txt or
# http://www.opengeosys.org/project/license

# Lookg for MKL root dir
if (NOT MKL_DIR)
    find_path(MKL_DIR
        include/mkl.h
        PATHS
        $ENV{MKL_DIR}
        /opt/intel/mkl/
        )
endif()
message(STATUS "MKL_DIR : ${MKL_DIR}")

# Find MKL include dir
find_path(MKL_INCLUDE_DIR NAMES mkl.h
    PATHS
    ${MKL_DIR}/include
)

# Set the directory path storing MKL libraries
if (NOT MKL_LIB_DIR)
    if(APPLE)
        set(MKL_LIB_DIR ${MKL_DIR}/lib)
    else()
        if (${CMAKE_HOST_SYSTEM_PROCESSOR} STREQUAL "x86_64")
            set(MKL_LIB_DIR ${MKL_DIR}/lib/intel64)
        else()
            set(MKL_LIB_DIR ${MKL_DIR}/lib/ia32)
        endif()
    endif()
endif()

# Find MKL libs
find_library(MKL_LIB_CORE mkl_core PATHS ${MKL_LIB_DIR})

if (${CMAKE_HOST_SYSTEM_PROCESSOR} STREQUAL "x86_64")
    set(MKL_INTEL_LIB_NAME mkl_intel_lp64)
else()
    set(MKL_INTEL_LIB_NAME mkl_intel)
endif()

find_library(MKL_LIB_INTEL ${MKL_INTEL_LIB_NAME} PATHS ${MKL_LIB_DIR})

if(OPENMP_FOUND)
    set(MKL_THREAD_LIB_NAME "mkl_gnu_thread")
else()
    set(MKL_THREAD_LIB_NAME "mkl_sequential")
endif()
find_library(MKL_LIB_THREAD ${MKL_THREAD_LIB_NAME} PATHS ${MKL_LIB_DIR})


set(MKL_LIBRARIES "${MKL_LIB_INTEL}" "${MKL_LIB_THREAD}" "${MKL_LIB_CORE}")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MKL DEFAULT_MSG MKL_INCLUDE_DIR MKL_LIBRARIES)
mark_as_advanced(MKL_INCLUDE_DIR MKL_LIBRARIES)
