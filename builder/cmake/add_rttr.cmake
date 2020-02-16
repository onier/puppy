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

if (TARGET rttr)
    set(rttr_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(rttr_LIBRARIES "${OSS_PREFIX_PATH}/lib/librttr_core_d.so")
    set(rttr_FOUND ON)
    return()
endif ()
find_package(rttr QUIET)
if (${rttr_FOUND})
    message(STATUS "FOUND rttr ${rttr_LIBRARIES} ${rttr_INCLUDE_DIRS}")
else()
    include(ExternalProject)
    ExternalProject_Add(
            rttr
            GIT_REPOSITORY "https://gitee.com/qq2820/rttr.git"
            GIT_TAG "master"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""

            SOURCE_DIR "${OSS_SRC_PATH}/rttr"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH} -DBUILD_UNIT_TESTS=OFF

            TEST_COMMAND ""
    )
    set(rttr_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(rttr_LIBRARIES "${OSS_PREFIX_PATH}/lib/librttr_core_d.so")
endif ()

include_directories(${rttr_INCLUDE_DIRS})