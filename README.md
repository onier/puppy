# puppy
#### 概述
项目为一个cmake编译工程的项目，会自动下载对应开源项目源码进行编译编译。目前支持azmq sqlitecpp kdl boost eigen3  flann glog opencv pcl rapidjson rttr tbb vtk assimp bullet coin fck flann kdl libccd libxslt mstch nlopt odb ode ompl pqp rapidjson rl solid3等。

开源项目版本可以查看对应的add_xxx.cmake文件内的GIT_TAG号。目前只支持cmake 3.16版本，低版本支持有问题。

编译工程需要QT的支持可以前往 [下载QT](http://iso.mirrors.ustc.edu.cn/qtproject/archive/qt/5.14/5.14.1/qt-opensource-linux-x64-5.14.1.run),安装完毕之后修改[common.cmake中定义的QT_ROOT](https://gitee.com/qq2820/puppy/blob/master/builder/cmake/common.cmake)
#### 使用说明 

. setup.sh

mkdir build

cd build 

cmake .. -

make 

第一次编译需要联网下载对应的开源代码编译，根据你使用的库可能需要比较长的编译时间请耐心等待.

#### Demo项目 
 [Process](https://github.com/onier/Process/tree/master)   插件化的流程管理软件。
 
 
 [Duck](https://github.com/onier/Duck/tree/master)   插件化的流程管理软件。
 
 
 
 
 
 
