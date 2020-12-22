# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

ARG REGISTRY
ARG TAG

FROM ${REGISTRY}/cuda10_2:${TAG}

RUN apt-get update && apt-get install -y \
    gcc-10-offload-nvptx g++-10 gfortran-10 \
    nvptx-tools libelf-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Override GCC10 by GCC7
RUN ln -s /usr/bin/gfortran-10 /usr/bin/gfortran \
 && rm /usr/bin/gcc /usr/bin/g++ \
 && ln -s /usr/bin/gcc-10 /usr/bin/gcc \
 && ln -s /usr/bin/g++-10 /usr/bin/g++

ENV CC /usr/bin/gcc
ENV CXX /usr/bin/g++
ENV FC /usr/bin/gfortran
