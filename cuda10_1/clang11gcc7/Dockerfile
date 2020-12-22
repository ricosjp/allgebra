# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

ARG REGISTRY
ARG TAG

FROM ${REGISTRY}/cuda10_1:${TAG} AS build

RUN curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-project-11.0.0.tar.xz \
 && tar xf llvm-project-11.0.0.tar.xz \
 && rm llvm-project-11.0.0.tar.xz

# Install LLVM 11.0.0 into /usr/local/llvm-11.0.0
RUN cd llvm-project-11.0.0 \
 && cmake -Bbuild -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local/llvm-11.0.0/ \
    -DLLVM_TARGETS_TO_BUILD="X86;NVPTX" \
    -DLLVM_ENABLE_PROJECTS=clang \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DCLANG_OPENMP_NVPTX_DEFAULT_ARCH=sm_35 \
    llvm \
 && cmake --build build/ --target install

RUN cd llvm-project-11.0.0 \
 && cmake -Bbuild_omp -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_INSTALL_PREFIX=/usr/local/llvm-11.0.0/ \
    -DCMAKE_C_COMPILER=/usr/local/llvm-11.0.0/bin/clang \
    -DCMAKE_CXX_COMPILER=/usr/local/llvm-11.0.0/bin/clang++ \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=35,37,50,52,53,60,61,62,70,75 \
    openmp \
 && cmake --build build_omp --target install \
 && rm -rf /llvm-project-11.0.0

FROM ${REGISTRY}/cuda10_1:${TAG} AS release

COPY --from=build /usr/local/llvm-11.0.0 /usr/local/llvm-11.0.0

# LLVM 11.0.0 environements
RUN echo "/usr/local/llvm-11.0.0/lib" > /etc/ld.so.conf.d/llvm-11.0.0.conf \
 && ldconfig
ENV PATH /usr/local/llvm-11.0.0/bin:$PATH
ENV CC   /usr/local/llvm-11.0.0/bin/clang
ENV CXX  /usr/local/llvm-11.0.0/bin/clang++

# Skip CPATH because this path should be treated as system directory
# See GCC manual for detail https://gcc.gnu.org/onlinedocs/cpp/Environment-Variables.html
ENV C_INCLUDE_PATH     /usr/local/llvm-11.0.0/include:$C_INCLUDE_PATH
ENV CPLUS_INCLUDE_PATH /usr/local/llvm-11.0.0/include:$CPLUS_INCLUDE_PATH
