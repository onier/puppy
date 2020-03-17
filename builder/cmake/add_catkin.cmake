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

if (TARGET catkin)
    set(catkin_FOUND ON)
    set(catkin_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(catkin_LIBRARIES)
    return()
endif ()
find_package(catkin QUIET)

if (NOT ${catkin_FOUND})
    include(${CMAKE_CURRENT_LIST_DIR}/add_python3.cmake)
    include(ExternalProject)
    ExternalProject_Add(
            catkin
            GIT_REPOSITORY "https://gitee.com/qq2820/catkin.git"
            GIT_TAG "0.8.1"
            UPDATE_COMMAND ""
            GIT_SUBMODULES ""
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH}  -DCMAKE_BUILD_TYPE=Release -DSETUPTOOLS_DEB_LAYOUT=OFF -DPYTHON_EXECUTABLE=${OSS_PREFIX_PATH}/bin/python3
            SOURCE_DIR "${OSS_SRC_PATH}/catkin"
    )

    add_custom_target(python3_depends
            COMMAND
            pip3 install empy catkin_pkg catkin_tools -i https://pypi.douban.com/simple/)
    if (TARGET python3)
       add_dependencies(python3_depends python3)
    endif ()
    if (TARGET python3_depends)
        ExternalProject_Add_StepDependencies(catkin build python3_depends)
    endif ()
    set(catkin_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(catkin_LIBRARIES)
endif ()

include_directories(${catkin_INCLUDE_DIRS})
