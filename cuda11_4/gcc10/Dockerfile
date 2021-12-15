# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

ARG REGISTRY
ARG TAG

FROM ${REGISTRY}/cuda11_4:${TAG}

RUN apt-get update && apt-get install -y \
    g++-10 \
    gcc-10-offload-nvptx \
    libelf-dev \
    nvptx-tools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Override GCC10 by GCC7
RUN rm -f /usr/bin/gcc /usr/bin/g++ \
 && ln -s /usr/bin/gcc-10 /usr/bin/gcc \
 && ln -s /usr/bin/g++-10 /usr/bin/g++

ENV CC  /usr/bin/gcc
ENV CXX /usr/bin/g++

ENV ALLGEBRA_GCC_INSTALL_DIR /usr
ENV ALLGEBRA_GCC_VERSION 10.3.0
ENV ALLGEBRA_GCC_VERSION_MAJOR 10
ENV ALLGEBRA_GCC_VERSION_MINOR 3
ENV ALLGEBRA_GCC_VERSION_PATCH 0
