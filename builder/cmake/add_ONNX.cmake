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

if (TARGET ONNX)
    return()
endif ()
set(ONNX_DIR ${OSS_PREFIX_PATH}/share/cmake/ONNX/)
find_package(ONNX REQUIRED)
if (${ONNX_FOUND})
    message(STATUS "FOUND ONNX  ${ONNX_LIBRARIES}  ${ONNX_INCLUDE_DIRS}")
else ()
    include(ExternalProject)
    ExternalProject_Add(
            ONNX
            GIT_REPOSITORY "https://gitee.com/qq2820/onnx.git"
            GIT_TAG "v1.6.0"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""
            GIT_SUBMODULES ""
            SOURCE_DIR "${OSS_SRC_PATH}/onnx"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH}

            TEST_COMMAND ""
    )
    set(ONNX_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(ONNX_LIBRARIES ${OSS_PREFIX_PATH}/lib/libonnx.a
            ${OSS_PREFIX_PATH}/lib/libonnx_proto.a
            ${OSS_PREFIX_PATH}/lib/libonnxifi.so
            ${OSS_PREFIX_PATH}/lib/libonnxifi_dummy.so
            ${OSS_PREFIX_PATH}/lib/libonnxifi_loader.a)
endif ()
include_directories(${onnx_INCLUDE_DIRS})