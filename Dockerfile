FROM nvidia/cuda:11.0-devel-ubuntu20.04
LABEL maintainer "Toshiaki Hishinuma <hishinuma.toshiaki@gmail.com>"

# workaround for tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Install MKL
# https://software.intel.com/content/www/us/en/develop/articles/installing-intel-free-libs-and-python-apt-repo.html
RUN curl -sfL https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB | apt-key add -
RUN curl -sfL https://apt.repos.intel.com/setup/intelproducts.list -o /etc/apt/sources.list.d/intelproducts.list

RUN apt-get update && apt-get install -y \
    make cmake \
    gcc-9-offload-nvptx nvptx-tools g++-9 gfortran-9 \
    cuda-nsight-systems-11-0 \
    libopenblas-openmp-dev \
    python3 python3-yaml python3-numpy \
    linux-tools-generic strace trace-cmd valgrind gdb \
    intel-mkl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# To validate container is well-constructed
COPY test/ /test
