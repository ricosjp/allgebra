# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

# Force to use Ubuntu 20.04 registry for using officially-distributed MKL
# (CUDA 10.1 is not distributed with Ubuntu 20.04)
FROM nvidia/cuda:10.1-devel-ubuntu18.04
COPY ubuntu2004.list /etc/apt/sources.list

# workaround for tzdata
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git zsh tmux pkg-config make wget \
    gcc-8 g++-8 libelf-dev ninja-build \
    nsight-systems-2020.3.2 \
    python3 python3-yaml python3-numpy python3-pandas \
    strace trace-cmd valgrind gdb \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4-Linux-x86_64.tar.gz \
 && tar xf cmake-3.18.4-Linux-x86_64.tar.gz \
 && mv cmake-3.18.4-Linux-x86_64/bin/* /usr/bin/ \
 && mv cmake-3.18.4-Linux-x86_64/share/cmake-3.18 /usr/share/ \
 && rm -rf cmake-3.18.4-Linux-x86_64*

# CUDA 10.1 environements
ENV CPATH              /usr/local/cuda-10.1/include
ENV C_INCLUDE_PATH     /usr/local/cuda-10.1/include
ENV CPLUS_INCLUDE_PATH /usr/local/cuda-10.1/include
ENV LIBRARY_PATH       /usr/local/cuda-10.1/lib64

RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-project-11.0.0.tar.xz \
&& tar -Jxf llvm-project-11.0.0.tar.xz \
&& rm llvm-project-11.0.0.tar.xz

# clang11
RUN cd llvm-project-11.0.0 \
&& mkdir build && cd build \
&& cmake \
		  -DCMAKE_BUILD_TYPE=Release \
		  -DCMAKE_INSTALL_PREFIX=/usr/local/llvm/ \
		  -DCMAKE_MAKE_PROGRAM=ninja \
		  -G Ninja \
		  -DCMAKE_C_COMPILER=/usr/bin/gcc-8 \
		  -DCMAKE_CXX_COMPILER=/usr/bin/g++-8 \
		  -DLLVM_TARGETS_TO_BUILD="X86;NVPTX" \
		  -DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi;openmp" \
		  -DCLANG_OPENMP_NVPTX_DEFAULT_ARCH=sm_35 \
		  -DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=35,37,52,60,61,70,75 \
		  ../llvm/ \
&& ninja -j$(nproc); ninja -j$(nproc) install

# clang11 openmp
RUN cd llvm-project-11.0.0 \
&& mkdir build_omp && cd build_omp \
&& cmake \
		  -DCMAKE_BUILD_TYPE=Debug \
		  -DCMAKE_MAKE_PROGRAM=ninja \
		  -G Ninja \
		  -DCMAKE_INSTALL_PREFIX=/usr/local/llvm/ \
		  -DCMAKE_C_COMPILER=/usr/local/llvm/bin/clang \
		  -DCMAKE_CXX_COMPILER=/usr/local/llvm/bin/clang++ \
		  -DCLANG_OPENMP_NVPTX_DEFAULT_ARCH=sm_35 \
		  -DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=35,37,52,60,61,70,75 \
		  ../openmp/ \
&& ninja -j$(nproc); ninja -j$(nproc) install \
&& cd .. \
&& rm -rf /llvm-project-11.0.0

# clang11 environments
ENV CPATH=/usr/local/llvm/include:$CPATH
ENV C_INCLUDE_PATH=/usr/local/llvm/include:$C_INCLUDE_PATH
ENV CPLUS_INCLUDE_PATH=/usr/local/llvm/include:$CPLUS_INCLUDE_PATH
ENV LD_LIBRARY_PATH /usr/local/llvm/lib:$LD_LIBRARY_PATH
ENV CPATH /usr/local/llvm/include:$CPATH
ENV PATH  /usr/local/llvm/bin/:$PATH
