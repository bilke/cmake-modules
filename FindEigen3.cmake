# - Try to find Eigen3 lib
#
# This module supports requiring a minimum version, e.g. you can do
#   find_package(Eigen3 3.1.2)
# to require version 3.1.2 or newer of Eigen3.
#
#  EIGEN3_ROOT - Set as a environment variable to hint to eigen install directory
#
# Once done this will define
#
#  EIGEN3_FOUND - system has eigen lib with correct version
#  EIGEN3_INCLUDE_DIR - the eigen include directory
#  EIGEN3_VERSION - eigen version

# Copyright (c) 2006, 2007 Montel Laurent, <montel@kde.org>
# Copyright (c) 2008, 2009 Gael Guennebaud, <g.gael@free.fr>
# Copyright (c) 2009 Benoit Jacob <jacob.benoit.1@gmail.com>
# Redistribution and use is allowed according to the terms of the 2-clause BSD license.

macro(_eigen3_check_version)
  file(READ "${EIGEN3_INCLUDE_DIR}/Eigen/src/Core/util/Macros.h" _eigen3_version_header)

  string(REGEX MATCH "define[ \t]+EIGEN_WORLD_VERSION[ \t]+([0-9]+)" _eigen3_world_version_match "${_eigen3_version_header}")
  set(EIGEN3_WORLD_VERSION "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+EIGEN_MAJOR_VERSION[ \t]+([0-9]+)" _eigen3_major_version_match "${_eigen3_version_header}")
  set(EIGEN3_MAJOR_VERSION "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+EIGEN_MINOR_VERSION[ \t]+([0-9]+)" _eigen3_minor_version_match "${_eigen3_version_header}")
  set(EIGEN3_MINOR_VERSION "${CMAKE_MATCH_1}")

  set(EIGEN3_VERSION ${EIGEN3_WORLD_VERSION}.${EIGEN3_MAJOR_VERSION}.${EIGEN3_MINOR_VERSION})
  if(${EIGEN3_VERSION} VERSION_LESS ${Eigen3_FIND_VERSION})
    set(EIGEN3_VERSION_OK FALSE)
  else()
    set(EIGEN3_VERSION_OK TRUE)
  endif()
endmacro()

if (DEFINED ENV{EIGEN3_ROOT})
    set(ADDITIONAL_SEARCH_PATHS "$ENV{EIGEN3_ROOT}/include")
endif()
if (DEFINED EIGEN3_ROOT)
    list(APPEND ADDITIONAL_SEARCH_PATHS "${EIGEN3_ROOT}/include")
endif()

find_path(EIGEN3_INCLUDE_DIR NAMES signature_of_eigen3_matrix_library
  PATHS ${ADDITIONAL_SEARCH_PATHS}
  PATH_SUFFIXES eigen3 eigen
)

if(EIGEN3_INCLUDE_DIR)
  _eigen3_check_version()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Eigen3
  REQUIRED_VARS EIGEN3_INCLUDE_DIR EIGEN3_VERSION_OK
  VERSION_VAR EIGEN3_VERSION
)

mark_as_advanced(EIGEN3_INCLUDE_DIR)

