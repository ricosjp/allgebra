# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

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
LABEL maintainer="RICOS Co. Ltd." \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.authors="RICOS Co. Ltd." \
      org.opencontainers.image.url="https://github.com/ricosjp/allgebra" \
      org.opencontainers.image.documentation="Base container for developing C++ and Fortran HPC applications" \
      org.opencontainers.image.source="https://github.com/ricosjp/allgebra/blob/latest/cuda10_2.Dockerfile" \
      org.opencontainers.image.version=$ALLGEBRA_VERSION \
      org.opencontainers.image.revision=$GIT_HASH \
      org.opencontainers.image.vendor="RICOS Co. Ltd."
