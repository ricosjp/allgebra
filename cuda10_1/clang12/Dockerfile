# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

ARG REGISTRY
ARG TAG

FROM ${REGISTRY}/cuda10_1:${TAG} AS build

RUN apt-get update && apt-get install -y \
    libelf-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-project-12.0.0.src.tar.xz \
 && tar xf llvm-project-12.0.0.src.tar.xz \
 && rm llvm-project-12.0.0.src.tar.xz

# Install LLVM 12.0.0 into /opt/llvm-12.0.0
RUN cd llvm-project-12.0.0.src \
 && cmake -Bbuild -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/llvm-12.0.0/ \
    -DLLVM_TARGETS_TO_BUILD="X86;NVPTX" \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" \
    llvm \
 && cmake --build build/ --target install

RUN cd /usr/include \
 && ln -s x86_64-linux-gnu/sys \
 && ln -s x86_64-linux-gnu/bits \
 && ln -s x86_64-linux-gnu/gnu

RUN cd llvm-project-12.0.0.src \
 && cmake -Bbuild_omp -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_INSTALL_PREFIX=/opt/llvm-12.0.0/ \
    -DCMAKE_C_COMPILER=/opt/llvm-12.0.0/bin/clang \
    -DCMAKE_CXX_COMPILER=/opt/llvm-12.0.0/bin/clang++ \
    -DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=all \
    openmp \
 && cmake --build build_omp --target install \
 && rm -rf /llvm-project-12.0.0.src

FROM ${REGISTRY}/cuda10_1:${TAG} AS release

COPY --from=build /opt/llvm-12.0.0 /opt/llvm-12.0.0

# LLVM 12.0.0 environements
RUN echo "/opt/llvm-12.0.0/lib" > /etc/ld.so.conf.d/llvm-12.0.0.conf \
 && ldconfig
ENV PATH /opt/llvm-12.0.0/bin:$PATH
ENV CC   /opt/llvm-12.0.0/bin/clang
ENV CXX  /opt/llvm-12.0.0/bin/clang++

# Skip CPATH because this path should be treated as system directory
# See GCC manual for detail https://gcc.gnu.org/onlinedocs/cpp/Environment-Variables.html
ENV C_INCLUDE_PATH     /opt/llvm-12.0.0/include:$C_INCLUDE_PATH
ENV CPLUS_INCLUDE_PATH /opt/llvm-12.0.0/include:$CPLUS_INCLUDE_PATH
