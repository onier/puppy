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

if (TARGET ompl)
    set(ompl_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(ompl_LIBRARIES "${OSS_PREFIX_PATH}/lib/libompl.so")
    set(ompl_FOUND ON)
    return()
endif ()
find_package(ompl QUIET)
if (${ompl_FOUND})
    message(STATUS "FOUND ompl ${ompl_INCLUDE_DIRS}  ${ompl_LIBRARIES}")
else ()
    include(ExternalProject)
    include(${CMAKE_CURRENT_LIST_DIR}/add_boost.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_eigen3.cmake)
    ExternalProject_Add(
            ompl
            GIT_REPOSITORY "https://gitee.com/qq2820/ompl.git"
            GIT_TAG "1.4.2"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""
            GIT_SUBMODULES ""
            SOURCE_DIR "${OSS_SRC_PATH}/ompl"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH} -DASSIMP_BUILD_TESTS=OFF

            TEST_COMMAND ""
    )
    if (TARGET boost)
        ExternalProject_Add_StepDependencies(ompl build boost)
    endif ()
    if (TARGET eigen3)
        ExternalProject_Add_StepDependencies(ompl build eigen3)
    endif ()
    set(ompl_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(ompl_LIBRARIES "${OSS_PREFIX_PATH}/lib/libompl.so")
endif ()
include_directories(${ompl_INCLUDE_DIRS})
