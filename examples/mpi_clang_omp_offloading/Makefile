# Copyright 2021 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

#
# Detect the compute capability of system's GPU
#
# See also the official document
# https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#compute-capability
#
COMPUTE_CAPABILITY := $(shell allgebra_get_device_cc)
ifeq ($(COMPUTE_CAPABILITY),)
$(error "allgebra_get_device_cc failed to find GPU")
endif

# GCC OpenMP Offloading Settings
CXX       := mpic++
CXX_FLAGS := -O3 -std=c++11 -lm
OMP_FLAGS := -fopenmp -fopenmp-targets=nvptx64 -Xopenmp-target -march=sm_$(COMPUTE_CAPABILITY)

# Additional CUDA libraries for cuBLAS example
CUDA_LIBS := -lcuda -lcublas -lcudart

.PHONY: test prof clean

TARGET := omp_offloading.out omp_offloading_cublas.out omp_offloading_math.out
all: $(TARGET)

omp_offloading.out: omp_offloading.cpp
	$(CXX) $(OMP_FLAGS) $(CXX_FLAGS) $< -o $@

omp_offloading_cublas.out: omp_offloading_cublas.cpp
	$(CXX) $(OMP_FLAGS) $(CXX_FLAGS) $< -o $@ $(CUDA_LIBS)

omp_offloading_math.out: omp_offloading_math.cpp
	$(CXX) $(OMP_FLAGS) $(CXX_FLAGS) $< -o $@ 

test: $(TARGET)
	mpirun --allow-run-as-root -np 2 ./omp_offloading.out 10000000
	mpirun --allow-run-as-root -np 2 ./omp_offloading_cublas.out 10000000
	mpirun --allow-run-as-root -np 2 ./omp_offloading_math.out 10000000

debug: $(TARGET)
	LIBOMPTARGET_DEBUG=1 ./omp_offloading_cublas.out 1000000

prof: $(TARGET)
	nsys nvprof ./omp_offloading_cublas.out 1000000

in:
	docker run -it --gpus all -v $(PWD):/test/ -w /test/ ghcr.io/ricosjp/allgebra/cuda10_1/clang11gcc7/mkl:latest

clean:
	rm -rf *.out

