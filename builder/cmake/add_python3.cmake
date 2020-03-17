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

if (TARGET python3)
    set(python3_FOUND ON)
    set(python3_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(python3_LIBRARIES)
    return()
endif ()
find_package(python3 QUIET)
if (NOT ${python3_FOUND})
    include(${CMAKE_CURRENT_LIST_DIR}/add_openssl.cmake)
    include(ExternalProject)
    ExternalProject_Add(
            python3
            GIT_REPOSITORY "https://gitee.com/qq2820/cpython.git"
            GIT_TAG "v3.8.2"
            UPDATE_COMMAND ""
            GIT_SUBMODULES ""
            CONFIGURE_COMMAND cd ${OSS_SRC_PATH}/python3 && ./configure --prefix=${OSS_PREFIX_PATH} --with-openssl=${OSS_PREFIX_PATH}
            BUILD_COMMAND cd ${OSS_SRC_PATH}/python3 && make -j2
            INSTALL_COMMAND cd ${OSS_SRC_PATH}/python3 && make install
            SOURCE_DIR "${OSS_SRC_PATH}/python3"
    )
    if (TARGET openssl)
        ExternalProject_Add_StepDependencies(python3 build openssl)
    endif ()
    set(python3_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(python3_LIBRARIES)
endif ()
