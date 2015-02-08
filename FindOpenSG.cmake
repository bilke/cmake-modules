# Copyright (c) 2012 - 2015, Lars Bilke
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
#    may be used to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
#
# - Find OpenSG 1.8 libraries
# Find the specified OpenSG 1.8 libraries and header files. Slightly modified
# from the version for 2.0, see # 1.8 - comments
#
# Since OpenSG consists of a number of libraries you need to specify which
# of those you want to use. To do so, pass a list of their names after
# the COMPONENTS argument to FIND_PACKAGE. A typical call looks like this:
# FIND_PACKAGE(OpenSG REQUIRED COMPONENTS OSGBase OSGSystem OSGDrawable)
#
# This module specifies the following variables:
#  OpenSG_INCLUDE_DIRS
#  OpenSG_LIBRARIES
#  OpenSG_LIBRARY_DIRS
#
#  For each component COMP the capitalized name (e.g. OSGBASE, OSGSYSTEM):
#  OpenSG_${COMP}_LIBRARY
#  OpenSG_${COMP}_LIBRARY_RELEASE
#  OpenSG_${COMP}_LIBRARY_DEBUG
#
#  You can control where this module attempts to locate libraries and headers:
#  you can use the following input variables:
#  OPENSG_ROOT          root of an installed OpenSG with include/OpenSG and lib below it
#  OPENSG_INCLUDE_DIR   header directory
#  OPENSG_LIBRARY_DIR   library directory
#  OR
#  OPENSG_INCLUDE_SEARCH_DIR
#  OPENSG_LIBRARY_SEARCH_DIR

# This macro sets the include path and libraries to link to.
# On Windows this also sets some preprocessor definitions and disables some warnings.
MACRO(USE_OPENSG targetName)
	IF (MSVC)
		ADD_DEFINITIONS(
			-DOSG_BUILD_DLL
			-DOSG_HAVE_CONFIGURED_H_
			-DOSG_WITH_GIF
			-DOSG_WITH_TIF
			-DOSG_WITH_JPG
		)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4231 /wd4275")
	ENDIF (MSVC)
	IF(OpenSG_OSGWINDOWGLUT_LIBRARY)
		ADD_DEFINITIONS(-DOSG_WITH_GLUT)
	ENDIF()
	TARGET_LINK_LIBRARIES( ${targetName} ${OpenSG_LIBRARIES} )
	INCLUDE_DIRECTORIES( ${OpenSG_INCLUDE_DIRS} )
ENDMACRO()

SET(__OpenSG_IN_CACHE TRUE)
IF(OpenSG_INCLUDE_DIR)
    FOREACH(COMPONENT ${OpenSG_FIND_COMPONENTS})
        STRING(TOUPPER ${COMPONENT} COMPONENT)
        IF(NOT OpenSG_${COMPONENT}_FOUND)
            SET(__OpenSG_IN_CACHE FALSE)
        ENDIF(NOT OpenSG_${COMPONENT}_FOUND)
    ENDFOREACH(COMPONENT)
ELSE(OpenSG_INCLUDE_DIR)
    SET(__OpenSG_IN_CACHE FALSE)
ENDIF(OpenSG_INCLUDE_DIR)


# The reason that we failed to find OpenSG. This will be set to a
# user-friendly message when we fail to find some necessary piece of
# OpenSG.
set(OpenSG_ERROR_REASON)

############################################
#
# Check the existence of the libraries.
#
############################################
# This macro is directly taken from FindBoost.cmake that comes with the cmake
# distribution. It is NOT my work, only minor modifications have been made to
# remove references to boost.
#########################################################################

