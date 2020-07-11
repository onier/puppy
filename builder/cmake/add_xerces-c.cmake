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

if (TARGET xerces-c)
    set(xerces-c_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
#    //centos
    set(xerces-c_LIBRARIES "${OSS_PREFIX_PATH}/lib/libxerces-c.so")
    set(xerces-c_FOUND ON)
    return()
endif ()
find_package(xerces-c QUIET)
#find_package(xerces-c REQUIRED)
if (${xerces-c_FOUND})
    message(STATUS "FOUND xerces-c ${xerces-c_LIBRARIES} ${xerces-c_INCLUDE_DIRS}")
    set(xerces-c_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    #    //centos
    set(xerces-c_LIBRARIES "${OSS_PREFIX_PATH}/lib/libxerces-c.so")
    set(xerces-c_FOUND ON)
else()
    include(ExternalProject)
    ExternalProject_Add(
            xerces-c
            GIT_REPOSITORY "https://gitee.com/qq2820/xerces-c.git"
            GIT_TAG "v3.2.2"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""

            SOURCE_DIR "${OSS_SRC_PATH}/xerces-c"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH} -DBUILD_PYTHON_BINDINGS=OFF -DBUILD_SHARED_LIBS=ON

            TEST_COMMAND ""
    )
    set(xerces-c_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(xerces-c_LIBRARIES "${OSS_PREFIX_PATH}/lib/libxerces-c.so")
    set(xerces-c_FOUND ON)
    message(STATUS "NOT FOUND xerces-c ${xerces-c_LIBRARIES} ${xerces-c_INCLUDE_DIRS}")
endif ()

include_directories(${xerces-c_INCLUDE_DIRS})