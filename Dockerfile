FROM       debian:unstable-slim
MAINTAINER Florian Oetke
CMD        bash

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y --no-install-recommends git git-lfs ninja-build make binutils-gold xorg-dev xutils-dev libsdl2-dev libsdl2-mixer-dev libsdl2-image-dev cmake wget xz-utils ca-certificates gcc-10 g++-10 libstdc++-10-dev clang-12 libc++-12-dev libc++abi-12-dev clang-tools-12 lld-12 python2 python lcov python3-pip libglew-dev libglfw3-dev curl  emscripten && \
	update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-12 100 && \
	update-alternatives --install /usr/bin/clang clang /usr/bin/clang-12 100 && \
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/x86_64-linux-gnu-g++-10 100 && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 && \
	update-alternatives --install /usr/bin/scan-build scan-build /usr/bin/scan-build-12 100 && \
	pip install conan && \
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
	git checkout 702723ac7599d229195aabfee0b61954ad087140 && \
	git clone https://github.com/google/googletest.git third_party/googletest && \
	cd third_party/googletest && git checkout b1fbd33c06cdb0024c67733c6fdec2009d17b384 && cd ../.. && \
	git clone https://github.com/KhronosGroup/glslang.git third_party/glslang && \
	cd third_party/glslang && git checkout dd69df7f3dac26362e10b0f38efb9e47990f7537 && cd ../.. && \
	git clone https://github.com/KhronosGroup/SPIRV-Tools.git third_party/spirv-tools && \
	cd third_party/spirv-tools && git checkout b27b1afd12d05bf238ac7368bb49de73cd620a8e && cd ../.. && \
	git clone https://github.com/google/re2.git third_party/re2 && \
	cd third_party/re2 && git checkout 91420e899889cffd100b70e8cc50611b3031e959 && cd ../.. && \
	git clone https://github.com/google/effcee.git third_party/effcee && \
	cd third_party/effcee && git checkout 5af957bbfc7da4e9f7aa8cac11379fa36dd79b84 && cd ../.. && \
	git clone https://github.com/KhronosGroup/SPIRV-Headers.git third_party/spirv-tools/external/spirv-headers && \
	cd third_party/spirv-tools/external/spirv-headers && git checkout f027d53ded7e230e008d37c8b47ede7cd308e19d && cd ../../../.. && \
	mkdir build && cd build && \
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
	cmake --build . -- -j2 install && \
	cd ../.. && rm -rf shaderc && \
	wget --no-check-certificate -O VulkanSDK.tar.gz https://sdk.lunarg.com/sdk/download/1.2.176.1/linux/vulkansdk-linux-x86_64-1.2.176.1.tar.gz && \
	mkdir /VulkanSDK && \
	tar -xzf VulkanSDK.tar.gz -C /VulkanSDK && \
	apt-get purge -y gdb man vim-common python2 locales && \
	apt-get autoremove -y && \
	apt-get install -y --no-install-recommends libsdl2-dev libsdl2-mixer-dev libsdl2-image-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /VulkanSDK/1.2.176.1/doc && \
	rm -rf /VulkanSDK/1.2.176.1/source

ENV	VULKAN_SDK="/VulkanSDK/1.2.176.1/x86_64"
ENV	PATH="${VULKAN_SDK}/bin:${PATH}"
ENV	LD_LIBRARY_PATH="${VULKAN_SDK}/lib:${LD_LIBRARY_PATH}"
ENV	VK_LAYER_PATH="${VULKAN_SDK}/etc/explicit_layer.d"

