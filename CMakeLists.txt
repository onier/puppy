cmake_minimum_required(VERSION 3.16)
#opensource code local directory
set(OSS_SRC_PATH ${CMAKE_SOURCE_DIR}/oss/src)
#opensource code local install directory
set(OSS_PREFIX_PATH ${CMAKE_SOURCE_DIR}/install/x64-install/oss/)
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/builder/cmake ${PROJECT_SOURCE_DIR}/builder/cmake/Modules ${CMAKE_MODULE_PATH})
set(CMAKE_CXX_STANDARD 11)
include(depends)