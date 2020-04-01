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
# LIABILITY, WHETHER IN AN hACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

unset(bullet_LIBRARIES)

find_library(bullet_LIBRARIES
        NAMES
        BulletSoftBody
        HINTS
        ${OSS_PREFIX_LIB_PATH}
        )
find_path(bullet_INCLUDE_DIRS
        NAMES
        bullet/SharedMemoryPublic.h
        HINTS
        ${OSS_PREFIX_INC_PATH}
        )
message(STATUS "${bullet_LIBRARIES} ")
message(STATUS "${bullet_INCLUDE_DIRS} ")
if (${bullet_LIBRARIES} STREQUAL "bullet_LIBRARIES-NOTFOUND" OR ${bullet_INCLUDE_DIRS} STREQUAL "bullet_INCLUDE_DIRS-NOTFOUND")
    set(bullet_FOUND OFF)
    set(bullet_LIBRARIES)
    set(bullet_INCLUDE_DIR)
else ()
    set(bullet_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(bullet_LIBRARIES ${OSS_PREFIX_PATH}/lib/libBulletSoftBody.so
            ${OSS_PREFIX_PATH}/lib/libBulletDynamics.so
            ${OSS_PREFIX_PATH}/lib/libBulletCollision.so
            ${OSS_PREFIX_PATH}/lib/libLinearMath.so )
    set(bullet_FOUND ON)
endif ()