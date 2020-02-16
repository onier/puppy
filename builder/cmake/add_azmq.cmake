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

 if (TARGET azmq)
    set(azmq_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(azmq_LIBRARIES "")
    set(azmq_FOUND ON)
    return()
endif ()
find_package(azmq QUIET)
if (${azmq_FOUND})
    message(STATUS "FOUND azmq ${azmq_INCLUDE_DIRS}")
else ()
    include(ExternalProject)
    include(${CMAKE_CURRENT_LIST_DIR}/add_libzmq.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_boost.cmake)
    ExternalProject_Add(
            azmq
            GIT_REPOSITORY "https://gitee.com/qq2820/azmq.git"
            GIT_TAG "v1.0.2"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""

            SOURCE_DIR "${OSS_SRC_PATH}/azmq"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH}

            TEST_COMMAND ""
    )
    if (TARGET boost)
        ExternalProject_Add_StepDependencies(azmq build boost)
    endif ()
    if (TARGET libzmq)
        ExternalProject_Add_StepDependencies(azmq build libzmq)
    endif ()
    set(azmq_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(azmq_LIBRARIES "")
endif ()
include_directories(${azmq_INCLUDE_DIRS})