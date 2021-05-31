# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

ARG REGISTRY
ARG TAG

#
# Intermediate container for building LLVM 12
#
FROM ${REGISTRY}/cuda10_1:${TAG} AS build

RUN curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-project-12.0.0.src.tar.xz \
 && tar xf llvm-project-12.0.0.src.tar.xz \
 && rm llvm-project-12.0.0.src.tar.xz

# Install LLVM 12.0.0 into /usr/local/llvm-12.0.0
RUN cd llvm-project-12.0.0.src \
 && cmake -Wno-dev -Bbuild -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local/llvm-12.0.0/ \
    -DLLVM_TARGETS_TO_BUILD="X86;NVPTX" \
    -DLLVM_ENABLE_PROJECTS=clang \
    llvm \
 && cmake --build build/ --target install

# FIXME
RUN cd /usr/include \
 && ln -s x86_64-linux-gnu/sys \
 && ln -s x86_64-linux-gnu/bits \
 && ln -s x86_64-linux-gnu/gnu

# Build libomptarget
RUN cd llvm-project-12.0.0.src \
 && cmake -Wno-dev -Bbuild_omp -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_INSTALL_PREFIX=/usr/local/llvm-12.0.0/ \
    -DCMAKE_C_COMPILER=/usr/local/llvm-12.0.0/bin/clang \
    -DCMAKE_CXX_COMPILER=/usr/local/llvm-12.0.0/bin/clang++ \
    -DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=all \
    openmp \
 && cmake --build build_omp --target install \
 && rm -rf /llvm-project-12.0.0.src

# LLVM 12.0.0 environements
RUN echo "/usr/local/llvm-12.0.0/lib" > /etc/ld.so.conf.d/llvm-12.0.0.conf \
 && ldconfig
ENV PATH /usr/local/llvm-12.0.0/bin:$PATH
ENV CC   /usr/local/llvm-12.0.0/bin/clang
ENV CXX  /usr/local/llvm-12.0.0/bin/clang++

#
# Build and install OpenMPI
#
RUN apt update -y \
 && apt install -y --allow-change-held-packages \
    autoconf m4 automake libtool flex \
    libnccl2 libnccl-dev \
    ssh \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN git clone -b v4.1.0 --depth=1 https://github.com/open-mpi/ompi.git

WORKDIR /build/ompi
RUN ./autogen.pl \
 && ./configure CC=clang CXX=clang++ --with-cuda --disable-mpi-fortran --prefix=/usr/local/ompi-4.1.0 \
 && make install -j $(nproc)

#
# CUDA 10.1 with LLVM 12
#
FROM ${REGISTRY}/cuda10_1:${TAG} AS release

# LLVM 12.0.0 environements
COPY --from=build /usr/local/llvm-12.0.0 /usr/local/llvm-12.0.0
RUN echo "/usr/local/llvm-12.0.0/lib" > /etc/ld.so.conf.d/llvm-12.0.0.conf \
 && ldconfig
ENV PATH /usr/local/llvm-12.0.0/bin:$PATH
ENV CC   /usr/local/llvm-12.0.0/bin/clang
ENV CXX  /usr/local/llvm-12.0.0/bin/clang++

# Skip CPATH because this path should be treated as system directory
# See GCC manual for detail https://gcc.gnu.org/onlinedocs/cpp/Environment-Variables.html
ENV C_INCLUDE_PATH     /usr/local/llvm-12.0.0/include:$C_INCLUDE_PATH
ENV CPLUS_INCLUDE_PATH /usr/local/llvm-12.0.0/include:$CPLUS_INCLUDE_PATH

# OpenMPI environements
COPY --from=build /usr/local/ompi-4.1.0 /usr/local/ompi-4.1.0
RUN echo "/usr/local/ompi-4.1.0/lib" > /etc/ld.so.conf.d/ompi-4.1.0.conf && ldconfig
RUN mv /usr/local/ompi-4.1.0/lib/pkgconfig/* /usr/lib/pkgconfig/
ENV PATH /usr/local/ompi-4.1.0/bin:$PATH
