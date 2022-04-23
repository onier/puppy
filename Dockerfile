#
# Each instruction in this file generates a new layer that gets pushed to your local image cache
#

#
# Lines preceeded by # are regarded as comments and ignored
#

#
# The line below states we will base our new image on the Latest Official Ubuntu 
FROM ubuntu:18.04

#
LABEL maintainer="282052309@qq.com"
LABEL version="0.1"
LABEL description="This is custom Docker Image for puppy."
RUN  echo 'deb http://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse'> /etc/apt/sources.list
RUN  echo 'deb-src http://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse' >> /etc/apt/sources.list
RUN  echo 'deb http://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse' >> /etc/apt/sources.list
RUN  echo 'deb-src http://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse' >> /etc/apt/sources.list
RUN  echo 'deb http://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse' >> /etc/apt/sources.list
RUN  echo 'deb-src http://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse' >> /etc/apt/sources.list
RUN  echo 'deb http://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse' >> /etc/apt/sources.list
RUN  echo 'deb-src http://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse' >> /etc/apt/sources.list


# Update the image to the latest packages
RUN apt-get update && apt-get upgrade -y && \
    apt install qt5-default qttools5-dev-tools libqt5x11extras5-dev libqt5sql5* -y \
    libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample-dev libdc1394-22-dev liblapack-dev -y

RUN apt-get install git gcc g++ wget make pkg-config build-essential -y

RUN apt install -y software-properties-common libssl-dev lsb-release -y

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF7F09730B3F0A4
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
RUN apt update -y
RUN apt install cmake -y
RUN apt install gdb -y
RUN apt install libgl1-mesa-dev libglu1-mesa-dev libglu1-mesa-dev freeglut3-dev -y

RUN git clone https://gitee.com/qq2820/puppy -b docker

RUN cd /puppy &&  git clone https://gitee.com/qq2820/Fake

RUN mkdir /puppy/cmake-build-debug

RUN cd /puppy/cmake-build-debug && cmake .. -DCMAKE_BUILD_TYPE=debug

RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target boost -- -j 6
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target rttr -- -j 6
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target gflags -- -j 6
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target glog -- -j 6
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target opencv -- -j 2
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target tbb -- -j 2
RUN apt install qttools5-dev -y
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target vtk -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target pcl -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target assimp -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target azmq -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target bullet -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target catkin -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target coin -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target double-conversion -- -j 4
        RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target eigen3 -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target fcl -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target flann -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target fmt -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target folly -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target kdl -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target libccd -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target libevent -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target libwebsockets  -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target libxslt -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target libzmq -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target mimalloc -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target mstch -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target nlohmann_json -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target nlopt -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target ode -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target ompl -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target PQP -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target protobuf -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target python3 -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target rapidjson -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target rl -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target solid3 -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target soqt -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target sqlitecpp -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target Vc -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target visp -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target websocketpp -- -j 4
RUN cd /puppy/cmake-build-debug && cmake --build /puppy/cmake-build-debug --target xerces-c -- -j 4
