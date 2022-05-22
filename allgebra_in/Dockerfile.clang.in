# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

ARG REGISTRY
ARG TAG

#
# Intermediate container for building LLVM 13
#
FROM ${REGISTRY}/cuda11_6:${TAG} AS build

RUN curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/llvm-project-13.0.1.src.tar.xz \
   && tar xf llvm-project-13.0.1.src.tar.xz \
   && rm llvm-project-13.0.1.src.tar.xz

# Install LLVM 13.0.1 into /usr/local/llvm-13.0.1
RUN cd llvm-project-13.0.1.src \
   && cmake -Wno-dev -Bbuild -G Ninja \
   -DCMAKE_BUILD_TYPE=Release \
   -DCMAKE_INSTALL_PREFIX=/usr/local/llvm-13.0.1/ \
   -DLLVM_TARGETS_TO_BUILD="X86;NVPTX" \
   -DLLVM_ENABLE_PROJECTS=clang \
   llvm \
   && cmake --build build/ --target install

# FIXME: Remove this part
#
# This is an hack for building llvm/openmp with GNU headers.
# Debian/Ubuntu distributions use `/usr/include/x86_64-linux-gnu/{sys,bits,gnu}`
# instead of `/usr/include/{sys,bits,gnu}` to support multiple hardware by single filesystem,
# but the above `clang` does not seek there.
#
RUN cd /usr/include \
   && ln -s x86_64-linux-gnu/sys \
   && ln -s x86_64-linux-gnu/bits \
   && ln -s x86_64-linux-gnu/gnu

# Build libomptarget
RUN cd llvm-project-13.0.1.src \
   && cmake -Wno-dev -Bbuild_omp -G Ninja \
   -DCMAKE_BUILD_TYPE=Debug \
   -DCMAKE_INSTALL_PREFIX=/usr/local/llvm-13.0.1/ \
   -DCMAKE_C_COMPILER=/usr/local/llvm-13.0.1/bin/clang \
   -DCMAKE_CXX_COMPILER=/usr/local/llvm-13.0.1/bin/clang++ \
   -DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=all \
   openmp \
   && cmake --build build_omp --target install \
   && rm -rf /llvm-project-13.0.1.src

# LLVM 13.0.1 environements
RUN echo "/usr/local/llvm-13.0.1/lib" > /etc/ld.so.conf.d/llvm-13.0.1.conf \
   && ldconfig
ENV PATH /usr/local/llvm-13.0.1/bin:$PATH
ENV CC   /usr/local/llvm-13.0.1/bin/clang
ENV CXX  /usr/local/llvm-13.0.1/bin/clang++

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
# CUDA 11.6 with LLVM 13
#
FROM ${REGISTRY}/cuda11_6:${TAG} AS release

# LLVM 13.0.1 environements
COPY --from=build /usr/local/llvm-13.0.1 /usr/local/llvm-13.0.1
RUN echo "/usr/local/llvm-13.0.1/lib" > /etc/ld.so.conf.d/llvm-13.0.1.conf \
   && ldconfig
ENV PATH /usr/local/llvm-13.0.1/bin:$PATH
ENV CC   /usr/local/llvm-13.0.1/bin/clang
ENV CXX  /usr/local/llvm-13.0.1/bin/clang++

ENV ALLGEBRA_LLVM_INSTALL_DIR /usr/local/llvm-13.0.1
ENV ALLGEBRA_LLVM_VERSION 13.0.1
ENV ALLGEBRA_LLVM_VERSION_MAJOR 13
ENV ALLGEBRA_LLVM_VERSION_MINOR 0
ENV ALLGEBRA_LLVM_VERSION_PATCH 0

# Skip CPATH because this path should be treated as system directory
# See GCC manual for detail https://gcc.gnu.org/onlinedocs/cpp/Environment-Variables.html
ENV C_INCLUDE_PATH     /usr/local/llvm-13.0.1/include:$C_INCLUDE_PATH
ENV CPLUS_INCLUDE_PATH /usr/local/llvm-13.0.1/include:$CPLUS_INCLUDE_PATH

# OpenMPI environements
COPY --from=build /usr/local/ompi-4.1.0 /usr/local/ompi-4.1.0
RUN echo "/usr/local/ompi-4.1.0/lib" > /etc/ld.so.conf.d/ompi-4.1.0.conf && ldconfig
RUN mv /usr/local/ompi-4.1.0/lib/pkgconfig/* /usr/lib/pkgconfig/
ENV PATH /usr/local/ompi-4.1.0/bin:$PATH

ENV ALLGEBRA_OMPI_INSTALL_DIR /usr/local/ompi-4.1.0
ENV ALLGEBRA_OMPI_VERSION 4.1.0
ENV ALLGEBRA_OMPI_VERSION_MAJOR 4
ENV ALLGEBRA_OMPI_VERSION_MINOR 1
ENV ALLGEBRA_OMPI_VERSION_PATCH 0
