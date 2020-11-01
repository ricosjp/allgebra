# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

FROM ubuntu:20.04

# workaround for tzdata
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git clang-format \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY check_format.sh /usr/bin
