# USAGE:
#
# 1. Copy this file into your cmake modules path.
#
# 2. Add the following line to your CMakeLists.txt (best inside an if-condition
#    using a CMake option() to enable it just optionally):
#      include(ClangCodeCoverage)
#
# 3. Append necessary compiler flags for all supported source files:
#      append_coverage_compiler_flags()
#    Or for specific target:
#      append_coverage_compiler_flags_to_target(YOUR_TARGET_NAME)
#
# 4. Use the function below to create a custom make target which
#    runs your test executable and produces a coveralls.json file.
#
# 5. Build a Debug build:
#      cmake -DCMAKE_BUILD_TYPE=Debug ..
#      make
#      make my_coverage_target
#

include(CMakeParseArguments)

option(CODE_COVERAGE_VERBOSE "Verbose information" FALSE)

# Replaced llvm-cov/lcov dependencies with grcov
find_program(GRCOV_PATH NAMES grcov REQUIRED)
find_program(LLVM_PROFDATA_PATH NAMES llvm-profdata REQUIRED)

# Check supported compiler (Clang)
get_property(LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)
list(REMOVE_ITEM LANGUAGES NONE)
foreach(LANG ${LANGUAGES})
  if("${CMAKE_${LANG}_COMPILER_ID}" MATCHES "(Apple)?[Cc]lang")
    if("${CMAKE_${LANG}_COMPILER_VERSION}" VERSION_LESS 3)
      message(FATAL_ERROR "Clang version must be 3.0.0 or greater! Aborting...")
    endif()
  else()
    message(FATAL_ERROR "Compiler is not Clang! Aborting...")
  endif()
endforeach()

# Standard LLVM source-based coverage flags
set(COVERAGE_COMPILER_FLAGS "-fprofile-instr-generate -fcoverage-mapping"
    CACHE INTERNAL "")

include(CheckCXXCompilerFlag)
check_cxx_compiler_flag("${COVERAGE_COMPILER_FLAGS}" HAVE_COVERAGE_COMPILER_FLAGS)
if(NOT HAVE_COVERAGE_COMPILER_FLAGS)
    message(FATAL_ERROR "Coverage compiler flags not supported! Aborting...")
endif()

set(COVERAGE_CXX_COMPILER_FLAGS ${COVERAGE_COMPILER_FLAGS})
set(COVERAGE_C_COMPILER_FLAGS ${COVERAGE_COMPILER_FLAGS})
set(CMAKE_CXX_FLAGS_COVERAGE
    ${COVERAGE_CXX_COMPILER_FLAGS}
    CACHE STRING "Flags used by the C++ compiler during coverage builds."
    FORCE )
set(CMAKE_C_FLAGS_COVERAGE
    ${COVERAGE_C_COMPILER_FLAGS}
    CACHE STRING "Flags used by the C compiler during coverage builds."
    FORCE )
mark_as_advanced(
    CMAKE_CXX_FLAGS_COVERAGE
    CMAKE_C_FLAGS_COVERAGE)

