# Copyright (c) 2020 - 2022 xuzhenhai <282052309@qq.com>
#
# This file is part of puppy builder
#    License: MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

unset(xerces-c_LIBRARIES)
find_library(xerces-c_LIBRARIES
        NAMES
        xerces-c
        HINTS
        ${OSS_PREFIX_LIB_PATH}
        )

find_path(xerces-c_INCLUDE_DIRS
        NAMES
        xercesc/parsers/XercesDOMParser.hpp
        HINTS
        ${OSS_PREFIX_INC_PATH}
        )
if (${xerces-c_LIBRARIES} STREQUAL "xerces-c_LIBRARIES-NOTFOUND" OR ${xerces-c_INCLUDE_DIRS} STREQUAL "xerces-c_INCLUDE_DIRS-NOTFOUND")
    set(xerces-c_FOUND OFF)
    set(xerces-c_LIBRARIES)
    set(xerces-c_INCLUDE_DIR)
else ()
    set(xerces-c_FOUND ON)
    set(xerces-c_LIBRARIES ${xerces-cmalloc_LIBRARIES} ${xerces-c_LIBRARIES})
endif ()
