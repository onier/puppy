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

if (TARGET openssl)
    set(openssl_FOUND ON)
    set(openssl_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(openssl_LIBRARIES)
    return()
endif ()
find_package(openssl QUIET)
if (NOT ${openssl_FOUND})
    include(ExternalProject)
    ExternalProject_Add(
            openssl
            GIT_REPOSITORY "https://gitee.com/qq2820/openssl.git"
            GIT_TAG "OpenSSL_1_1_1-stable"
            UPDATE_COMMAND ""
            GIT_SUBMODULES ""
            CONFIGURE_COMMAND cd ${OSS_SRC_PATH}/openssl && ./config --prefix=${OSS_PREFIX_PATH}
            BUILD_COMMAND cd ${OSS_SRC_PATH}/openssl && make -j2
            INSTALL_COMMAND cd ${OSS_SRC_PATH}/openssl && make install
            SOURCE_DIR "${OSS_SRC_PATH}/openssl"
    )

    set(openssl_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(openssl_LIBRARIES)
endif ()
include_directories(${openssl_INCLUDE_DIRS})