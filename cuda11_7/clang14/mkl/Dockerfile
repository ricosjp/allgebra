# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra

# This file is automatically generated by allgebra_template/gen_allgebra.sh

ARG REGISTRY
ARG TAG

FROM ${REGISTRY}/cuda11_7-clang14:${TAG}

# Intel MKL
RUN apt-get update && apt-get install -y \
    intel-mkl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
