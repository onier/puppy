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

unset(libccd_LIBRARIES)

find_library(libccd_LIBRARIES
        NAMES
        libccdd
        HINTS
        ${OSS_PREFIX_LIB_PATH}
        )
find_path(libccd_INCLUDE_DIRS
        NAMES
       libccd/aabb.h
        HINTS
        ${OSS_PREFIX_INC_PATH}
        )

if (${libccd_LIBRARIES} STREQUAL "libccd_LIBRARIES-NOTFOUND" OR ${libccd_INCLUDE_DIRS} STREQUAL "libccd_INCLUDE_DIRS-NOTFOUND")
    set(libccd_FOUND OFF)
    set(libccd_LIBRARIES)
    set(libccd_INCLUDE_DIR)
else ()
    set(libccd_FOUND ON)
endif ()
