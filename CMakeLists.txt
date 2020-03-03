cmake_minimum_required(VERSION 3.16)
#开源代码本地目录
set(OSS_SRC_PATH ../oss/src)
#安装目录
set(OSS_PREFIX_PATH ${CMAKE_SOURCE_DIR}/install/x64-install/oss/)
#cmake资源路径
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/builder/cmake ${PROJECT_SOURCE_DIR}/builder/cmake/Modules ${CMAKE_MODULE_PATH})
set(CMAKE_CXX_STANDARD 11)
#根据项目依赖添加项目目录
include(depends)