MACRO(__OpenSG_ADJUST_LIB_VARS basename)
    IF(OpenSG_INCLUDE_DIR)
        IF(OpenSG_${basename}_LIBRARY_DEBUG AND OpenSG_${basename}_LIBRARY_RELEASE)
        # if the generator supports configuration types then set
        # optimized and debug libraries, or if the CMAKE_BUILD_TYPE has a value
            IF (CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
                SET(OpenSG_${basename}_LIBRARY optimized ${OpenSG_${basename}_LIBRARY_RELEASE} debug ${OpenSG_${basename}_LIBRARY_DEBUG})
            ELSE(CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
                # if there are no configuration types and CMAKE_BUILD_TYPE has no value
                # then just use the release libraries
                SET(OpenSG_${basename}_LIBRARY ${OpenSG_${basename}_LIBRARY_RELEASE} )
            ENDIF(CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)

            SET(OpenSG_${basename}_LIBRARIES optimized ${OpenSG_${basename}_LIBRARY_RELEASE} debug ${OpenSG_${basename}_LIBRARY_DEBUG})
        ENDIF(OpenSG_${basename}_LIBRARY_DEBUG AND OpenSG_${basename}_LIBRARY_RELEASE)

        # if only the release version was found, set the debug variable also to the release version
        IF(OpenSG_${basename}_LIBRARY_RELEASE AND NOT OpenSG_${basename}_LIBRARY_DEBUG)
            SET(OpenSG_${basename}_LIBRARY_DEBUG ${OpenSG_${basename}_LIBRARY_RELEASE})
            SET(OpenSG_${basename}_LIBRARY       ${OpenSG_${basename}_LIBRARY_RELEASE})
            SET(OpenSG_${basename}_LIBRARIES     ${OpenSG_${basename}_LIBRARY_RELEASE})
        ENDIF(OpenSG_${basename}_LIBRARY_RELEASE AND NOT OpenSG_${basename}_LIBRARY_DEBUG)

        # if only the debug version was found, set the release variable also to the debug version
        IF(OpenSG_${basename}_LIBRARY_DEBUG AND NOT OpenSG_${basename}_LIBRARY_RELEASE)
            SET(OpenSG_${basename}_LIBRARY_RELEASE ${OpenSG_${basename}_LIBRARY_DEBUG})
            SET(OpenSG_${basename}_LIBRARY         ${OpenSG_${basename}_LIBRARY_DEBUG})
            SET(OpenSG_${basename}_LIBRARIES       ${OpenSG_${basename}_LIBRARY_DEBUG})
        ENDIF(OpenSG_${basename}_LIBRARY_DEBUG AND NOT OpenSG_${basename}_LIBRARY_RELEASE)

        IF(OpenSG_${basename}_LIBRARY)
            SET(OpenSG_${basename}_LIBRARY ${OpenSG_${basename}_LIBRARY} CACHE FILEPATH "The OpenSG ${basename} library")
            GET_FILENAME_COMPONENT(OpenSG_LIBRARY_DIRS "${OpenSG_${basename}_LIBRARY}" PATH)
            SET(OpenSG_LIBRARY_DIRS ${OpenSG_LIBRARY_DIRS} CACHE FILEPATH "OpenSG library directory")
            SET(OpenSG_${basename}_FOUND ON CACHE INTERNAL "Whether the OpenSG ${basename} library found")
        ENDIF(OpenSG_${basename}_LIBRARY)

    ENDIF(OpenSG_INCLUDE_DIR)

    # Make variables changeble to the advanced user
    MARK_AS_ADVANCED(
        OpenSG_${basename}_LIBRARY
        OpenSG_${basename}_LIBRARY_RELEASE
        OpenSG_${basename}_LIBRARY_DEBUG
    )
ENDMACRO(__OpenSG_ADJUST_LIB_VARS)

#-------------------------------------------------------------------------------


IF(__OpenSG_IN_CACHE)
    # values are already in the cache

    SET(OpenSG_FOUND TRUE)
    FOREACH(COMPONENT ${OpenSG_FIND_COMPONENTS})
        STRING(TOUPPER ${COMPONENT} COMPONENT)
        __OpenSG_ADJUST_LIB_VARS(${COMPONENT})
        SET(OpenSG_LIBRARIES ${OpenSG_LIBRARIES} ${OpenSG_${COMPONENT}_LIBRARY})
    ENDFOREACH(COMPONENT)

    SET(OpenSG_INCLUDE_DIRS "${OpenSG_INCLUDE_DIR}" "${OpenSG_INCLUDE_DIR}/OpenSG")

ELSE(__OpenSG_IN_CACHE)
    # need to search for libs

	# Visual Studio x32
	if (VS32)
	  # Visual Studio x32
	  SET( __OpenSG_INCLUDE_SEARCH_DIRS
	    $ENV{OPENSG_ROOT}/include
	    ${OPENSG_ROOT}/include
	    ${LIBRARIES_DIR}/opensg/include
	    ${CMAKE_SOURCE_DIR}/../OpenSG/include )
	  SET( __OpenSG_LIBRARIES_SEARCH_DIRS
	    $ENV{OPENSG_ROOT}/lib
	    ${OPENSG_ROOT}/lib
	    ${LIBRARIES_DIR}/opensg/lib
	    ${CMAKE_SOURCE_DIR}/../opensg/lib )
	else (VS32)
	  if (VS64)
	    # Visual Studio x64
		SET( __OpenSG_INCLUDE_SEARCH_DIRS
		$ENV{OPENSG_ROOT}/include
		${OPENSG_ROOT}/include
	      ${LIBRARIES_DIR}/opensg_x64/include
	      ${CMAKE_SOURCE_DIR}/../opensg_x64/include )
		SET( __OpenSG_LIBRARIES_SEARCH_DIRS
		$ENV{OPENSG_ROOT}/lib
		${OPENSG_ROOT}/lib
	      ${LIBRARIES_DIR}/opensg_x64/lib
	      ${CMAKE_SOURCE_DIR}/../opensg_x64/lib )
	  else (VS64)
	    # Linux or Mac
		SET( __OpenSG_INCLUDE_SEARCH_DIRS
          "/usr/local"
	      "/usr/local/include" )
		SET( __OpenSG_LIBRARIES_SEARCH_DIRS
	      "/usr/local"
	      "/usr/local/lib" )
	  endif(VS64)
	endif (VS32)


    # handle input variable OPENSG_INCLUDE_DIR
    IF(OPENSG_INCLUDE_DIR)
        FILE(TO_CMAKE_PATH ${OPENSG_INCLUDE_DIR} OPENSG_INCLUDE_DIR)
        SET(__OpenSG_INCLUDE_SEARCH_DIRS
            ${OPENSG_INCLUDE_DIR} ${__OpenSG_INCLUDE_SEARCH_DIRS})
    ENDIF(OPENSG_INCLUDE_DIR)

    # handle input variable OPENSG_LIBRARY_DIR
    IF(OPENSG_LIBRARY_DIR)
        FILE(TO_CMAKE_PATH ${OPENSG_LIBRARY_DIR} OPENSG_LIBRARY_DIR)
        SET(__OpenSG_LIBRARIES_SEARCH_DIRS
            ${OPENSG_LIBRARY_DIR} ${__OpenSG_LIBRARIES_SEARCH_DIRS})
    ENDIF(OPENSG_LIBRARY_DIR)

    # handle input variable OPENSG_INCLUDE_SEARCH_DIR
    IF(OPENSG_INCLUDE_SEARCH_DIR)
        FILE(TO_CMAKE_PATH ${OPENSG_INCLUDE_SEARCH_DIR} OPENSG_INCLUDE_SEARCH_DIR)
        SET(__OpenSG_INCLUDE_SEARCH_DIRS
            ${OPENSG_INCLUDE_SEARCH_DIR} ${__OpenSG_INCLUDE_SEARCH_DIRS})
    ENDIF(OPENSG_INCLUDE_SEARCH_DIR)

    # handle input variable OPENSG_LIBRARY_SEARCH_DIR
    IF(OPENSG_LIBRARY_SEARCH_DIR)
        FILE(TO_CMAKE_PATH ${OPENSG_LIBRARY_SEARCH_DIR} OPENSG_LIBRARY_SEARCH_DIR)
        SET(__OpenSG_LIBRARIES_SEARCH_DIRS
            ${OPENSG_LIBRARY_SEARCH_DIR} ${__OpenSG_LIBRARIES_SEARCH_DIRS})
    ENDIF(OPENSG_LIBRARY_SEARCH_DIR)

    IF(NOT OpenSG_INCLUDE_DIR)
        # try to find include dirrectory by searching for OSGConfigured.h
        FIND_PATH(OpenSG_INCLUDE_DIR
            NAMES         OpenSG/OSGConfigured.h
            HINTS         ${__OpenSG_INCLUDE_SEARCH_DIRS})
    ENDIF(NOT OpenSG_INCLUDE_DIR)
	#message(STATUS "OpenSG_INCLUDE_DIR: " ${OpenSG_INCLUDE_DIR})
    # ------------------------------------------------------------------------
    #  Begin finding OpenSG libraries
    # ------------------------------------------------------------------------
    FOREACH(COMPONENT ${OpenSG_FIND_COMPONENTS})
        STRING(TOUPPER ${COMPONENT} UPPERCOMPONENT)
        SET(OpenSG_${UPPERCOMPONENT}_LIBRARY "OpenSG_${UPPERCOMPONENT}_LIBRARY-NOTFOUND" )
        SET(OpenSG_${UPPERCOMPONENT}_LIBRARY_RELEASE "OpenSG_${UPPERCOMPONENT}_LIBRARY_RELEASE-NOTFOUND" )
        SET(OpenSG_${UPPERCOMPONENT}_LIBRARY_DEBUG "OpenSG_${UPPERCOMPONENT}_LIBRARY_DEBUG-NOTFOUND")

	IF (WIN32)
        FIND_LIBRARY(OpenSG_${UPPERCOMPONENT}_LIBRARY_RELEASE
            NAMES  ${COMPONENT}
            HINTS  ${__OpenSG_LIBRARIES_SEARCH_DIRS}
        )

		#message(STATUS "OpenSG Component: " ${COMPONENT})

        FIND_LIBRARY(OpenSG_${UPPERCOMPONENT}_LIBRARY_DEBUG
	    # 1.8 Added the "D" suffix
            NAMES  ${COMPONENT}D
            HINTS  ${__OpenSG_LIBRARIES_SEARCH_DIRS}
            # 1.8 Removed next line
	    #PATH_SUFFIXES "debug"
        )
	ELSE (WIN32)
	FIND_LIBRARY(OpenSG_${UPPERCOMPONENT}_LIBRARY_RELEASE
            NAMES  ${COMPONENT}
            HINTS  ${__OpenSG_LIBRARIES_SEARCH_DIRS}
	    PATH_SUFFIXES "/opt"
        )

		#message(STATUS "OpenSG Component: " ${COMPONENT})

        FIND_LIBRARY(OpenSG_${UPPERCOMPONENT}_LIBRARY_DEBUG
            NAMES  ${COMPONENT}
            HINTS  ${__OpenSG_LIBRARIES_SEARCH_DIRS}
	    PATH_SUFFIXES "/dbg"
        )
	ENDIF(WIN32)

        __OpenSG_ADJUST_LIB_VARS(${UPPERCOMPONENT})
    ENDFOREACH(COMPONENT)
    # ------------------------------------------------------------------------
    #  End finding OpenSG libraries
    # ------------------------------------------------------------------------

    SET(OpenSG_INCLUDE_DIRS "${OpenSG_INCLUDE_DIR}" "${OpenSG_INCLUDE_DIR}/OpenSG")

    SET(OpenSG_FOUND FALSE)

    IF(OpenSG_INCLUDE_DIR)
        SET(OpenSG_FOUND TRUE)

        # check if all requested components were found
        SET(__OpenSG_CHECKED_COMPONENT FALSE)
        SET(__OpenSG_MISSING_COMPONENTS)

        FOREACH(COMPONENT ${OpenSG_FIND_COMPONENTS})
            STRING(TOUPPER ${COMPONENT} COMPONENT)
            SET(__OpenSG_CHECKED_COMPONENT TRUE)

            IF(NOT OpenSG_${COMPONENT}_FOUND)
                STRING(TOLOWER ${COMPONENT} COMPONENT)
                LIST(APPEND __OpenSG_MISSING_COMPONENTS ${COMPONENT})
                SET(OpenSG_FOUND FALSE)
            ENDIF(NOT OpenSG_${COMPONENT}_FOUND)
        ENDFOREACH(COMPONENT)

        IF(__OpenSG_MISSING_COMPONENTS)
            # We were unable to find some libraries, so generate a sensible
            # error message that lists the libraries we were unable to find.
            SET(OpenSG_ERROR_REASON
                "${OpenSG_ERROR_REASON}\nThe following OpenSG libraries could not be found:\n")
            FOREACH(COMPONENT ${__OpenSG_MISSING_COMPONENTS})
                SET(OpenSG_ERROR_REASON
                    "${OpenSG_ERROR_REASON}        ${COMPONENT}\n")
            ENDFOREACH(COMPONENT)

            LIST(LENGTH OpenSG_FIND_COMPONENTS __OpenSG_NUM_COMPONENTS_WANTED)
            LIST(LENGTH __OpenSG_MISSING_COMPONENTS __OpenSG_NUM_MISSING_COMPONENTS)
            IF(${__OpenSG_NUM_COMPONENTS_WANTED} EQUAL ${__OpenSG_NUM_MISSING_COMPONENTS})
                SET(OpenSG_ERROR_REASON
                "${OpenSG_ERROR_REASON}No OpenSG libraries were found. You may need to set OPENSG_LIBRARY_DIR to the directory containing OpenSG libraries or OPENSG_ROOT to the location of OpenSG.")
            ELSE(${__OpenSG_NUM_COMPONENTS_WANTED} EQUAL ${__OpenSG_NUM_MISSING_COMPONENTS})
                SET(OpenSG_ERROR_REASON
                "${OpenSG_ERROR_REASON}Some (but not all) of the required OpenSG libraries were found. You may need to install these additional OpenSG libraries. Alternatively, set OPENSG_LIBRARY_DIR to the directory containing OpenSG libraries or OPENSG_ROOT to the location of OpenSG.")
            ENDIF(${__OpenSG_NUM_COMPONENTS_WANTED} EQUAL ${__OpenSG_NUM_MISSING_COMPONENTS})
        ENDIF(__OpenSG_MISSING_COMPONENTS)

    ENDIF(OpenSG_INCLUDE_DIR)

    IF(OpenSG_FOUND)
        IF(NOT OpenSG_FIND_QUIETLY)
            MESSAGE(STATUS "OpenSG found.")
        ENDIF(NOT OpenSG_FIND_QUIETLY)

        IF (NOT OpenSG_FIND_QUIETLY)
            MESSAGE(STATUS "Found the following OpenSG libraries:")
        ENDIF(NOT OpenSG_FIND_QUIETLY)

        FOREACH(COMPONENT  ${OpenSG_FIND_COMPONENTS})
            STRING(TOUPPER ${COMPONENT} UPPERCOMPONENT)
            IF(OpenSG_${UPPERCOMPONENT}_FOUND)
                IF(NOT OpenSG_FIND_QUIETLY)
                    MESSAGE(STATUS "  ${COMPONENT}")
                ENDIF(NOT OpenSG_FIND_QUIETLY)
                SET(OpenSG_LIBRARIES ${OpenSG_LIBRARIES} ${OpenSG_${UPPERCOMPONENT}_LIBRARY})
            ENDIF(OpenSG_${UPPERCOMPONENT}_FOUND)
        ENDFOREACH(COMPONENT)

    ELSE(OpenSG_FOUND)
        IF(OpenSG_FIND_REQUIRED)
            MESSAGE(SEND_ERROR "Unable to find the requested OpenSG libraries.\n${OpenSG_ERROR_REASON}")
        ENDIF(OpenSG_FIND_REQUIRED)
    ENDIF(OpenSG_FOUND)

ENDIF(__OpenSG_IN_CACHE)
