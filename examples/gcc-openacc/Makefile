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

.PHONY: test prof clean

TARGET := acc.out acc_cublas.out
all: $(TARGET)

acc.out: acc.cpp
	$(CXX) $(ACC_FLAGS) $(CXX_FLAGS) $< -o $@
acc_cublas.out: acc_cublas.cpp
	$(CXX) $(ACC_FLAGS) $(CXX_FLAGS) $< -o $@ $(CUDA_LIBS)

test: $(TARGET)
	./acc.out 1000000
	./acc_cublas.out 1000000

prof:
	nsys nvprof ./acc_cublas.out 1000000

clean:
	rm -rf *.out
