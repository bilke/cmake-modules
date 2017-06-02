# - Find GSL
# Find the native GSL includes and library
#
#  GSL_INCLUDES    - where to find gsl/gsl_*.h, etc.
#  GSL_LIBRARIES   - List of libraries when using GSL.
#  GSL_FOUND       - True if GSL found.


if (GSL_INCLUDES)
  # Already in cache, be silent
  set (GSL_FIND_QUIETLY TRUE)
endif (GSL_INCLUDES)

find_path (GSL_INCLUDES gsl/gsl_math.h)

find_library (GSL_LIB NAMES gsl)

set (GSL_CBLAS_LIB "" CACHE FILEPATH "If your program fails to link
(usually because GSL is not automatically linking a CBLAS and no other
component of your project provides a CBLAS) then you may need to point
this variable to a valid CBLAS.  Usually GSL is distributed with
libgslcblas.{a,so} (next to GSL_LIB) which you may use if an optimized
CBLAS is unavailable.")

set (GSL_LIBRARIES "${GSL_LIB}" "${GSL_CBLAS_LIB}")

# handle the QUIETLY and REQUIRED arguments and set GSL_FOUND to TRUE if
# all listed variables are TRUE
include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (GSL DEFAULT_MSG GSL_LIBRARIES GSL_INCLUDES)

mark_as_advanced (GSL_LIB GSL_CBLAS_LIB GSL_INCLUDES)
