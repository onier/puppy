sudo apt install qt5-default libqt5sql5* -y
sudo apt install libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample-dev libdc1394-22-dev liblapack-dev -y
#sudo apt-get install git pkg-config make libglu1-mesa-dev freeglut3-dev mesa-common-dev libffi-dev ffmpeg libxml2-dev python-pip -y
#sudo apt-get install libx11-xcb-dev  python-dev -y
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echo $BASE_DIR
export ARCH=x64
mkdir -p $BASE_DIR/install/${ARCH}-install/oss/lib/pkgconfig
mkdir -p $BASE_DIR/install/${ARCH}-install/oss/lib64/pkgconfig
export LD_LIBRARY_PATH=$BASE_DIR/install/${ARCH}-install/oss/lib:$BASE_DIR/install/${ARCH}-install/oss/lib64:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$BASE_DIR/install/${ARCH}-install/oss/lib/pkgconfig:$BASE_DIR/install/${ARCH}-install/oss/lib64/pkgconfig:$PKG_CONFIG_PATH
export LIBRARY_PATH=$BASE_DIR/install/${ARCH}-install/oss/lib:$BASE_DIR/install/${ARCH}-install/oss/lib64:$LIBRARY_PATH
export PATH=$BASE_DIR/builder/cmake/cmake-tool/bin:$PATH
export PATH=$BASE_DIR/install/${ARCH}-install/oss/bin:$PATH
export PATH=$BASE_DIR/builder/cmake-3.16.4-Linux-x86_64/bin:$PATH
export PYTHONPATH=$BASE_DIR/install/${ARCH}-install/oss/lib/python2.7/dist-packages/:$PYTHONPATH
export QMAKE_PATH=/opt/Qt5.14.1/5.14.1/gcc_64/bin/qmake
export ROS_PYTHON_VERSION=3.8.2
