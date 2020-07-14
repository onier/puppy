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

include(${CMAKE_CURRENT_LIST_DIR}/common.cmake)

if ("${SRCS_LENGTH}" GREATER 0)
    message(STATUS "create dynamic library ${PROJECT_NAME}")
    list(LENGTH QT_LIBS QT_LIBS_LEN)
    if (${QT_LIBS_LEN} GREATER 0)
        find_package(Qt5Core REQUIRED)

        ADD_DEFINITIONS("-DQT_DISABLE_DEPRECATED_BEFORE=0")
        ADD_DEFINITIONS("-DQT_NO_DEBUG")
        ADD_DEFINITIONS("-DQT_WIDGETS_LIB")
        ADD_DEFINITIONS("-DQT_GUI_LIB")
        ADD_DEFINITIONS("-DQT_CORE_LIB")
        set(CMAKE_AUTOMOC ON)
        set(CMAKE_AUTOUIC ON)

        file(GLOB_RECURSE QRC src/*.qrc)
        qt5_add_resources(QRCS ${QRC})
        add_executable(${PROJECT_NAME} ${${PROJECT_NAME}_SRCS} ${${PROJECT_NAME}_INCS} ${QRCS})
        target_link_libraries(${PROJECT_NAME} ${${PROJECT_NAME}_DEP_LIBRARIES})
        foreach (_qt_lib IN ITEMS ${QT_LIBS})
            find_package(${_qt_lib} REQUIRED)
            include_directories(${${_qt_lib}_INCLUDE_DIRS})
            target_link_libraries(${PROJECT_NAME} ${${_qt_lib}_LIBRARIES})
        endforeach ()
    else ()
        CUDA_ADD_EXECUTABLE(${PROJECT_NAME} ${${PROJECT_NAME}_SRCS} ${${PROJECT_NAME}_INCS})
        target_link_libraries(${PROJECT_NAME} ${${PROJECT_NAME}_DEP_LIBRARIES})
    endif ()
    foreach (_target IN ITEMS ${${PROJECT_NAME}_DEP_TARGETS})
        if (TARGET ${_target})
            add_dependencies(${PROJECT_NAME} ${_target})
        endif ()
    endforeach ()
endif ()

#include(test)