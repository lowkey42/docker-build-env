FROM       debian:testing-slim
MAINTAINER Florian Oetke
CMD        bash

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y --no-install-recommends curl lcov gcov git git-lfs ninja-build make binutils-gold xorg-dev xutils-dev libsdl2-dev libsdl2-mixer-dev libsdl2-image-dev cmake wget xz-utils ca-certificates gcc-10 g++-10 libstdc++-10-dev clang-9 libc++-dev libc++abi-dev clang-tools-9 lld-9 python2 python && \
	update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-9 100 && \
	update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 100 && \
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/x86_64-linux-gnu-g++-10 100 && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 && \
	update-alternatives --install /usr/bin/scan-build scan-build /usr/bin/scan-build-9 100 && \
	rm -f /usr/lib/llvm-*/bin/clang-check && \
	rm -f /usr/lib/llvm-*/bin/clang-import-test && \
	rm -f /usr/lib/llvm-*/bin/clang-query && \
	rm -f /usr/lib/llvm-*/bin/clang-refactor && \
	rm -f /usr/lib/llvm-*/bin/clangd && \
	rm -f /usr/lib/llvm-*/bin/clang-change-namespace && \
	rm -f /usr/lib/llvm-*/bin/clang-include-fixer && \
	rm -f /usr/lib/llvm-*/bin/find-all-symbols && \
	rm -f /usr/lib/llvm-*/bin/clang-rename && \
	rm -f /usr/lib/llvm-*/bin/clang-reorder-fields && \
	rm -f /usr/lib/llvm-*/bin/c-index-test && \
	rm -f /usr/lib/llvm-*/bin/modularize && \
	rm -f /usr/lib/llvm-*/bin/clang-func-mapping && \
	rm -f /usr/lib/llvm-*/bin/clang-apply-replacements && \
	rm -f /usr/lib/llvm-*/lib/libLLV*.a && \
	git clone https://github.com/google/shaderc && \
	cd shaderc && \
	git checkout a84571caead1f963701fd6ff859a32c4b2d5a702 && \
	git clone https://github.com/google/googletest.git third_party/googletest && \
	cd third_party/googletest && git checkout 440527a61e1c91188195f7de212c63c77e8f0a45 && cd ../.. && \
	git clone https://github.com/google/glslang.git third_party/glslang && \
	cd third_party/glslang && git checkout 91ac4290bcf2cb930b4fb0981f09c00c0b6797e1 && cd ../.. && \
	git clone https://github.com/KhronosGroup/SPIRV-Tools.git third_party/spirv-tools && \
	cd third_party/spirv-tools && git checkout ad0232dee5f5c15a5713d5b14e1763fcca6b02b8 && cd ../.. && \
	git clone https://github.com/KhronosGroup/SPIRV-Headers.git third_party/spirv-tools/external/spirv-headers && \
	cd third_party/spirv-tools/external/spirv-headers && git checkout d5b2e1255f706ce1f88812217e9a554f299848af && cd ../../../.. && \
	mkdir build && cd build && \
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
	cmake --build . -- -j2 install && \
	cd ../.. && rm -rf shaderc && \
	git clone --recursive https://github.com/KhronosGroup/Vulkan-Hpp.git && \
    cd Vulkan-Hpp && \
	git checkout 594acb2ecddca663eb102c5ebfe7a27776ac84df && \
	cd Vulkan-Headers && \
	git checkout v1.2.131 && \
	cd .. && \
	mkdir build && cd build && \
	cmake .. && cmake --build . && ./VulkanHppGenerator && \
	wget --no-check-certificate -O VulkanSDK.tar.gz https://vulkan.lunarg.com/sdk/download/1.2.131.2/linux/vulkansdk-linux-x86_64-1.2.131.2.tar.gz?Human=true && \
	mkdir /VulkanSDK && \
	tar -xzf VulkanSDK.tar.gz -C /VulkanSDK && \
	cp ../vulkan/vulkan.hpp /VulkanSDK/1.2.131.2/x86_64/include/vulkan/ && \
	cd ../.. && \
	rm -r Vulkan-Hpp && \
	apt-get purge -y gdb man vim-common python3 python2 locales && \
	apt-get autoremove -y && \
	apt-get install -y --no-install-recommends libsdl2-dev libsdl2-mixer-dev libsdl2-image-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /VulkanSDK/1.2.131.2/doc && \
	rm -rf /VulkanSDK/1.2.131.2/source

ENV	VULKAN_SDK="/VulkanSDK/1.2.131.2/x86_64"
ENV	PATH="${VULKAN_SDK}/bin:${PATH}"
ENV	LD_LIBRARY_PATH="${VULKAN_SDK}/lib:${LD_LIBRARY_PATH}"
ENV	VK_LAYER_PATH="${VULKAN_SDK}/etc/explicit_layer.d"

