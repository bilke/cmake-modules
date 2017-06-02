# Tries to find Sundials CVODE.
#
# This module will define the following variables:
#  CVODE_INCLUDE_DIRS - Location of the CVODE includes
#  CVODE_FOUND - true if CVODE was found on the system
#  CVODE_LIBRARIES - Required libraries for all requested components
#
# This module accepts the following environment or CMake vars
#  CVODE_ROOT - Install location to search for

include(FindPackageHandleStandardArgs)

if(NOT "$ENV{CVODE_ROOT}" STREQUAL "" OR NOT "${CVODE_ROOT}" STREQUAL "")
    list(APPEND CMAKE_INCLUDE_PATH "$ENV{CVODE_ROOT}" "${CVODE_ROOT}")
    list(APPEND CMAKE_LIBRARY_PATH "$ENV{CVODE_ROOT}" "${CVODE_ROOT}")
endif()

find_path(CVODE_INCLUDE_DIRS sundials_types.h
    ENV CVODE_ROOT
    PATH_SUFFIXES include include/sundials
)

find_library(CVODE_LIBRARY
    NAMES sundials_cvode
    ENV CVODE_ROOT
    PATH_SUFFIXES lib Lib
)

find_library(CVODE_NVECSERIAL
    NAMES sundials_nvecserial
    ENV CVODE_ROOT
    PATH_SUFFIXES lib Lib
)

find_library(CVODE_KLU klu)

find_package_handle_standard_args(CVODE DEFAULT_MSG
    CVODE_LIBRARY
    CVODE_NVECSERIAL
    CVODE_INCLUDE_DIRS
)

if(CVODE_FOUND)
    set(CVODE_LIBRARIES
        ${CVODE_LIBRARY} ${CVODE_NVECSERIAL} ${CVODE_KLU}
        CACHE INTERNAL "")
endif()

mark_as_advanced(CVODE_INCLUDE_DIRS CVODE_LIBRARY CVODE_NVECSERIAL)
