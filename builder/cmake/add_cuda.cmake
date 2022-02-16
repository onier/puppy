find_package(CUDA REQUIRED)
set(cuda_LIBRARIES ${CUDA_LIBRARIES} /usr/lib/aarch64-linux-gnu/libnvinfer.so
        /usr/lib/aarch64-linux-gnu/libnvcaffe_parser.so
        /usr/lib/aarch64-linux-gnu/libnvonnxparser.so
        /usr/lib/aarch64-linux-gnu/libnvinfer_plugin.so
        /usr/lib/gcc/aarch64-linux-gnu/7/libstdc++fs.a
        )
set(cuda_INCLUDE_DIRS /usr/local/cuda/include)
set(cuda_FOUND ON)
message("cuda_LIBRARIES: ${cuda_LIBRARIES}")