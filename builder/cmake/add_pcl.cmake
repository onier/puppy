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

if (TARGET pcl)
    return()
endif ()
find_package(pcl QUIET)
if (${pcl_FOUND})
    message(STATUS "FOUND pcl ${pcl_LIBRARIES} ${pcl_INCLUDE_DIRS}")
#    set(pcl_LIBRARIES ${PCL_LIBRARIES})
#    set(pcl_INCLUDE_DIRS ${PCL_INCLUDE_DIRS})
#    set(pcl_FOUND ${PCL_FOUND})
else ()
    include(${CMAKE_CURRENT_LIST_DIR}/add_flann.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_boost.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_eigen3.cmake)
    include(ExternalProject)
    ExternalProject_Add(
            pcl
            GIT_REPOSITORY "https://gitee.com/qq2820/pcl.git"
            GIT_TAG "pcl-1.9.1"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""
            BUILD_COMMAND make -j1
            SOURCE_DIR "${OSS_SRC_PATH}/pcl"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH}
            -DBUILD_PYTHON_BINDINGS=OFF -DCMAKE_CXX_FLAGS="-Wno-implicit-fallthrough"
            -DBUILD_CUDA=ON -DBUILD_tools=OFF

            TEST_COMMAND ""
    )
    if (TARGET boost)
        ExternalProject_Add_StepDependencies(pcl build boost)
    endif ()
    if (TARGET flann)
        ExternalProject_Add_StepDependencies(pcl build flann)
    endif ()
    if (TARGET eigen3)
        ExternalProject_Add_StepDependencies(pcl build eigen3)
    endif ()
    set(pcl_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(pcl_LIBRARIES "")
endif ()

include_directories(${pcl_INCLUDE_DIRS})