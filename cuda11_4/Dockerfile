# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

FROM nvidia/cuda:11.4.1-devel-ubuntu20.04

# workaround for tzdata
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git pkg-config make \
    gfortran-7 \
    libelf-dev ninja-build \
    python3 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# GCC-Fortran
RUN ln -s /usr/bin/gfortran-7 /usr/bin/gfortran
ENV FC /usr/bin/gfortran

RUN curl -LO https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2-linux-x86_64.tar.gz \
 && tar xf cmake-3.20.2-linux-x86_64.tar.gz \
 && mv cmake-3.20.2-linux-x86_64/bin/* /usr/bin/ \
 && mv cmake-3.20.2-linux-x86_64/share/cmake-3.20 /usr/share/ \
 && rm -rf cmake-3.20.2-linux-x86_64*

# CUDA 11.4 environements
ENV CPATH              /usr/local/cuda-11.4/include
ENV C_INCLUDE_PATH     /usr/local/cuda-11.4/include
ENV CPLUS_INCLUDE_PATH /usr/local/cuda-11.4/include

# Singurality `--nv` option tries to mount host's `libcuda.so` at `/.singurality.d/libs`, which `ld` does not search.
# This is not necessary for Docker's `--gpus=all` since it mounts them where ld can find e.g. `/usr/lib/x86_64-linux-gnu/`.
ENV LIBRARY_PATH /usr/local/cuda-11.4/lib64:/.singularity.d/libs/

# To validate container is well-constructed
COPY examples/ /examples

# Utility for allgebra
COPY utilities /utilities
RUN make -C /utilities install

ENV ALLGEBRA_CUDA_INSTALL_DIR /usr/loca/cuda-11.4
ENV ALLGEBRA_CUDA_VERSION 11.4
ENV ALLGEBRA_CUDA_VERSION_MAJOR 11
ENV ALLGEBRA_CUDA_VERSION_MINOR 4
