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

# CUDA 10.1 environements
ENV CPATH              /usr/local/cuda-10.1/include
ENV C_INCLUDE_PATH     /usr/local/cuda-10.1/include
ENV CPLUS_INCLUDE_PATH /usr/local/cuda-10.1/include
ENV LIBRARY_PATH       /usr/local/cuda-10.1/lib64

# To validate container is well-constructed
COPY examples/ /examples

# Utility for allgebra
COPY utilities /utilities
RUN make -C /utilities install
