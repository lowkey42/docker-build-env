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
	apt-get install -y cmake build-essential && \
	apt-get install -y git && \
	apt-get install -y xorg-dev libglu1-mesa-dev --fix-missing && \
	apt-get install -y gcc-7 g++-7 && \
	apt-get install -y clang-5.0 lldb-5.0 lld-5.0 libstdc++-5-dev && \
	apt-get install -y clang-tidy cppcheck && \
	apt-get install -y xutils-dev libsdl2-dev libsdl2-mixer-dev libsdl2-gfx-dev libsdl2-image-dev 

RUN wget -O VulkanSDK.run https://vulkan.lunarg.com/sdk/download/1.0.61.0/linux/vulkansdk-linux-x86_64-1.0.61.0.run?human=true && \
	chmod ugo+x VulkanSDK.run

RUN	./VulkanSDK.run
RUN	cd VulkanSDK/1.0.61.0
ENV	VULKAN_SDK="/VulkanSDK/1.0.61.0/x86_64:${VULKAN_SDK}"
ENV	PATH="${VULKAN_SDK}/bin:${PATH}"
ENV	LD_LIBRARY_PATH="${VULKAN_SDK}/lib:${LD_LIBRARY_PATH}"
ENV	VK_LAYER_PATH="${VULKAN_SDK}/etc/explicit_layer.d:${VK_LAYER_PATH}"

