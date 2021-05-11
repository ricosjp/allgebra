# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

FROM nvidia/cuda:11.0-devel-ubuntu20.04

# workaround for tzdata
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git pkg-config make \
    ninja-build \
    python3 \
 && apt-get autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2-linux-x86_64.tar.gz \
 && tar xf cmake-3.20.2-linux-x86_64.tar.gz \
 && mv cmake-3.20.2-linux-x86_64/bin/* /usr/bin/ \
 && mv cmake-3.20.2-linux-x86_64/share/cmake-3.20 /usr/share/ \
 && rm -rf cmake-3.20.2-linux-x86_64*

# CUDA 11.0 environements
ENV CPATH              /usr/local/cuda-11.0/include
ENV C_INCLUDE_PATH     /usr/local/cuda-11.0/include
ENV CPLUS_INCLUDE_PATH /usr/local/cuda-11.0/include
ENV LIBRARY_PATH       /usr/local/cuda-11.0/lib64

# To validate container is well-constructed
COPY examples/ /examples

# Utility for allgebra
COPY utilities /utilities
RUN make -C /utilities install
