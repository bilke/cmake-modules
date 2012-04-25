# The module defines the following variables:
#   MSYSGIT_BIN_DIR - path to the tool binaries
#   MSYSGIT_FOUND - true if the command line client was found
# Example usage:
#   FIND_PACKAGE(MsysGit)
#   IF(MSYSGIT_FOUND)
#     MESSAGE("msysGit tools found in: ${MSYSGIT_BIN_DIR}")
#   ENDIF()

if(GIT_EXECUTABLE)
  EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} --version
                  OUTPUT_VARIABLE git_version
                  ERROR_QUIET
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  IF (git_version MATCHES "^git version [0-9]")
    STRING(REPLACE "git version " "" GIT_VERSION_STRING "${git_version}")
    IF (git_version MATCHES "msysgit")
      SET(GIT_IS_MSYSGIT TRUE)
    ELSE()
      SET(GIT_IS_MSYSGIT FALSE)
    ENDIF()
  ENDIF()
  UNSET(git_version)
ENDIF(GIT_EXECUTABLE)

IF(GIT_IS_MSYSGIT)
  GET_FILENAME_COMPONENT(MSYS_DIR ${GIT_EXECUTABLE} PATH)
  FIND_PATH(MSYSGIT_BIN_DIR
	NAMES date.exe grep.exe unzip.exe git.exe PATHS ${MSYS_DIR}/../bin NO_DEFAULT_PATH)
ELSE()
  FIND_PATH(MSYSGIT_BIN_DIR
	NAMES date.exe grep.exe unzip.exe git.exe PATH_SUFFIXES Git/bin)
ENDIF()

# Handle the QUIETLY and REQUIRED arguments and set MSYSGIT_FOUND to TRUE if
# all listed variables are TRUE

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(MsysGit
                                  REQUIRED_VARS MSYSGIT_BIN_DIR)