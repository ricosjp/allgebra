# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

# GCC OpenACC Settings
CXX       := g++
CXX_FLAGS := -O3 -std=c++11
ACC_FLAGS := -fopenacc -foffload=nvptx-none="-misa=sm_35"

# Additional CUDA libraries for cuBLAS example
CUDA_LIBS := -lcuda -lcublas -lcudart

# Use allgebra image
DOCKER_IMAGE := ghcr.io/ricosjp/allgebra/cuda10_2:latest
# Use current UID:GID also in container
DOCKER_USER_FLAG := -u `id -u`:`id -g`
# Mount current directory onto container
DOCKER_MOUNT_FLAG := -v $(PWD):$(PWD)
# Change working directory of container process
DOCKER_WORKDIR_FLAG := -w $(PWD)

DOCKER_FLAGS := $(DOCKER_USER_FLAG) $(DOCKER_MOUNT_FLAG) $(DOCKER_WORKDIR_FLAG)

TARGET := acc.out acc_cublas.out
all: $(TARGET)

# Target for building actual in docker
acc.out: acc.cpp
	docker run --rm $(DOCKER_FLAGS) $(DOCKER_IMAGE) $(CXX) $(ACC_FLAGS) $(CXX_FLAGS) $< -o $@
acc_cublas.out: acc_cublas.cpp
	docker run --rm $(DOCKER_FLAGS) $(DOCKER_IMAGE) $(CXX) $(ACC_FLAGS) $(CXX_FLAGS) $< -o $@ $(CUDA_LIBS)

test: $(TARGET)
	./acc.out 1000000
	./acc_cublas.out 1000000

prof:
	docker run --rm $(DOCKER_FLAGS) $(DOCKER_IMAGE) nsys nvprof ./acc_cublas.out 1000000

# Trigger for cmake
cmake:
	docker run --rm $(DOCKER_FLAGS) $(DOCKER_IMAGE) \
		bash -c "cmake -Bbuild .; cmake --build build"

clean:
	rm -rf *.out build/
