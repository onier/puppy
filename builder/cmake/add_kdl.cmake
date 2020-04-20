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


find_package(kdl QUIET)
if (NOT ${kdl_FOUND})
    include(${CMAKE_CURRENT_LIST_DIR}/add_eigen3.cmake)
    include(ExternalProject)
    ExternalProject_Add(
            kdl
            GIT_REPOSITORY "https://gitee.com/qq2820/orocos_kinematics_dynamics.git"
            GIT_TAG "v1.4.0"
            UPDATE_COMMAND ""
            CONFIGURE_COMMAND cd ${OSS_SRC_PATH}/kdl/orocos_kdl &&  ${CMAKE_SOURCE_DIR}/builder/cmake-3.16.4-Linux-x86_64/bin/cmake  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH}
            BUILD_COMMAND cd ${OSS_SRC_PATH}/kdl/orocos_kdl && make -j2
            INSTALL_COMMAND cd ${OSS_SRC_PATH}/kdl/orocos_kdl && make install
            SOURCE_DIR "${OSS_SRC_PATH}/kdl"
    )
    if (TARGET eigen3)
        ExternalProject_Add_StepDependencies(kdl build eigen3)
    endif ()
    set(kdl_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(kdl_FOUND ON)
    set(kdl_LIBRARIES ${OSS_PREFIX_PATH}/lib/liborocos-kdl.so)
endif ()
include_directories(${kdl_INCLUDE_DIRS})