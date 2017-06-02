if (MSVC)
  if (MSVC80)
    set(VCVERS 8)
  endif()
  if (MSVC90)
    set(VCVERS 9)
  endif()
  if (MSVC10)
    set(VCVERS 10)
  endif()

  if(CMAKE_CL_64)
    #if(MSVC_VERSION GREATER 1599)
      # VS 10 and later:
      set(CMAKE_MSVC_ARCH x64)
    #else()
    #  # VS 9 and earlier:
    #  set(CMAKE_MSVC_ARCH amd64)
    #endif()
  else()
    set(CMAKE_MSVC_ARCH x86)
  endif()

  set(SDKVERS "2.0")
  if(${VCVERS} EQUAL 8)
    set(SDKVERS "2.0")
  endif()
  if(${VCVERS} EQUAL 9)
    set(SDKVERS "v6.0A")
  endif()
  if(${VCVERS} EQUAL 10)
    set(SDKVERS "v7.0A")
  endif()
  if(MSVC${VCVERS}0 OR MSVC${VCVERS})
    find_program(MSVC_REDIST NAMES
vcredist_${CMAKE_MSVC_ARCH}/vcredist_${CMAKE_MSVC_ARCH}.exe
      PATHS
      "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\VCExpress\\${VCVERS}.0;InstallDir]/../../SDK/v${SDKVERS}/BootStrapper/Packages/"
      "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\VisualStudio\\${VCVERS}.0;InstallDir]/../../SDK/v${SDKVERS}/BootStrapper/Packages/"
      "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\${VCVERS}.0;InstallDir]/../../SDK/v${SDKVERS}/BootStrapper/Packages/"
"C:/Program Files (x86)/Microsoft SDKs/Windows/${SDKVERS}/Bootstrapper/Packages/"
      )
    get_filename_component(vcredist_name "${MSVC_REDIST}" NAME)
    install(PROGRAMS ${MSVC_REDIST} COMPONENT msvc_redist DESTINATION bin)
    set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "ExecWait '\\\"$INSTDIR\\\\bin\\\\${vcredist_name}\\\"'")
    message(STATUS "MSVC_REDIST: ${MSVC_REDIST}")
  endif()
endif ()