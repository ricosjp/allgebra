FROM nvidia/cuda:11.0-devel-ubuntu20.04
LABEL maintainer "Toshiaki Hishinuma <hishinuma.toshiaki@gmail.com>"

# workaround for tzdata
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    make \
    gcc-9-offload-nvptx nvptx-tools g++-9 gfortran-9 \
    cuda-nsight-systems-11-0 \
    libopenblas-openmp-dev \
    python3 python3-yaml python3-numpy \
    linux-tools-generic strace trace-cmd valgrind gdb \
    intel-mkl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/Kitware/CMake/releases/download/v3.18.2/cmake-3.18.2-Linux-x86_64.tar.gz \
 && tar xf cmake-3.18.2-Linux-x86_64.tar.gz \
 && mv cmake-3.18.2-Linux-x86_64/bin/* /usr/bin/ \
 && mv cmake-3.18.2-Linux-x86_64/share/cmake-3.18 /usr/share/ \
 && rm cmake-3.18.2-Linux-x86_64.tar.gz

# Add perf into PATH
ENV PATH /usr/lib/linux-tools/5.4.0-45-generic:$PATH
ENV FC /usr/bin/gfortran-9

# To validate container is well-constructed
COPY test/ /test
