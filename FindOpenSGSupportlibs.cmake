# - Try to find OpenSGSupportlibs
# Once done, this will define
#
#  OpenSGSupportlibs_FOUND
#  OpenSGSupportlibs_INCLUDE_DIRS
#  OpenSGSupportlibs_LIBRARIES

if (NOT OpenSGSupportlibs_FOUND)

	include(LibFindMacros)
	
	# Visual Studio x32
	if (VS32)
	  # Visual Studio x32
	  find_path( OpenSGSupportlibs_INCLUDE_DIR
	    NAMES zlib.h
	    PATHS ${LIBRARIES_DIR}/supportlibs/include
		  ${CMAKE_SOURCE_DIR}/../supportlibs/include )

	  find_library(OpenSGSupportlibs_LIBRARY
		NAMES glut32 libjpg libpng tif32 zlib
		PATHS ${LIBRARIES_DIR}/supportlibs/lib
		  ${CMAKE_SOURCE_DIR}/../supportlibs/lib )  
	else (VS32)  
	  if (VS64) 
	    # Visual Studio x64
		find_path( OpenSGSupportlibs_INCLUDE_DIR
	    NAMES zlib.h
	    PATHS ${LIBRARIES_DIR}/supportlibs_x64/include
		  ${CMAKE_SOURCE_DIR}/../supportlibs_x64/include )

	  find_library(OpenSGSupportlibs_LIBRARY
		NAMES glut32 libjpg libpng tif32 zlib
		PATHS ${LIBRARIES_DIR}/supportlibs_x64/lib
		  ${CMAKE_SOURCE_DIR}/../supportlibs_x64/lib )
	  endif(VS64)
	endif (VS32)

	# Set the include dir variables and the libraries and let libfind_process do the rest.
	# NOTE: Singular variables for this library, plural for libraries this this lib depends on.
	set(OpenSGSupportlibs_PROCESS_INCLUDES OpenSGSupportlibs_INCLUDE_DIR)
	set(OpenSGSupportlibs_PROCESS_LIBS OpenSGSupportlibs_LIBRARY)
	libfind_process(OpenSGSupportlibs)
	
endif (NOT OpenSGSupportlibs_FOUND)