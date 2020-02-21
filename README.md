# puppy
#### 概述
项目为一个cmake编译工程的项目，会自动下载对应开源项目源码进行编译编译。目前支持azmq boost eigen3  flann glog opencv pcl rapidjson rttr tbb vtk等。

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

#### cmake说明
主 [CMakeLists.txt](https://gitee.com/qq2820/puppy/blob/master/CMakeLists.txt "With a Title") 主要申明了开元代码的本地编译路径和安装路径。
编译工程会自动扫描每一个子目录，根据每一个目录内的CMakeLists.txt指定的信息编译生成依赖的库，并讲这个目录编译为动态库或者是进程，可以理解成一个模块。

[二级目录cmake](https://gitee.com/qq2820/puppy/blob/master/uicomponent/CMakeLists.txt "With a Title") 定义了DEPENDS项目依赖的关系，可以是第三方开源库，也可以是库模块，QT_LIBS依赖的qt库，如果指定就会自动使用qt来编译对应的模块。
include(executable)  include(library)表明当前模块编译的是库还是进程。

#### 模块说明
builder包含了整个编译工程的cmake资源文件，包含一个3.16版本的cmake和项目中使用的cmake文件。

[component1](https://gitee.com/qq2820/puppy/tree/master/component1) [component2](https://gitee.com/qq2820/puppy/tree/master/component2) [uicomponent](https://gitee.com/qq2820/puppy/tree/master/uicomponent)这个三个项目主要是演示编译工程的使用方法。

[httpserver](https://gitee.com/qq2820/puppy/tree/master/httpserver)  定义了一个httpserver的加载器。

[TestAPI](https://gitee.com/qq2820/puppy/tree/master/TestAPI)   定义了一个TestAPI，以及使用的一些参数对象。   

[Imple1API](https://gitee.com/qq2820/puppy/tree/master/Imple1API)       第一个TestAPI的实现版本

[Imple2API](https://gitee.com/qq2820/puppy/tree/master/Imple2API)        第二个TestAPI的实现版本                      

[puppycommon](https://gitee.com/qq2820/puppy/tree/master/puppycommon)     json系列化

[testhttpserver](https://gitee.com/qq2820/puppy/tree/master/testhttpserver)    测试http服务端。

详细说明[https://my.oschina.net/u/3707404/blog/3155903](https://my.oschina.net/u/3707404/blog/3155903)