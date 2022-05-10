# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

FROM nvidia/cuda:11.6.2-devel-ubuntu20.04

# workaround for tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Keep package list sorted
RUN apt-get update && apt-get install -y \
    ccache \
    curl \
    doxygen \
    clang-format \
    clang-tidy \
    g++-10 \
    gfortran-10 \
    git \
    graphviz \
    libelf-dev \
    make \
    ninja-build \
    patchelf \
    pkg-config \
    python3 \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install "poetry==1.1.7"

# Override GCC10 by GCC7
RUN rm -f /usr/bin/gcc /usr/bin/g++ /usr/bin/gfortran \
    && ln -s /usr/bin/gcc-10 /usr/bin/gcc \
    && ln -s /usr/bin/g++-10 /usr/bin/g++ \
    && ln -s /usr/bin/gfortran-10 /usr/bin/gfortran

RUN curl -LO https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3-linux-x86_64.tar.gz \
    && tar xf cmake-3.21.3-linux-x86_64.tar.gz \
    && mv cmake-3.21.3-linux-x86_64/bin/* /usr/bin/ \
    && mv cmake-3.21.3-linux-x86_64/share/cmake-3.21 /usr/share/ \
    && rm -rf cmake-3.21.3-linux-x86_64*

# CUDA 11.6 environements
ENV CPATH              /usr/local/cuda-11.6/include
ENV C_INCLUDE_PATH     /usr/local/cuda-11.6/include
ENV CPLUS_INCLUDE_PATH /usr/local/cuda-11.6/include

# Singurality `--nv` option tries to mount host's `libcuda.so` at `/.singurality.d/libs`, which `ld` does not search.
# This is not necessary for Docker's `--gpus=all` since it mounts them where ld can find e.g. `/usr/lib/x86_64-linux-gnu/`.
ENV LIBRARY_PATH /usr/local/cuda-11.6/lib64:/.singularity.d/libs/

# To validate container is well-constructed
COPY examples/ /examples

# Utility for allgebra
COPY utilities /utilities
RUN make -C /utilities install

# Setting git config
RUN echo "[safe]\n\tdirectory = *" > /root/.gitconfig
COPY check_format.sh /usr/bin

ENV ALLGEBRA_CUDA_INSTALL_DIR /usr/local/cuda-11.6
ENV ALLGEBRA_CUDA_VERSION 11.6.1
ENV ALLGEBRA_CUDA_VERSION_MAJOR 11
ENV ALLGEBRA_CUDA_VERSION_MINOR 6
ENV ALLGEBRA_CUDA_VERSION_PATCH 2
