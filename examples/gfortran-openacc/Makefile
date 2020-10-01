# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

# GCC-Fortran OpenACC Settings
FC        := gfortran
FC_FLAGS  := -O3 -std=f2018
ACC_FLAGS := -fopenacc -foffload=nvptx-none="-misa=sm_35"

TARGET = acc.out

all: $(TARGET)

acc.out: acc.f90
	$(FC) $(ACC_FLAGS) $(FC_FLAGS) $< -o $@

test: $(TARGET)
	./acc.out 1000000

clean:
	rm *.out
