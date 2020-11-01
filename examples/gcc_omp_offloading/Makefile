# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

# GCC OpenMP Offloading Settings
CXX       := g++
CXX_FLAGS := -O3 -std=c++11
CXX_FLAGS += -fcf-protection=none  # cf-protection is not supported for omp_offloading
OMP_FLAGS := -fopenmp -fno-stack-protector -foffload=nvptx-none="-O3 -misa=sm_35 -lm"

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
	$(CXX) $(OMP_FLAGS) $(CXX_FLAGS) $< -o $@ $(CUDA_LIBS)

test: $(TARGET)
	./omp_offloading.out 1000000
	./omp_offloading_cublas.out 1000000
	./omp_offloading_math.out 1000000

prof: $(TARGET)
	nsys nvprof ./omp_offloading_cublas.out 1000000

clean:
	rm -rf *.out
