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

unset(libzmq_LIBRARIES)

find_library(libzmq_LIBRARIES
        NAMES
        zmq
        HINTS
        ${OSS_PREFIX_LIB_PATH}
        )
find_path(libzmq_INCLUDE_DIRS
        NAMES
        zmq.h
        HINTS
        ${OSS_PREFIX_INC_PATH}
        )
if (${libzmq_LIBRARIES} STREQUAL "libzmq_LIBRARIES-NOTFOUND" OR ${libzmq_INCLUDE_DIRS} STREQUAL "libzmq_INCLUDE_DIRS-NOTFOUND")
    set(libzmq_FOUND OFF)
    set(libzmq_LIBRARIES)
    set(libzmq_INCLUDE_DIR)
else ()
    set(libzmq_FOUND ON)
endif ()