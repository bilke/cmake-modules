# - Try to find LIS
# Once done, this will define
#
#  LIS_FOUND
#  LIS_INCLUDE_DIRS
#  LIS_LIBRARIES
#
#  Environment variable LIS_ROOT_DIR can be set to give hints

find_path( LIS_INCLUDE_DIR lis.h
    PATHS ENV LIS_ROOT_DIR
    PATH_SUFFIXES include
)

find_library(LIS_LIBRARY lis
    PATHS ENV LIS_ROOT_DIR
    PATH_SUFFIXES lib
)

set(LIS_LIBRARIES ${LIS_LIBRARY})

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIS DEFAULT_MSG LIS_LIBRARY LIS_INCLUDE_DIR)

