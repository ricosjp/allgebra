# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra

cmake_minimum_required(VERSION 3.17)

project(openacc_cmake_example Fortran)

set(OpenACC_ACCEL_TARGET "nvptx-none")

# FindOpenACC Requires cmake >= 3.12
find_package(OpenACC REQUIRED)

if(NOT ${OpenACC_Fortran_FOUND})
  message(SEND_ERROR "OpenACC enabled Fortran compiler does not exists")
endif()

if(${OpenACC_Fortran_SPEC_DATE})
  message(STATUS "OpenACC Specification date = ${OpenACC_CXX_SPEC_DATE}")
endif()

add_executable(acc_fortran acc_fortran.f90)
target_link_libraries(acc_fortran OpenACC::OpenACC_Fortran)
target_compile_options(acc_fortran PUBLIC -foffload=nvptx-none="-misa=sm_35")
