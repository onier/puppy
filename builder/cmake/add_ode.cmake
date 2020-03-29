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

if (TARGET ode)
    return()
endif ()
find_package(ode QUIET)
if (${ode_FOUND})
    message(STATUS "FOUND ode  ${ode_LIBRARIES}  ${ode_INCLUDE_DIRS}")
else ()
    include(ExternalProject)
    ExternalProject_Add(
            ode
            GIT_REPOSITORY "https://gitee.com/qq2820/ODE.git"
            GIT_TAG "0.15.1"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""

            CONFIGURE_COMMAND cd ${OSS_SRC_PATH}/ode && ./bootstrap --prefix=${OSS_PREFIX_PATH} && ./configure --enable-double-precision --with-trimesh=opcode --enable-new-trimesh --enable-shared --prefix=${OSS_PREFIX_PATH}
            BUILD_COMMAND cd ${OSS_SRC_PATH}/ode && make -j2
            INSTALL_COMMAND cd ${OSS_SRC_PATH}/ode && make install install
            SOURCE_DIR "${OSS_SRC_PATH}/ode"
    )
    set(ode_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(ode_LIBRARIES "${OSS_PREFIX_PATH}/lib/ode.so")
endif ()
include_directories(${zmq_INCLUDE_DIRS})