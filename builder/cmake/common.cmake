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

cmake_policy(SET CMP0097 NEW)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pthread")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/bin)
set(OSS_PREFIX_LIB_PATH ${OSS_PREFIX_PATH}/lib)
set(OSS_PREFIX_INC_PATH ${OSS_PREFIX_PATH}/include)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Modules ${CMAKE_MODULE_PATH})
set(QT_ROOT /opt/Qt5.14.1/5.14.1/gcc_64/)
set(Qt5Core_DIR ${QT_ROOT}/lib/cmake/Qt5Core)
set(Qt5_DIR ${QT_ROOT}/lib/cmake/Qt5)
set(QT_QMAKE_EXECUTABLE ${QT_ROOT}/bin/qmake)
set(CMAKE_PREFIX_PATH ${QT_ROOT}/lib/cmake)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
get_filename_component(ProjectId ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "_" ProjectId ${ProjectId})
project(${ProjectId})
file(GLOB_RECURSE ${PROJECT_NAME}_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/src/*)
file(GLOB_RECURSE ${PROJECT_NAME}_INCS ${CMAKE_CURRENT_SOURCE_DIR}/include/*)
list(LENGTH ${PROJECT_NAME}_INCS INCS_LENGTH)
list(LENGTH ${PROJECT_NAME}_SRCS SRCS_LENGTH)
set(${PROJECT_NAME}_VERSION "3")

set(${PROJECT_NAME}_DEP_LIBRARIES)
set(${PROJECT_NAME}_DEP_TARGETS)
set(${PROJECT_NAME}_DEP_LIBRARY_DIRS)
set(${PROJECT_NAME}_DEP_INCLUDE_DIRS)
find_package(PkgConfig)
if (PKGCONFIG_FOUND)
    foreach (_dep IN ITEMS ${DEPENDS})
        string(LENGTH "${_dep}" _dep_len)
        if ("${_dep_len}" GREATER 0)
            if (IS_DIRECTORY ${CMAKE_SOURCE_DIR}/${_dep} AND EXISTS ${CMAKE_SOURCE_DIR}/${_dep}/CMakeLists.txt)
                message(STATUS "FOUND ${_dep} as target ")
                set(${PROJECT_NAME}_DEP_LIBRARIES ${_dep} ${${PROJECT_NAME}_DEP_LIBRARIES})
            else ()
                pkg_search_module(${_dep} ${_dep})
                if (${_dep}_FOUND)
                    message(STATUS "FOUND ${_dep} as pkgconfig")
                    message(STATUS "    libraries ${${_dep}_LIBRARIES}")
                    message(STATUS "        libraries ${${_dep}_LIBRARY_DIRS}")
                    message(STATUS "    libraries ${${_dep}_INCLUDE_DIRS}")
                    set(${PROJECT_NAME}_DEP_LIBRARIES ${${_dep}_LIBRARIES} ${${PROJECT_NAME}_DEP_LIBRARIES})
                    set(${PROJECT_NAME}_DEP_LIBRARY_DIRS ${${_dep}_LIBRARY_DIRS} ${${PROJECT_NAME}_DEP_LIBRARY_DIRS})
                    set(${PROJECT_NAME}_DEP_INCLUDE_DIRS ${${_dep}_INCLUDE_DIRS} ${${PROJECT_NAME}_DEP_INCLUDE_DIRS})
                else ()
                    message(STATUS "include ${CMAKE_CURRENT_LIST_DIR}/add_${_dep}.cmake")
#                    include(${CMAKE_CURRENT_LIST_DIR}/add_${_dep}.cmake)
                    include(add_${_dep})
                    list(APPEND ${PROJECT_NAME}_DEP_TARGETS ${_dep})
                    set(${PROJECT_NAME}_DEP_LIBRARIES ${${_dep}_LIBRARIES} ${${PROJECT_NAME}_DEP_LIBRARIES})
                    set(${PROJECT_NAME}_DEP_INCLUDE_DIRS ${${_dep}_INCLUDE_DIRS} ${${PROJECT_NAME}_DEP_INCLUDE_DIRS})
                endif ()
            endif ()
        endif ()
    endforeach ()
endif ()
include_directories(${${PROJECT_NAME}_DEP_INCLUDE_DIRS})