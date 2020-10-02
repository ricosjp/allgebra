# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

#
# This file must be combined with cuda*.Dockerfiles like following:
#
# ```
# cat cuda10_2.Dockerfiles mkl.Dockerfiles annotations.Dockerfiles > cuda10_2-mkl.Dockerfiles
# docker build -f cuda10_2-mkl.Dockerfiles
# ```
#
RUN apt-get update && apt-get install -y \
    intel-mkl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
