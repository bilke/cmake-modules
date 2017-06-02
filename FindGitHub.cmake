# - Find GitHub for Windows
#
#   GITHUB_FOUND    - Was GitHub for Windows found
#   GITHUB_BIN_DIR  - Path to the bin-directory where useful bash tools can be found
#
# Example usage:
#   find_package(GitHub)
#   find_program(BASH_TOOL_PATH bash HINTS ${GITHUB_BIN_DIR} DOC "The bash executable")

if(WIN32 AND NOT GITHUB_FOUND)

    # Check install Path
    find_path(
        GITHUB_DIR
        shell.ps1
        PATHS $ENV{LOCALAPPDATA}/GitHub $ENV{GitHub_DIR}
        NO_DEFAULT_PATH
    )

    if(GITHUB_DIR)

        execute_process (
            COMMAND cmd /c "cd ${GITHUB_DIR}/PortableGit*/bin & cd"
            OUTPUT_VARIABLE PORTABLE_GIT_WIN_DIR
        )

        if(PORTABLE_GIT_WIN_DIR)
            string(STRIP ${PORTABLE_GIT_WIN_DIR} PORTABLE_GIT_WIN_DIR)
            file(TO_CMAKE_PATH ${PORTABLE_GIT_WIN_DIR} PORTABLE_GIT_WIN_DIR)
            set(GITHUB_FOUND ON CACHE BOOL "Was GitHub for Windows found?")
            set(GITHUB_BIN_DIR ${PORTABLE_GIT_WIN_DIR} CACHE PATH "The path to the GitHub for Windows binaries." FORCE)
            message(STATUS "GitHub for Windows found.")
        endif()

    endif()
endif()
