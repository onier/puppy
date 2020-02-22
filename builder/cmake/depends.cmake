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

#解析子目录的CMakeLists文件里定义的DEPENDS，根据依赖调用add_subdirectory()
file(GLOB SUBDIRS RELATIVE ${PROJECT_SOURCE_DIR}/ *)
set(SUB_DIRECOTRIES)
message(STATUS " SUBDIRS ${SUBDIRS}")
foreach (_dir IN ITEMS ${SUBDIRS})
    if (IS_DIRECTORY ${PROJECT_SOURCE_DIR}/${_dir} AND EXISTS ${PROJECT_SOURCE_DIR}/${_dir}/CMakeLists.txt)
        list(APPEND SUB_DIRECOTRIES ${_dir})
        set(${_dir}_DEP_SUBDIRS)
        FILE(READ "${PROJECT_SOURCE_DIR}/${_dir}/CMakeLists.txt" contents)
        string(FIND ${contents} "set(DEPENDS" out)
        string(LENGTH ${contents} _len)
        if (NOT ${out} EQUAL -1)
            math(EXPR _length "${_len}-${out}")
            math(EXPR out "${out}+11")
            string(SUBSTRING ${contents} ${out} ${_length} tempStr)
            string(FIND ${tempStr} ")" out)
            string(SUBSTRING ${tempStr} 0 ${out} tempStr)
            string(REPLACE " " ";" _list "${tempStr}")

            foreach (_item IN ITEMS ${_list})
                if (IS_DIRECTORY ${PROJECT_SOURCE_DIR}/${_item} AND EXISTS ${PROJECT_SOURCE_DIR}/${_dir}/CMakeLists.txt)
                    list(APPEND ${_dir}_DEP_SUBDIRS ${_item})
                endif ()
            endforeach ()
        endif ()
    endif ()
endforeach ()

function(addDir _dir)
    if (NOT TARGET ${_dir})
        message(STATUS "add_subdirectory ${_dir}")
        add_subdirectory(${_dir})
    endif ()
endfunction()

foreach (_com IN ITEMS ${SUB_DIRECOTRIES})
    message(STATUS "${_com} ${${_com}_DEP_SUBDIRS}")
    foreach(_dir IN ITEMS ${${_com}_DEP_SUBDIRS})
        addDir(${_dir})
    endforeach()
    addDir(${_com})
endforeach ()