# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

FROM ubuntu:20.04

#
# Variables set in Makefile
#
ARG ALLGEBRA_VERSION
ARG BUILD_DATE
ARG GIT_HASH

#
# Annotations based on OCI specification
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
#
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.authors="Toshiki Teramura <teramura@ricos.co.jp>"
LABEL org.opencontainers.image.url="https://github.com/ricosjp/allgebra"
LABEL org.opencontainers.image.documentation="Base container for developing C++ and Fortran HPC applications"
LABEL org.opencontainers.image.source="https://github.com/ricosjp/allgebra/blob/latest/cuda10_2.Dockerfile"
LABEL org.opencontainers.image.version=$ALLGEBRA_VERSION
LABEL org.opencontainers.image.revision=$GIT_HASH
LABEL org.opencontainers.image.vendor="RICOS Co. Ltd."

# workaround for tzdata
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git clang-format \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY check-format.sh /usr/bin
