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
###############################################################################
# Find QVTK
#
# This sets the following variables:
#
#   QVTK_FOUND       - True if QVTK was found
#   QVTK_INCLUDE_DIR - Directory containing the QVTK include files
#   QVTK_LIBRARY     - QVTK library
#
# If QVTK_FOUND then QVTK_INCLUDE_DIR is appended to VTK_INCLUDE_DIRS and
# QVTK_LIBRARY is appended to QVTK_LIBRARY_DIR.
#

find_library (QVTK_LIBRARY QVTK HINTS ${VTK_DIR} ${VTK_DIR}/bin
  PATH_SUFFIXES Release Debug)
find_path (QVTK_INCLUDE_DIR QVTKWidget.h HINT ${VTK_INCLUDE_DIRS})
find_package_handle_standard_args(QVTK DEFAULT_MSG
  QVTK_LIBRARY QVTK_INCLUDE_DIR)

if(NOT QVTK_FOUND)
  set (VTK_USE_QVTK OFF)
else(NOT QVTK_FOUND)
  get_filename_component (QVTK_LIBRARY_DIR ${QVTK_LIBRARY} PATH)
  set (VTK_LIBRARY_DIRS ${VTK_LIBRARY_DIRS} ${QVTK_LIBRARY_DIR})
  set (VTK_INCLUDE_DIRS ${VTK_INCLUDE_DIRS} ${QVTK_INCLUDE_DIR})
  set (VTK_USE_QVTK ON)
endif(NOT QVTK_FOUND)
