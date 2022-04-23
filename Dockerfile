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

RUN apt install -y software-properties-common lsb-release -y

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF7F09730B3F0A4 
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" 
RUN apt update -y
RUN apt install cmake -y

RUN git clone https://gitee.com/qq2820/puppy -b master  

RUN cd /puppy&& ls 

RUN mkdir /puppy/cmake-build-debug 
	
RUN cd /puppy/cmake-build-debug && cmake .. -DCMAKE_BUILD_TYPE=debug && make -j4
