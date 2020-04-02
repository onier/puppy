# puppy
#### 概述
项目为一个cmake编译工程的项目，会自动下载对应开源项目源码进行编译编译。目前支持azmq sqlitecpp kdl boost eigen3  flann glog opencv pcl rapidjson rttr tbb vtk assimp bullet coin fck flann kdl libccd libxslt mstch nlopt odb ode ompl pqp rapidjson rl solid3等。

开源项目版本可以查看对应的add_xxx.cmake文件内的GIT_TAG号。目前只支持cmake 3.16版本，低版本支持有问题，如果使用clion请在File | Settings | Build, Execution, Deployment | Toolchains 选择项目中的builder/cmake-3.16.4-Linux-x86_64/bin/cmake切换cmake，在运行的时候添加oss/lib到LD_LIBRARY_PATH，否则可能找不到库。
![输入图片说明](https://gitee.com/qq2820/puppy/blob/master/builder/clion.png "在这里输入图片标题")
目前支持ubuntu18系统，其他系统没有测试，可能有错误如果有错误欢迎在 [issues](https://gitee.com/qq2820/puppy/issues "With a Title")里提出。

编译工程需要QT的支持可以前往 [下载QT](http://iso.mirrors.ustc.edu.cn/qtproject/archive/qt/5.14/5.14.1/qt-opensource-linux-x64-5.14.1.run),安装完毕之后修改[common.cmake中定义的QT_ROOT](https://gitee.com/qq2820/puppy/blob/master/builder/cmake/common.cmake)
#### 使用说明 

. setup.sh

mkdir build

cd build 

cmake ..

make 

第一次编译需要联网下载对应的开源代码编译，根据你使用的库可能需要比较长的编译时间请耐心等待，如果有任何错误也欢迎登录 [issues](https://gitee.com/qq2820/puppy/issues "With a Title")提出。


checkout_testSerial.sh

    次脚本会自动clone，rttr系列化代码
    
 checkout_puppy_demo.sh
 
    次脚本会下载编译工程的demo代码，推荐第一次使用的的用执行此脚本。   