# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

# GCC OpenMP Offloading Settings
CXX       := mpic++
CXX_FLAGS := -O3 -std=c++11 -lm
SM ?= $(shell allgebra_get_device_cc)
OMP_FLAGS := -fopenmp -fopenmp-targets=nvptx64 -Xopenmp-target -march=sm_$(SM)

# Additional CUDA libraries for cuBLAS example
CUDA_LIBS := -lcuda -lcublas -lcudart

.PHONY: test prof clean

TARGET := omp_offloading.out omp_offloading_cublas.out omp_offloading_math.out
all: $(TARGET)

omp_offloading.out: omp_offloading.cpp
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/usr/local/lib $(CXX) $(OMP_FLAGS) $(CXX_FLAGS) $< -o $@

omp_offloading_cublas.out: omp_offloading_cublas.cpp
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/usr/local/lib $(CXX) $(OMP_FLAGS) $(CXX_FLAGS) $< -o $@ $(CUDA_LIBS)
 
omp_offloading_math.out: omp_offloading_math.cpp
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/usr/local/lib $(CXX) $(OMP_FLAGS) $(CXX_FLAGS) $< -o $@ 

test: $(TARGET)
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/usr/local/lib mpirun --allow-run-as-root -np 2 ./omp_offloading.out 10000000
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/usr/local/lib mpirun --allow-run-as-root -np 2 ./omp_offloading_cublas.out 10000000
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/usr/local/lib mpirun --allow-run-as-root -np 2 ./omp_offloading_cublas.out 10000000
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/usr/local/lib mpirun --allow-run-as-root -np 3 ./omp_offloading.out 10000000
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/usr/local/lib mpirun --allow-run-as-root -np 3 ./omp_offloading_cublas.out 10000000
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/usr/local/lib mpirun --allow-run-as-root -np 3 ./omp_offloading_cublas.out 10000000

debug: $(TARGET)
	LIBOMPTARGET_DEBUG=1 ./omp_offloading_cublas.out 1000000

prof: $(TARGET)
	nsys nvprof ./omp_offloading_cublas.out 1000000

in:
	docker run -it --gpus all -v $(PWD):/test/ -w /test/ ghcr.io/ricosjp/allgebra/cuda10_1/clang11gcc7/mkl:latest

clean:
	rm -rf *.out

