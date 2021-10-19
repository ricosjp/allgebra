# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

FROM ubuntu:20.04

# workaround for tzdata
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl make ninja-build \
    git doxygen graphviz \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3-linux-x86_64.tar.gz \
 && tar xf cmake-3.21.3-linux-x86_64.tar.gz \
 && mv cmake-3.21.3-linux-x86_64/bin/* /usr/bin/ \
 && mv cmake-3.21.3-linux-x86_64/share/cmake-3.21 /usr/share/ \
 && rm -rf cmake-3.21.3-linux-x86_64*
