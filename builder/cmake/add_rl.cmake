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

if (TARGET rl)
    set(rl_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(rl_LIBRARIES ${OSS_PREFIX_PATH}/lib/librlhal.so
            ${OSS_PREFIX_PATH}/lib/librlkin.so
            ${OSS_PREFIX_PATH}/lib/librlmdl.so
            ${OSS_PREFIX_PATH}/lib/librlplan.so
            ${OSS_PREFIX_PATH}/lib/librlsg.so
            )
    set(rl_FOUND ON)
    return()
endif ()

#find_package(rl QUIET)
find_package(rl REQUIRED)
if (${rl_FOUND})
    message(STATUS "FOUND rl ${rl_LIBRARIES} ${rl_INCLUDE_DIRS}")
else ()
    include(ExternalProject)
    include(${CMAKE_CURRENT_LIST_DIR}/add_libxslt.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_bullet.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_coin.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_PQP.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_nlopt.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_solid3.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/add_soqt.cmake)
    ExternalProject_Add(
            rl
            GIT_REPOSITORY "https://gitee.com/qq2820/rl.git"
            GIT_TAG "0.7"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""

            SOURCE_DIR "${OSS_SRC_PATH}/rl"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH} -DBUILD_UNIT_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_BENCHMARKS=OFF
            -DBULLET_FOUND=ON -DBULLET_INCLUDE_DIRS=${OSS_PREFIX_PATH}/include/bullet -DBULLET_LIBRARIES==${OSS_PREFIX_PATH}/lib/libBulletSoftBody.so;${OSS_PREFIX_PATH}/lib/libBulletDynamics.so;${OSS_PREFIX_PATH}/lib/BulletCollision.so;${OSS_PREFIX_PATH}/lib/libLinearMath.so

            TEST_COMMAND ""
    )
    if (TARGET libxslt)
        ExternalProject_Add_StepDependencies(rl build libxslt)
    endif ()
    if (TARGET nlopt)
        ExternalProject_Add_StepDependencies(rl build nlopt)
    endif ()
    if (TARGET coin)
        ExternalProject_Add_StepDependencies(rl build coin)
    endif ()
    if (TARGET PQP)
        ExternalProject_Add_StepDependencies(rl build PQP)
    endif ()
    if (TARGET bullet)
        ExternalProject_Add_StepDependencies(rl build bullet)
    endif ()
    if (TARGET solid3)
        ExternalProject_Add_StepDependencies(rl build solid3)
    endif ()
    if (TARGET soqt)
        ExternalProject_Add_StepDependencies(rl build soqt)
    endif ()
    set(rl_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(rl_LIBRARIES ${OSS_PREFIX_PATH}/lib/librlhal.so
            ${OSS_PREFIX_PATH}/lib/librlkin.so
            ${OSS_PREFIX_PATH}/lib/librlmdl.so
            ${OSS_PREFIX_PATH}/lib/librlplan.so
            ${OSS_PREFIX_PATH}/lib/librlsg.so
            )
    set(rl_FOUND ON)
endif ()

include_directories(${rl_INCLUDE_DIRS})