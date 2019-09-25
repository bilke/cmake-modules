# - Find NetCDF
# Find the native NetCDF includes and library

# TODO:
#       - Check for system netcdf
#       - Make CXX a component

# C
find_path(NETCDF_INCLUDES_C NAMES netcdf.h
    HINTS ${NETCDF_ROOT} PATH_SUFFIXES include)
find_library(NETCDF_LIBRARIES_C NAMES netcdf
    HINTS ${NETCDF_ROOT} PATH_SUFFIXES lib)

# CXX
find_path(NETCDF_INCLUDES_CXX NAMES netcdf
    HINTS ${NETCDF_CXX_ROOT} PATH_SUFFIXES include)
find_library(NETCDF_LIBRARIES_CXX NAMES netcdf_c++4 netcdf-cxx4
    HINTS ${NETCDF_CXX_ROOT} PATH_SUFFIXES lib)

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (NetCDF DEFAULT_MSG
    NETCDF_LIBRARIES_C
    NETCDF_LIBRARIES_CXX
    NETCDF_INCLUDES_C
    NETCDF_INCLUDES_CXX
)

