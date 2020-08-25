FROM nvidia/cuda:11.0-devel-ubuntu20.04 AS base-devel
LABEL maintainer "Toshiaki Hishinuma <hishinuma.toshiaki@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    make cmake \
    gcc-9-offload-nvptx nvptx-tools g++-9 gfortran-9 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

FROM base-devel AS frontend
RUN apt-get update && apt-get install -y \
    cuda-nsight-systems-11-0 \
    python3 python3-yaml python3-numpy \
    linux-tools-common strace trace-cmd valgrind gdb \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
