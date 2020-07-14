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

add_definitions("-fext-numeric-literals")
#CMP0087 NEW用于指定ExternalProject_Add 默认不更新任何git子模块，必须依赖3.15版本。
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/data)
    file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/data/ DESTINATION ${CMAKE_BINARY_DIR}/out/data/)
endif ()
file(RELATIVE_PATH PROJECT_PATH ${PROJECT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
string(REPLACE "/" "" CURRENT_PROJECT_NAME ${PROJECT_PATH})
project(${CURRENT_PROJECT_NAME})
message(STATUS "current project name is ${PROJECT_NAME}")
#获取当前项目的目录文件名
cmake_policy(SET CMP0097 NEW)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fopenmp -std=c++11 -pthread")

#编译的库和进程的输出目录
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/bin)

#开源代码的库路径和头文件路径
set(OSS_PREFIX_LIB_PATH ${OSS_PREFIX_PATH}/lib)
set(OSS_PREFIX_INC_PATH ${OSS_PREFIX_PATH}/include)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Modules ${CMAKE_MODULE_PATH})

#qt的安装目录
set(QT_ROOT /opt/Qt5.14.1/5.14.1/gcc_64)
set(Qt5Core_DIR ${QT_ROOT}/lib/cmake/Qt5Core)
set(Qt5_DIR ${QT_ROOT}/lib/cmake/Qt5)
set(QT_QMAKE_EXECUTABLE ${QT_ROOT}/bin/qmake)
set(CMAKE_PREFIX_PATH ${QT_ROOT}/lib/cmake)

#添加当前项目的include
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
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

#遍历依赖关系，如果不是源码编译目录或者是pkgconfig找到的依赖，那么就会调用add_xxx.cmake添加依赖，并将这些库依赖关系加到对应的变量中区。
if (PKGCONFIG_FOUND)
    foreach (_dep IN ITEMS ${DEPENDS})
        string(LENGTH "${_dep}" _dep_len)
        if ("${_dep_len}" GREATER 0)
            string(REPLACE "." "/" _dep_path ${_dep})
            if (IS_DIRECTORY ${CMAKE_SOURCE_DIR}/${_dep} AND EXISTS ${CMAKE_SOURCE_DIR}/${_dep}/CMakeLists.txt)
                message(STATUS "FOUND ${_dep} as target ")
                set(${PROJECT_NAME}_DEP_LIBRARIES ${_dep} ${${PROJECT_NAME}_DEP_LIBRARIES})
            elseif (IS_DIRECTORY ${CMAKE_SOURCE_DIR}/${_dep_path} AND EXISTS ${CMAKE_SOURCE_DIR}/${_dep_path}/CMakeLists.txt)
                string(REPLACE "." "" _dep_lib ${_dep})
                set(${PROJECT_NAME}_DEP_LIBRARIES ${_dep_lib} ${${PROJECT_NAME}_DEP_LIBRARIES})
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

#添加依赖头文件路径
include_directories(${${PROJECT_NAME}_DEP_INCLUDE_DIRS})
