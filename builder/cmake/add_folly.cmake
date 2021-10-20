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

if (TARGET folly)
    set(folly_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(folly_LIBRARIES "${OSS_PREFIX_PATH}/lib/libfolly.so")
    set(folly_FOUND ON)
    return()
endif ()
find_package(folly QUIET)
#find_package(folly REQUIRED)
if (${folly_FOUND})
    message(STATUS "FOUND folly ${folly_LIBRARIES} ${folly_INCLUDE_DIRS}")
    set(folly_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(folly_LIBRARIES "${OSS_PREFIX_PATH}/lib/libfolly.so")
    set(folly_FOUND ON)
else ()
    include(ExternalProject)
    include(${CMAKE_CURRENT_LIST_DIR}/add_double-conversion.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_boost.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_fmt.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_glog.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_libevent.cmake)
    ExternalProject_Add(
            folly
            GIT_REPOSITORY "https://gitee.com/qq2820/folly.git"
            GIT_TAG "master"
            #please use the https://gitee.com/qq2820/folly.git url
            #            GIT_REPOSITORY "http://192.168.10.7/xuzhenhai/folly"
            #            GIT_TAG "master"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""

            SOURCE_DIR "${OSS_SRC_PATH}/folly"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH} -DBUILD_SHARED_LIBS=ON

            TEST_COMMAND ""
    )
    if (TARGET double-conversion)
        ExternalProject_Add_StepDependencies(folly build double-conversion)
    endif ()
    if (TARGET boost)
        ExternalProject_Add_StepDependencies(folly build boost)
    endif ()
    if (TARGET fmt)
        ExternalProject_Add_StepDependencies(folly build fmt)
    endif ()
     if (TARGET glog)
        ExternalProject_Add_StepDependencies(folly build glog)
    endif ()
    if (TARGET libevent)
        ExternalProject_Add_StepDependencies(folly build libevent)
    endif ()
    set(folly_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(folly_LIBRARIES "${OSS_PREFIX_PATH}/lib/libfolly.so")
    set(folly_FOUND ON)
    message(STATUS "NOT FOUND folly ${folly_LIBRARIES} ${folly_INCLUDE_DIRS}")
endif ()

include_directories(${folly_INCLUDE_DIRS})