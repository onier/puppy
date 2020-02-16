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

 set(vtk_libs vtkChartsCore-8.2
         vtkCommonColor-8.2
         vtkCommonComputationalGeometry-8.2
         vtkCommonCore-8.2
         vtkCommonDataModel-8.2
         vtkCommonExecutionModel-8.2
         vtkCommonMath-8.2
         vtkCommonMisc-8.2
         vtkCommonSystem-8.2
         vtkCommonTransforms-8.2
         vtkDICOMParser-8.2
         vtkDomainsChemistry-8.2
         vtkDomainsChemistryOpenGL2-8.2
         vtkdoubleconversion-8.2
         vtkexodusII-8.2
         vtkexpat-8.2
         vtkFiltersAMR-8.2
         vtkFiltersCore-8.2
         vtkFiltersExtraction-8.2
         vtkFiltersFlowPaths-8.2
         vtkFiltersGeneral-8.2
         vtkFiltersGeneric-8.2
         vtkFiltersGeometry-8.2
         vtkFiltersHybrid-8.2
         vtkFiltersHyperTree-8.2
         vtkFiltersImaging-8.2
         vtkFiltersModeling-8.2
         vtkFiltersParallel-8.2
         vtkFiltersParallelImaging-8.2
         vtkFiltersPoints-8.2
         vtkFiltersProgrammable-8.2
         vtkFiltersSelection-8.2
         vtkFiltersSMP-8.2
         vtkFiltersSources-8.2
         vtkFiltersStatistics-8.2
         vtkFiltersTexture-8.2
         vtkFiltersTopology-8.2
         vtkFiltersVerdict-8.2
         vtkfreetype-8.2
         vtkGeovisCore-8.2
         vtkgl2ps-8.2
         vtkglew-8.2
         vtkGUISupportQt-8.2
         vtkGUISupportQtSQL-8.2
         vtkhdf5-8.2
         vtkhdf5_hl-8.2
         vtkImagingColor-8.2
         vtkImagingCore-8.2
         vtkImagingFourier-8.2
         vtkImagingGeneral-8.2
         vtkImagingHybrid-8.2
         vtkImagingMath-8.2
         vtkImagingMorphological-8.2
         vtkImagingSources-8.2
         vtkImagingStatistics-8.2
         vtkImagingStencil-8.2
         vtkInfovisCore-8.2
         vtkInfovisLayout-8.2
         vtkInteractionImage-8.2
         vtkInteractionStyle-8.2
         vtkInteractionWidgets-8.2
         vtkIOAMR-8.2
         vtkIOAsynchronous-8.2
         vtkIOCityGML-8.2
         vtkIOCore-8.2
         vtkIOEnSight-8.2
         vtkIOExodus-8.2
         vtkIOExport-8.2
         vtkIOExportOpenGL2-8.2
         vtkIOExportPDF-8.2
         vtkIOGeometry-8.2
         vtkIOImage-8.2
         vtkIOImport-8.2
         vtkIOInfovis-8.2
         vtkIOLegacy-8.2
         vtkIOLSDyna-8.2
         vtkIOMINC-8.2
         vtkIOMovie-8.2
         vtkIONetCDF-8.2
         vtkIOParallel-8.2
         vtkIOParallelXML-8.2
         vtkIOPLY-8.2
         vtkIOSegY-8.2
         vtkIOSQL-8.2
         vtkIOTecplotTable-8.2
         vtkIOVeraOut-8.2
         vtkIOVideo-8.2
         vtkIOXML-8.2
         vtkIOXMLParser-8.2
         vtkjpeg-8.2
         vtkjsoncpp-8.2
         vtklibharu-8.2
         vtklibxml2-8.2
         vtklz4-8.2
         vtklzma-8.2
         vtkmetaio-8.2
         vtkNetCDF-8.2
         vtkogg-8.2
         vtkParallelCore-8.2
         vtkpng-8.2
         vtkproj-8.2
         vtkpugixml-8.2
         vtkRenderingAnnotation-8.2
         vtkRenderingContext2D-8.2
         vtkRenderingContextOpenGL2-8.2
         vtkRenderingCore-8.2
         vtkRenderingFreeType-8.2
         vtkRenderingGL2PSOpenGL2-8.2
         vtkRenderingImage-8.2
         vtkRenderingLabel-8.2
         vtkRenderingLOD-8.2
         vtkRenderingOpenGL2-8.2
         vtkRenderingQt-8.2
         vtkRenderingVolume-8.2
         vtkRenderingVolumeOpenGL2-8.2
         vtksqlite-8.2
         vtksys-8.2
         vtktheora-8.2
         vtktiff-8.2
         vtkverdict-8.2
         vtkViewsContext2D-8.2
         vtkViewsCore-8.2
         vtkViewsInfovis-8.2
         vtkViewsQt-8.2
         vtkzlib-8.2
         )
 find_path(vtk_INCLUDE_DIRS
         NAMES
         vtkSmartPointer.h
         HINTS
         ${OSS_PREFIX_INC_PATH}/vtk-8.2
         )
 set(vtk_LIBRARIES)
 foreach (vtk_lib IN ITEMS ${vtk_libs})
     find_library(${vtk_lib}_LIBRARIES
             NAMES
             ${vtk_lib}
             HINTS
             ${OSS_PREFIX_LIB_PATH}
             )
     message("${vtk_lib}_LIBRARIES ${${vtk_lib}_LIBRARIES}")
     if (NOT ${vtk_lib}_LIBRARIES STREQUAL "${vtk_lib}_LIBRARIES-NOTFOUND")
         set(vtk_LIBRARIES ${${vtk_lib}_LIBRARIES} ${vtk_LIBRARIES})
     endif ()
 endforeach ()
 if (NOT ${vtk_INCLUDE_DIRS} STREQUAL "vtk_INCLUDE_DIRS-NOTFOUND")
     set(vtk_FOUND ON)
     message(STATUS "vtk found ${vtk_LIBRARIES}")
     message(STATUS "               ${vtk_INCLUDE_DIRS}")

 endif ()