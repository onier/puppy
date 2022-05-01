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

if (TARGET protobuf)
    set(protobuf_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(protobuf_LIBRARIES "${OSS_PREFIX_PATH}/lib/libprotobuf.so")
    set(protobuf_FOUND ON)
    return()
endif ()
if (EXISTS ${OSS_PREFIX_PATH}/inlude/google)
    FIND_PACKAGE(protobuf REQUIRED)
    INCLUDE_DIRECTORIES(${PROTOBUF_INCLUDE_DIR})
else ()
    set(protobuf_FOUND OFF)
endif ()
if (${protobuf_FOUND})
    message(STATUS "FOUND protobufxxxxxxxxx  ${protobuf_LIBRARIES}  ${protobuf_INCLUDE_DIRS}")
else ()
    include(ExternalProject)
    ExternalProject_Add(
            protobuf
            GIT_REPOSITORY "https://gitee.com/qq2820/protobuf.git"
            GIT_TAG "v3.19.1"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""
            GIT_SUBMODULES ""
            SOURCE_DIR "${OSS_SRC_PATH}/protobuf"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}  -S ${OSS_SRC_PATH}/protobuf/cmake -B ./ -DBUILD_SHARED_LIBS=ON -Dprotobuf_DEBUG_POSTFIX= -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH}

            TEST_COMMAND ""
    )
    set(protobuf_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(protobuf_LIBRARIES "${OSS_PREFIX_PATH}/lib/libprotobuf.so")
    set(protobuf_FOUND ON)
endif ()
include_directories(${zmq_INCLUDE_DIRS})
