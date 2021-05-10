# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

ARG REGISTRY
ARG TAG

#
# Intermediate container for building LLVM 11
#
FROM ${REGISTRY}/cuda10_1:${TAG} AS build_llvm

RUN curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/llvm-project-11.0.1.src.tar.xz \
 && tar xf llvm-project-11.0.1.src.tar.xz \
 && rm llvm-project-11.0.1.src.tar.xz

# Install LLVM 11.0.1 into /usr/local/llvm-11.0.1
RUN cd llvm-project-11.0.1.src \
 && cmake -Bbuild -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local/llvm-11.0.1/ \
    -DLLVM_TARGETS_TO_BUILD="X86;NVPTX" \
    -DLLVM_ENABLE_PROJECTS=clang \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DCLANG_OPENMP_NVPTX_DEFAULT_ARCH=sm_35 \
    llvm \
 && cmake --build build/ --target install

RUN cd llvm-project-11.0.1.src \
 && cmake -Bbuild_omp -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_INSTALL_PREFIX=/usr/local/llvm-11.0.1/ \
    -DCMAKE_C_COMPILER=/usr/local/llvm-11.0.1/bin/clang \
    -DCMAKE_CXX_COMPILER=/usr/local/llvm-11.0.1/bin/clang++ \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=35,37,50,52,53,60,61,62,70,75 \
    openmp \
 && cmake --build build_omp --target install \
 && rm -rf /llvm-project-11.0.1.src

#
# CUDA 10.1 with LLVM 11
#
FROM ${REGISTRY}/cuda10_1:${TAG} AS release

COPY --from=build_llvm /usr/local/llvm-11.0.1 /usr/local/llvm-11.0.1

# LLVM 11.0.1 environements
RUN echo "/usr/local/llvm-11.0.1/lib" > /etc/ld.so.conf.d/llvm-11.0.1.conf \
 && ldconfig
ENV PATH /usr/local/llvm-11.0.1/bin:$PATH
ENV CC   /usr/local/llvm-11.0.1/bin/clang
ENV CXX  /usr/local/llvm-11.0.1/bin/clang++

# Skip CPATH because this path should be treated as system directory
# See GCC manual for detail https://gcc.gnu.org/onlinedocs/cpp/Environment-Variables.html
ENV C_INCLUDE_PATH     /usr/local/llvm-11.0.1/include:$C_INCLUDE_PATH
ENV CPLUS_INCLUDE_PATH /usr/local/llvm-11.0.1/include:$CPLUS_INCLUDE_PATH
