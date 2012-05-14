# DisableCompilerFlag.cmake
#
# 2012-05-14 Lars Bilke
#
# Removes the given FLAG from the compiler flags in the given CONFIGURATION.
# The Configuration must be uppercased.
#
# Usage:
# 
#   include(DisableCompilerFlag)
#   if (MSVC)
#     DisableCompilerFlag(DEBUG /RTC1)
#   endif ()

macro(DisableCompilerFlag CONFIGURATION FLAG)
	if(CMAKE_CXX_FLAGS_${CONFIGURATION} MATCHES "${FLAG}")
		string(REPLACE "${FLAG}" " " CMAKE_CXX_FLAGS_${CONFIGURATION} "${CMAKE_CXX_FLAGS_${CONFIGURATION}}")
		# message(STATUS ${PROJECT_NAME}  " CMAKE_CXX_FLAGS_${CONFIGURATION} removing ${FLAG}")
	endif()
endmacro()