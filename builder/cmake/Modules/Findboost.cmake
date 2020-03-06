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

unset(boost_LIBRARIES)

find_library(boost_LIBRARIES
        NAMES
        boost_thread
        HINTS
        ${OSS_PREFIX_LIB_PATH}
        NO_CMAKE_SYSTEM_PATH
        )
find_path(boost_INCLUDE_DIRS
        NAMES
        boost/beast.hpp
        HINTS
        ${OSS_PREFIX_INC_PATH}
        )
if (${boost_LIBRARIES} STREQUAL "boost_LIBRARIES-NOTFOUND" OR ${boost_INCLUDE_DIRS} STREQUAL "boost_INCLUDE_DIRS-NOTFOUND")
    set(boost_FOUND OFF)
    set(boost_LIBRARIES)
    set(boost_INCLUDE_DIRS)
    message(STATUS "boost not found")
else ()
    message(STATUS "boost  found ${boost_LIBRARIES}  ${boost_INCLUDE_DIRS} ")
    file(GLOB_RECURSE boost_LIBRARIES ${OSS_PREFIX_LIB_PATH}/libboost*.so)
    set(boost_FOUND ON)
    message(STATUS "boost_LIBRARIES    ${boost_LIBRARIES} ")
endif ()