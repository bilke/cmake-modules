# From http://www.kitware.com/blog/home/post/300
#
# Usage:
#
#  include(ListAllCMakeVariableValues)
#  list_all_cmake_variable_values()

function(list_all_cmake_variable_values)
  message(STATUS "")
  get_cmake_property(vs VARIABLES)
  foreach(v ${vs})
    message(STATUS "${v}='${${v}}'")
  endforeach()
  message(STATUS "")
endfunction()
