FROM       debian:testing-slim
MAINTAINER Florian Oetke
CMD        bash

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y --no-install-recommends git git-lfs ninja-build make binutils-gold xorg-dev xutils-dev libsdl2-dev libsdl2-mixer-dev libsdl2-image-dev cmake wget xz-utils ca-certificates gcc-8 g++-8 libstdc++-8-dev clang-6.0 libc++-dev libc++abi-dev clang-tools-6.0 lld-6.0 && \
	update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-6.0 100 && \
	update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 100 && \
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/x86_64-linux-gnu-g++-8 100 && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 100 && \
	update-alternatives --install /usr/bin/scan-build scan-build /usr/bin/scan-build-6.0 100 && \
	rm -f /usr/lib/llvm-6.0/bin/clang-check && \
	rm -f /usr/lib/llvm-6.0/bin/clang-import-test && \
	rm -f /usr/lib/llvm-6.0/bin/clang-query && \
	rm -f /usr/lib/llvm-6.0/bin/clang-refactor && \
	rm -f /usr/lib/llvm-6.0/bin/clangd && \
	rm -f /usr/lib/llvm-6.0/bin/clang-change-namespace && \
	rm -f /usr/lib/llvm-6.0/bin/clang-include-fixer && \
	rm -f /usr/lib/llvm-6.0/bin/find-all-symbols && \
	rm -f /usr/lib/llvm-6.0/bin/clang-rename && \
	rm -f /usr/lib/llvm-6.0/bin/clang-reorder-fields && \
	rm -f /usr/lib/llvm-6.0/bin/c-index-test && \
	rm -f /usr/lib/llvm-6.0/bin/modularize && \
	rm -f /usr/lib/llvm-6.0/bin/clang-func-mapping && \
	rm -f /usr/lib/llvm-6.0/bin/clang-apply-replacements && \
	rm -f /usr/lib/llvm-6.0/lib/libLLV*.a && \
	git clone --recursive https://github.com/KhronosGroup/Vulkan-Hpp.git && \
    cd Vulkan-Hpp && \
	git checkout eaf0fda6de05628efa009b465124e9cfaca74832 && \
	cd Vulkan-Docs && \
	git checkout v1.1.73 && \
	cd .. && \
	mkdir build && cd build && \
	cmake .. && cmake --build . && ./VulkanHppGenerator && \
	wget --no-check-certificate -O VulkanSDK.run https://vulkan.lunarg.com/sdk/download/1.1.73.0/linux/vulkansdk-linux-x86_64-1.1.73.0.run?Human=true && \
	chmod ugo+x VulkanSDK.run && \
	./VulkanSDK.run --target /VulkanSDK && rm -f VulkanSDK.run && \
	cp ../vulkan/vulkan.hpp /VulkanSDK/1.1.73.0/x86_64/include/vulkan/ && \
	cd ../.. && \
	rm -r Vulkan-Hpp && \
	apt-get purge -y gdb man vim-common python3 locales && \
	apt-get autoremove -y && \
	apt-get install -y --no-install-recommends libsdl2-dev libsdl2-mixer-dev libsdl2-image-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /VulkanSDK/1.1.73.0/doc && \
	rm -rf /VulkanSDK/1.1.73.0/source

ENV	VULKAN_SDK="/VulkanSDK/1.1.73.0/x86_64"
ENV	PATH="${VULKAN_SDK}/bin:${PATH}"
ENV	LD_LIBRARY_PATH="${VULKAN_SDK}/lib:${LD_LIBRARY_PATH}"
ENV	VK_LAYER_PATH="${VULKAN_SDK}/etc/explicit_layer.d"

