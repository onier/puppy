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

set(VTK_LIBS ${OSS_PREFIX_PATH}/lib/libvtkChartsCore-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkCommonColor-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkCommonComputationalGeometry-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkCommonCore-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkCommonDataModel-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkCommonExecutionModel-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkCommonMath-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkCommonMisc-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkCommonSystem-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkCommonTransforms-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkDICOMParser-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkDomainsChemistry-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkDomainsChemistryOpenGL2-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkdoubleconversion-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkexodusII-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkexpat-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersAMR-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersCore-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersExtraction-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersFlowPaths-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersGeneral-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersGeneric-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersGeometry-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersHybrid-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersHyperTree-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersImaging-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersModeling-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersParallel-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersParallelImaging-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersPoints-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersProgrammable-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersSelection-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersSMP-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersSources-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersStatistics-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersTexture-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersTopology-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkFiltersVerdict-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkfreetype-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkGeovisCore-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkgl2ps-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkglew-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkGUISupportQt-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkGUISupportQtSQL-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkhdf5-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkhdf5_hl-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkImagingColor-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkImagingCore-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkImagingFourier-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkImagingGeneral-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkImagingHybrid-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkImagingMath-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkImagingMorphological-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkImagingSources-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkImagingStatistics-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkImagingStencil-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkInfovisCore-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkInfovisLayout-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkInteractionImage-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkInteractionStyle-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkInteractionWidgets-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOAMR-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOAsynchronous-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOCityGML-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOCore-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOEnSight-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOExodus-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOExport-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOExportOpenGL2-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOExportPDF-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOGeometry-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOImage-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOImport-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOInfovis-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOLegacy-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOLSDyna-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOMINC-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOMovie-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIONetCDF-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOParallel-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOParallelXML-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOPLY-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOSegY-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOSQL-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOTecplotTable-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOVeraOut-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOVideo-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOXML-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkIOXMLParser-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkjpeg-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkjsoncpp-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtklibharu-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtklibxml2-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtklz4-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtklzma-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkmetaio-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkNetCDF-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkogg-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkParallelCore-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkpng-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkproj-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkpugixml-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingAnnotation-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingContext2D-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingContextOpenGL2-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingCore-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingFreeType-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingGL2PSOpenGL2-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingImage-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingLabel-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingLOD-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingOpenGL2-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingQt-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingVolume-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkRenderingVolumeOpenGL2-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtksqlite-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtksys-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtktheora-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtktiff-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkverdict-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkViewsContext2D-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkViewsCore-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkViewsInfovis-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkViewsQt-8.2.so
        ${OSS_PREFIX_PATH}/lib/libvtkzlib-8.2.so
        )
if (TARGET vtk)
    set(vtk_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include/vtk-8.2/")
    set(vtk_LIBRARIES ${VTK_LIBS})
    set(vtk_FOUND ON)
    return()
endif ()
find_package(vtk QUIET)
if (${vtk_FOUND})
    message(STATUS "FOUND vtk ${vtk_LIBRARIES} ${vtk_INCLUDE_DIRS}")
else ()
    include(${CMAKE_CURRENT_LIST_DIR}/add_tbb.cmake)
    include(ExternalProject)
    ExternalProject_Add(
            vtk
            GIT_REPOSITORY "https://gitee.com/qq2820/VTK.git"
            GIT_TAG "v8.2.0"
            UPDATE_COMMAND ""
            GIT_SUBMODULES ""
            PATCH_COMMAND ""

            SOURCE_DIR "${OSS_SRC_PATH}/vtk"
            CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${OSS_PREFIX_PATH} -DBUILD_TESTING=off -DQt5_DIR=${QT_ROOT}/lib/cmake/Qt5
    -DQT_QMAKE_EXECUTABLE:PATH=${QT_ROOT}/bin/qmake -DVTK_Group_Qt:BOOL=ON -DVTK_QT_VERSION=5 -DVTK_SMP_IMPLEMENTATION_TYPE=TBB -DTBB_INCLUDE_DIRS=${OSS_PREFIX_PATH}/include -DTBB_LIBRARIES="-ltbb;-ltbbmalloc"
    -DModule_PoissonReconstruction:BOOL=ON
            TEST_COMMAND ""
    )
    if (TARGET tbb)
        ExternalProject_Add_StepDependencies(vtk build tbb)
    endif ()
    set(vtk_INCLUDE_DIRS "${OSS_PREFIX_PATH}/include/vtk-8.2/")
    set(vtk_LIBRARIES ${VTK_LIBS})
endif ()

include_directories(${vtk_INCLUDE_DIRS})