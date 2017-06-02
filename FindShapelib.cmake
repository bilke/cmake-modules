find_path(Shapelib_INCLUDE_DIR NAMES shapefil.h)

if(MSVC)
    set(Shapelib_LIBNAME shapelib)
else()
    set(Shapelib_LIBNAME shp)
endif()

find_library(Shapelib_LIBRARY NAMES ${Shapelib_LIBNAME})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Shapelib
    FOUND_VAR Shapelib_FOUND
    REQUIRED_VARS Shapelib_INCLUDE_DIR Shapelib_LIBRARY
)

set(Shapelib_INCLUDE_DIRS ${Shapelib_INCLUDE_DIR})
set(Shapelib_LIBRARIES ${Shapelib_LIBRARY})

mark_as_advanced(Shapelib_INCLUDE_DIR Shapelib_LIBRARY)
