# The module defines the following variables:
#   MSYSGIT_BIN_DIR - path to the tool binaries
#   MSYSGIT_FOUND - true if the command line client was found
# Example usage:
#   find_package(MsysGit)
#   if(MSYSGIT_FOUND)
#     message("msysGit tools found in: ${MSYSGIT_BIN_DIR}")
#   endif()

if(GIT_EXECUTABLE)
    execute_process(COMMAND ${GIT_EXECUTABLE} --version
                                    OUTPUT_VARIABLE git_version
                                    ERROR_QUIET
                                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    if (git_version MATCHES "^git version [0-9]")
        string(REPLACE "git version " "" GIT_VERSION_STRING "${git_version}")
        if (git_version MATCHES "msysgit")
            set(GIT_IS_MSYSGIT TRUE)
        else()
            set(GIT_IS_MSYSGIT FALSE)
        endif()
    endif()
    unset(git_version)
endif()

if(GIT_IS_MSYSGIT)
    get_filename_component(MSYS_DIR ${GIT_EXECUTABLE} PATH)
    find_path(MSYSGIT_BIN_DIR
    NAMES date.exe grep.exe unzip.exe git.exe PATHS ${MSYS_DIR}/../bin NO_DEFAULT_PATH)
else()
    find_path(MSYSGIT_BIN_DIR
    NAMES date.exe grep.exe unzip.exe git.exe PATH_SUFFIXES Git/bin)
endif()

# Handle the QUIETLY and REQUIRED arguments and set MSYSGIT_FOUND to TRUE if
# all listed variables are TRUE

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(MsysGit
                                                                    REQUIRED_VARS MSYSGIT_BIN_DIR)
