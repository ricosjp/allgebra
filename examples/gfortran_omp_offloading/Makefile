# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

# GCC-Fortran OpenMP Offloading Settings
FC        := gfortran
FC_FLAGS  := -O3 -std=f2018
OMP_FLAGS := -fopenmp -fno-stack-protector -foffload=nvptx-none="-O3 -misa=sm_35"

TARGET = omp_offloading.out

all: $(TARGET)

omp_offloading.out: omp_offloading.f90
	$(FC) $(OMP_FLAGS) $(FC_FLAGS) $< -o $@

test: $(TARGET)
	./omp_offloading.out 1000000

clean:
	rm *.out
