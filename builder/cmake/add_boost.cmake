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

if (TARGET boost)
    set(boost_FOUND ON)
    set(boost_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(boost_LIBRARIES ${OSS_PREFIX_PATH}/lib/libboost_atomic.so
            ${OSS_PREFIX_PATH}/lib/libboost_chrono.so
            ${OSS_PREFIX_PATH}/lib/libboost_container.so
            ${OSS_PREFIX_PATH}/lib/libboost_context.so
            ${OSS_PREFIX_PATH}/lib/libboost_coroutine.so
            ${OSS_PREFIX_PATH}/lib/libboost_date_time.so
            ${OSS_PREFIX_PATH}/lib/libboost_filesystem.so
            ${OSS_PREFIX_PATH}/lib/libboost_graph.so
            ${OSS_PREFIX_PATH}/lib/libboost_iostreams.so
            ${OSS_PREFIX_PATH}/lib/libboost_locale.so
            ${OSS_PREFIX_PATH}/lib/libboost_log_setup.so
            ${OSS_PREFIX_PATH}/lib/libboost_log.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_c99f.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_c99l.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_c99.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_tr1f.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_tr1l.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_tr1.so
            ${OSS_PREFIX_PATH}/lib/libboost_prg_exec_monitor.so
            ${OSS_PREFIX_PATH}/lib/libboost_program_options.so
            ${OSS_PREFIX_PATH}/lib/libboost_random.so
            ${OSS_PREFIX_PATH}/lib/libboost_regex.so
            ${OSS_PREFIX_PATH}/lib/libboost_serialization.so
            ${OSS_PREFIX_PATH}/lib/libboost_system.so
            ${OSS_PREFIX_PATH}/lib/libboost_thread.so
            ${OSS_PREFIX_PATH}/lib/libboost_timer.so
            ${OSS_PREFIX_PATH}/lib/libboost_type_erasure.so
            ${OSS_PREFIX_PATH}/lib/libboost_unit_test_framework.so
            ${OSS_PREFIX_PATH}/lib/libboost_wave.so
            ${OSS_PREFIX_PATH}/lib/libboost_wserialization.so
            )
    return()
endif ()
find_package(boost QUIET)
if (NOT ${boost_FOUND})
    include(ExternalProject)
    ExternalProject_Add(
            boost
            GIT_REPOSITORY "https://gitee.com/christ_2014/boost.git"
            GIT_TAG "1.66.0"
            UPDATE_COMMAND ""
            CONFIGURE_COMMAND cd ${OSS_SRC_PATH}/boost && ./bootstrap.sh --prefix=${OSS_PREFIX_PATH} --without-libraries=python
            BUILD_COMMAND cd ${OSS_SRC_PATH}/boost && ./b2 cxxflags='-g' -j2
            INSTALL_COMMAND cd ${OSS_SRC_PATH}/boost && ./b2 install
            SOURCE_DIR "${OSS_SRC_PATH}/boost"
    )

    set(boost_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(boost_LIBRARIES ${OSS_PREFIX_PATH}/lib/libboost_atomic.so
            ${OSS_PREFIX_PATH}/lib/libboost_chrono.so
            ${OSS_PREFIX_PATH}/lib/libboost_container.so
            ${OSS_PREFIX_PATH}/lib/libboost_context.so
            ${OSS_PREFIX_PATH}/lib/libboost_coroutine.so
            ${OSS_PREFIX_PATH}/lib/libboost_date_time.so
            ${OSS_PREFIX_PATH}/lib/libboost_filesystem.so
            ${OSS_PREFIX_PATH}/lib/libboost_graph.so
            ${OSS_PREFIX_PATH}/lib/libboost_iostreams.so
            ${OSS_PREFIX_PATH}/lib/libboost_locale.so
            ${OSS_PREFIX_PATH}/lib/libboost_log_setup.so
            ${OSS_PREFIX_PATH}/lib/libboost_log.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_c99f.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_c99l.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_c99.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_tr1f.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_tr1l.so
            ${OSS_PREFIX_PATH}/lib/libboost_math_tr1.so
            ${OSS_PREFIX_PATH}/lib/libboost_prg_exec_monitor.so
            ${OSS_PREFIX_PATH}/lib/libboost_program_options.so
            ${OSS_PREFIX_PATH}/lib/libboost_random.so
            ${OSS_PREFIX_PATH}/lib/libboost_regex.so
            ${OSS_PREFIX_PATH}/lib/libboost_serialization.so
            ${OSS_PREFIX_PATH}/lib/libboost_system.so
            ${OSS_PREFIX_PATH}/lib/libboost_thread.so
            ${OSS_PREFIX_PATH}/lib/libboost_timer.so
            ${OSS_PREFIX_PATH}/lib/libboost_type_erasure.so
            ${OSS_PREFIX_PATH}/lib/libboost_unit_test_framework.so
            ${OSS_PREFIX_PATH}/lib/libboost_wave.so
            ${OSS_PREFIX_PATH}/lib/libboost_wserialization.so
            )
endif ()
include_directories(${boost_INCLUDE_DIRS})
