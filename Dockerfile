FROM       ubuntu:16.04
MAINTAINER Florian Oetke
CMD        bash

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y wget software-properties-common python-software-properties

RUN add-apt-repository ppa:jonathonf/gcc-7.1

RUN echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main" >> /etc/apt/sources.list

RUN echo "deb http://archive.ubuntu.com/ubuntu/ xenial-proposed restricted main multiverse universe" >> /etc/apt/sources.list

RUN wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -


RUN apt-get update && \
	apt-get install -y build-essential && \
	apt-get install -y git && \
	apt-get install -y xorg-dev libglu1-mesa-dev --fix-missing && \
	apt-get purge -y gcc g++ && \
	apt-get install -y gcc-7 g++-7 && \
	apt-get install -y clang clang-5.0 lldb-5.0 lld-5.0 libstdc++-5-dev && \
	apt-get install -y clang-tidy && \
	apt-get install -y xutils-dev libsdl2-dev libsdl2-mixer-dev libsdl2-gfx-dev libsdl2-image-dev 

RUN rm -f /usr/bin/g++
RUN rm -f /usr/bin/gcc
RUN rm -f /usr/bin/clang++
RUN rm -f /usr/bin/clang
RUN ln -s /usr/bin/g++-7 /usr/bin/g++
RUN ln -s /usr/bin/gcc-7 /usr/bin/gcc
RUN ln -s /usr/bin/clang++-5.0 /usr/bin/clang++
RUN ln -s /usr/bin/clang-5.0 /usr/bin/clang

RUN wget https://cmake.org/files/v3.9/cmake-3.9.3-Linux-x86_64.sh && \
    chmod +x ./cmake-3.9.3-Linux-x86_64.sh &&\
    ./cmake-3.9.3-Linux-x86_64.sh --skip-license && \
    rm ./cmake-3.9.3-Linux-x86_64.sh

RUN wget -O VulkanSDK.run https://vulkan.lunarg.com/sdk/download/1.0.54.0/linux/vulkansdk-linux-x86_64-1.0.59.0.run?human=true && \
	chmod ugo+x VulkanSDK.run

RUN	./VulkanSDK.run && rm -f VulkanSDK.run

ENV	VULKAN_SDK="/VulkanSDK/1.0.54.0/x86_64"
ENV	PATH="${VULKAN_SDK}/bin:${PATH}"
ENV	LD_LIBRARY_PATH="${VULKAN_SDK}/lib:${LD_LIBRARY_PATH}"
ENV	VK_LAYER_PATH="${VULKAN_SDK}/etc/explicit_layer.d"

