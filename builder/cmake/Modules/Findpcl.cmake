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

find_package(eigen3 REQUIRED)
find_package(flann REQUIRED)
set(pcl_libs pcl_common pcl_features pcl_filters pcl_io_ply pcl_io pcl_kdtree pcl_keypoints pcl_ml pcl_octree pcl_outofcore pcl_people pcl_recognition pcl_registration pcl_sample_consensus pcl_search pcl_segmentation
        pcl_stereo
        pcl_surface
        pcl_tracking
        pcl_visualization
        )
find_path(pcl_INCLUDE_DIRS
        NAMES
        pcl/point_cloud.h
        HINTS
        ${OSS_PREFIX_INC_PATH}/pcl-1.9
        )
set(pcl_LIBRARIES)
foreach (pcl_lib IN ITEMS ${pcl_libs})
    find_library(${pcl_lib}_LIBRARIES
            NAMES
            ${pcl_lib}
            HINTS
            ${OSS_PREFIX_LIB_PATH}
            )
    message("${pcl_lib}_LIBRARIES ${${pcl_lib}_LIBRARIES}")
    if (NOT ${pcl_lib}_LIBRARIES STREQUAL "${pcl_lib}_LIBRARIES-NOTFOUND")
        set(pcl_LIBRARIES ${${pcl_lib}_LIBRARIES} ${pcl_LIBRARIES})
    endif ()
endforeach ()

if (NOT ${pcl_INCLUDE_DIRS} STREQUAL "pcl_INCLUDE_DIRS-NOTFOUND")
    set(pcl_FOUND ON)
    message(STATUS "pcl found ${pcl_LIBRARIES}")
    message(STATUS "               ${pcl_INCLUDE_DIRS}")

endif ()