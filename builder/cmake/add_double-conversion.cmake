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

if (TARGET double-conversion)
    set(double-conversion_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(double-conversion_LIBRARIES "${OSS_PREFIX_PATH}/lib/libdouble-conversion.so")
    set(double-conversion_FOUND ON)
    return()
endif ()
find_package(double-conversion QUIET)
#find_package(double-conversion REQUIRED)
if (${double-conversion_FOUND})
    message(STATUS "FOUND double-conversion ${double-conversion_LIBRARIES} ${double-conversion_INCLUDE_DIRS}")
    set(double-conversion_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(double-conversion_LIBRARIES "${OSS_PREFIX_PATH}/lib/libdouble-conversion.so")
    set(double-conversion_FOUND ON)
else()
    include(ExternalProject)
    ExternalProject_Add(
            double-conversion
            GIT_REPOSITORY "https://gitee.com/qq2820/double-conversion.git"
            GIT_TAG "v3.1.5"
            #please use the https://gitee.com/qq2820/double-conversion.git url
            #            GIT_REPOSITORY "http://192.168.10.7/xuzhenhai/double-conversion"
            #            GIT_TAG "master"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""

            SOURCE_DIR "${OSS_SRC_PATH}/double-conversion"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH} -DBUILD_SHARED_LIBS=ON

            TEST_COMMAND ""
    )
    set(double-conversion_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(double-conversion_LIBRARIES "${OSS_PREFIX_PATH}/lib/libdouble-conversion.so")
    set(double-conversion_FOUND ON)
    message(STATUS "NOT FOUND double-conversion ${double-conversion_LIBRARIES} ${double-conversion_INCLUDE_DIRS}")
endif ()

include_directories(${double-conversion_INCLUDE_DIRS})