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


if (TARGET Vc)
    set(Vc_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(Vc_LIBRARIES "${OSS_PREFIX_PATH}/lib/libVc.a")
    set(Vc_FOUND ON)
    return()
endif ()
set(CMAKE_MODULE_PATH ${OSS_PREFIX_PATH}/lib/cmake/Vc ${CMAKE_MODULE_PATH})
find_package(Vc QUIET)
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Vc REQUIRED_VARS Vc_LIBRARIES Vc_INCLUDE_DIR)
if (${Vc_FOUND})
    set(${Vc_INCLUDE_DIRS} ${Vc_INCLUDE_DIR})
    message(STATUS "FOUND Vc ${Vc_LIBRARIES} ${Vc_INCLUDE_DIRS}")
else()
    include(ExternalProject)
    ExternalProject_Add(
            Vc
            GIT_REPOSITORY "https://gitee.com/qq2820/Vc.git"
            GIT_TAG "1.4.1"

            UPDATE_COMMAND ""
            GIT_SUBMODULES ""
            PATCH_COMMAND ""

            SOURCE_DIR "${OSS_SRC_PATH}/Vc"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH} -DBUILD_UNIT_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_BENCHMARKS=OFF

            TEST_COMMAND ""
    )
    message(STATUS "build Vc set Vc value")
    set(Vc_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(Vc_LIBRARIES "${OSS_PREFIX_PATH}/lib/libVc.a")
    set(Vc_FOUND ON)
endif ()
include_directories(${Vc_INCLUDE_DIRS})