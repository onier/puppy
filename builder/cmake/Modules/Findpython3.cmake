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

unset(python3_LIBRARIES)

#find_library(python3_LIBRARIES
#        NAMES
#        ssl
#        HINTS
#        ${OSS_PREFIX_LIB_PATH}
#        NO_CMAKE_SYSTEM_PATH
#        )
#
#find_library(crypto_LIBRARIES
#        NAMES
#        crypto
#        HINTS
#        ${OSS_PREFIX_LIB_PATH}
#        NO_CMAKE_SYSTEM_PATH
#        )

find_path(python3_INCLUDE_DIRS
        NAMES
        python3.8/import.h
        HINTS
        ${OSS_PREFIX_INC_PATH}
        NO_CMAKE_SYSTEM_PATH
        )

if ("${python3_INCLUDE_DIRS}" STREQUAL "python3_INCLUDE_DIRS-NOTFOUND")
    set(python3_FOUND OFF)
    set(python3_LIBRARIES)
    set(python3_INCLUDE_DIRS)
    message(STATUS "ssl not found")
else ()
    set(python3_FOUND ON)
    set(python3_LIBRARIES)
    message(STATUS "python3  found ${python3_LIBRARIES}  ${python3_INCLUDE_DIRS} ")
endif ()