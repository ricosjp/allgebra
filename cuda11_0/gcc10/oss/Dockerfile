# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

ARG REGISTRY
ARG TAG

FROM ${REGISTRY}/cuda11_0-gcc10:${TAG}

# OSS OpenBLAS
RUN apt-get update && apt-get install -y \
    libopenblas-openmp-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
