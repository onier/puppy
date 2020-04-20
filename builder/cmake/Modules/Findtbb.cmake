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

unset(tbb_LIBRARIES)
find_library(tbb_LIBRARIES
        NAMES
        tbb tbbmalloc
        HINTS
        ${OSS_PREFIX_LIB_PATH}
        )

find_library(tbbmalloc_LIBRARIES
        NAMES
        tbbmalloc
        HINTS
        ${OSS_PREFIX_LIB_PATH}
        )

find_path(tbb_INCLUDE_DIRS
        NAMES
        tbb/tbb.h
        HINTS
        ${OSS_PREFIX_INC_PATH}
        )
if ("${tbb_LIBRARIES}" STREQUAL "tbb_LIBRARIES-NOTFOUND" OR "${tbb_INCLUDE_DIRS}" STREQUAL "tbb_INCLUDE_DIRS-NOTFOUND")
    set(tbb_FOUND OFF)
    set(tbb_LIBRARIES)
    set(tbb_INCLUDE_DIR)
else ()
    set(tbb_FOUND ON)
    set(tbb_LIBRARIES ${tbbmalloc_LIBRARIES} ${tbb_LIBRARIES})
endif ()
