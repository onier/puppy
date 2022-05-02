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

if (TARGET opencv)
    return()
endif ()
find_package(opencv QUIET)
set(OpenCV_INSTALL_PATH  ${OSS_PREFIX_PATH})
set(OpenCV_DIR ${OSS_PREFIX_PATH}/lib/cmake/opencv4/)
find_package(OpenCV 4.5.0 QUIET)
if (${OpenCV_FOUND})
    message(STATUS "FOUND OpenCV ${OpenCV_VERSION} ${OpenCV_LIBRARIES}  ${OpenCV_INCLUDE_DIRS}")
    set(opencv_LIBRARIES ${OpenCV_LIBRARIES})
    set(opencv_INCLUDE_DIRS ${OpenCV_INCLUDE_DIRS})
    set(opencv_FOUND ${OpenCV_FOUND})
else ()
    include(ExternalProject)
    if (NOT EXISTS "${OSS_SRC_PATH}/opencv-contrib")

        execute_process(
                COMMAND
                git clone https://gitee.com/qq2820/opencv_contrib.git -b 4.5.0 ${OSS_SRC_PATH}/opencv-contrib
        )
    endif()
    ExternalProject_Add(
            opencv
            GIT_REPOSITORY "https://gitee.com/qq2820/opencv.git"
            GIT_TAG "4.5.51"

            UPDATE_COMMAND ""
            PATCH_COMMAND ""

            SOURCE_DIR "${OSS_SRC_PATH}/opencv"
	    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH} -DWITH_QT=on -DBUILD_PERF_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_opencv_apps=OFF -DBUILT_TESTS=OFF
	    -DCMAKE_PREFIX_PATH=${QT_ROOT}/lib/cmake -DBUILD_UNIT_TESTS=OFF -DRAPIDJSON_BUILD_EXAMPLES=OFF -DBUILD_opencv_tracking=OFF
            -DQt5Core_DIR=${QT_ROOT}/lib/cmake/Qt5Core -DQt5_DIR=${QT_ROOT}/lib/cmake/Qt5 -DQT_QMAKE_EXECUTABLE=${QT_ROOT}/${QT_ROOT}/bin/qmake -DOPENCV_EXTRA_MODULES_PATH=${OSS_SRC_PATH}/opencv-contrib/modules

            TEST_COMMAND ""
    )

    set(opencv_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include")
    set(opencv_LIBRARIES "opencv_calib3d;opencv_core;opencv_dnn;opencv_features2d;opencv_flann;opencv_gapi;opencv_highgui;opencv_imgcodecs;opencv_imgproc;opencv_ml;opencv_objdetect;opencv_photo;opencv_stitching;opencv_video;opencv_videoio;opencv_aruco;opencv_bgsegm;opencv_bioinspired;opencv_ccalib;opencv_cvv;opencv_datasets;opencv_dnn_objdetect;opencv_dpm;opencv_face;opencv_fuzzy;opencv_hfs;opencv_img_hash;opencv_line_descriptor;opencv_optflow;opencv_phase_unwrapping;opencv_plot;opencv_quality;opencv_reg;opencv_rgbd;opencv_saliency;opencv_shape;opencv_stereo;opencv_structured_light;opencv_superres;opencv_surface_matching;opencv_text;opencv_tracking;opencv_videostab;opencv_viz;opencv_ximgproc;opencv_xobjdetect;opencv_xphoto")
endif ()
include_directories(${zmq_INCLUDE_DIRS})