# Defines a target for running and collecting code coverage information
#
# setup_target_for_coverage_grcov(
#     NAME testrunner_coverage                    # New target name
#     EXECUTABLE program                          # Program executable (kept for signature compatibility)
#     EXECUTABLE testrunner                       # Test executable
#     EXECUTABLE_ARGS --output-on-failure         # Arguments to the test executable
#     DEPENDENCIES testrunner                     # Dependencies to build first
#     BASE_DIRECTORY "../"                        # Base directory for report
#                                                 #  (defaults to PROJECT_SOURCE_DIR)
#     GRCOV_ARGS                                  # Additional arguments to grcov
#     EXCLUDE "tests/*"                           # Patterns to exclude (can be relative to PROJECT_SOURCE_DIR)
#     INCLUDE "src/*"                             # Patterns to include (can be relative to PROJECT_SOURCE_DIR)
# )
function(setup_target_for_coverage_lcov)

    set(options NONE)
    set(oneValueArgs NAME)
    set(multiValueArgs EXECUTABLE EXECUTABLE_ARGS DEPENDENCIES GRCOV_ARGS EXCLUDE INCLUDE)
    cmake_parse_arguments(Coverage "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT Coverage_EXECUTABLE)
        message(FATAL_ERROR "EXECUTABLE is required")
    endif()

    get_filename_component(_LLVM_PROFDATA_DIR "${LLVM_PROFDATA_PATH}" DIRECTORY)

    # Set base directory (as absolute path), or default to PROJECT_SOURCE_DIR
    if(DEFINED Coverage_BASE_DIRECTORY)
        get_filename_component(BASEDIR ${Coverage_BASE_DIRECTORY} ABSOLUTE)
    else()
        set(BASEDIR ${PROJECT_SOURCE_DIR})
    endif()

    # Collect excludes (CMake 3.4+: Also compute absolute paths)
    set(GRCOV_EXCLUDES "")
    foreach(EXCLUDE ${Coverage_EXCLUDE} ${COVERAGE_EXCLUDES} ${COVERAGE_GRCOV_EXCLUDES})
        list(APPEND GRCOV_EXCLUDES "${EXCLUDE}")
    endforeach()
    list(REMOVE_DUPLICATES GRCOV_EXCLUDES)

    # Collect includes (CMake 3.4+: Also compute absolute paths)
    set(GRCOV_INCLUDES "")
    foreach(INCLUDE ${Coverage_INCLUDE} ${COVERAGE_INCLUDES} ${COVERAGE_GRCOV_INCLUDES})
        list(APPEND GRCOV_INCLUDES "${INCLUDE}")
    endforeach()
    list(REMOVE_DUPLICATES GRCOV_INCLUDES)

    # 1. Cleanup old profraw data
    set(CLEAN_CMD
        ${CMAKE_COMMAND} -E remove_directory ${PROJECT_BINARY_DIR}/${Coverage_NAME}
    )

    # 2. Run tests.
    # Using `cmake -E env` is the cross-platform way to set environment variables in custom commands.
    set(EXEC_TESTS_CMD
        ${CMAKE_COMMAND} -E env "LLVM_PROFILE_FILE=${PROJECT_BINARY_DIR}/${Coverage_NAME}/%p-%m.profraw"
        ${Coverage_EXECUTABLE} ${Coverage_EXECUTABLE_ARGS}
    )

    # 3. Run grcov to generate lcov.info
    set(GRCOV_CMD
        ${GRCOV_PATH} ${PROJECT_BINARY_DIR}/${Coverage_NAME}
        --binary-path ${PROJECT_BINARY_DIR}
        --source-dir ${PROJECT_SOURCE_DIR}
        --branch
        --llvm
        -t lcov
        --llvm-path ${_LLVM_PROFDATA_DIR}
        ${Coverage_GRCOV_ARGS}
        -o ${PROJECT_BINARY_DIR}/${Coverage_NAME}.info
    )
    if(GRCOV_EXCLUDES)
        list(APPEND GRCOV_CMD --ignore ${GRCOV_EXCLUDES})
    endif()
    if(GRCOV_INCLUDES)
        list(APPEND GRCOV_CMD --keep-only ${GRCOV_INCLUDES})
    endif()

    if(CODE_COVERAGE_VERBOSE)
        message(STATUS "Command to clean up: ")
        string(REPLACE ";" " " CLEAN_CMD_SPACED "${CLEAN_CMD}")
        message(STATUS "${CLEAN_CMD_SPACED}")

        message(STATUS "Command to run the tests: ")
        string(REPLACE ";" " " EXEC_TESTS_CMD_SPACED "${EXEC_TESTS_CMD}")
        message(STATUS "${EXEC_TESTS_CMD_SPACED}")

        message(STATUS "Command to run grcov: ")
        string(REPLACE ";" " " GRCOV_CMD_SPACED "${GRCOV_CMD}")
        message(STATUS "${GRCOV_CMD_SPACED}")
    endif()

    # Setup target
    add_custom_target(${Coverage_NAME}
        COMMAND ${CLEAN_CMD}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/${Coverage_NAME}
        COMMAND ${EXEC_TESTS_CMD}
        COMMAND ${GRCOV_CMD}

        # Set output file as GENERATED
        BYPRODUCTS
            ${PROJECT_BINARY_DIR}/${Coverage_NAME}.info
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        DEPENDS ${Coverage_DEPENDENCIES}
        VERBATIM
        COMMENT "Running grcov to produce lcov.info report."
    )

    # Show where to find the JSON
    add_custom_command(TARGET ${Coverage_NAME} POST_BUILD
        COMMAND true
        COMMENT "lcov.info report saved in ${PROJECT_BINARY_DIR}/${Coverage_NAME}.info."
    )
endfunction()

function(append_coverage_compiler_flags)
    foreach(LANG ${LANGUAGES})
        set(CMAKE_${LANG}_FLAGS "${CMAKE_${LANG}_FLAGS} ${CMAKE_${LANG}_FLAGS_COVERAGE}" PARENT_SCOPE)
        if(CODE_COVERAGE_VERBOSE)
            message(STATUS "Appending code coverage compiler flags for ${LANG}: ${CMAKE_${LANG}_FLAGS_COVERAGE}")
        endif()
    endforeach()
endfunction()

function(append_coverage_compiler_flags_to_target name)
    foreach(LANG ${LANGUAGES})
        separate_arguments(_flag_list NATIVE_COMMAND "${CMAKE_${LANG}_FLAGS_COVERAGE}")
        target_compile_options(${name} PRIVATE $<$<COMPILE_LANGUAGE:${LANG}>:${_flag_list}>)
    endforeach()
endfunction()
