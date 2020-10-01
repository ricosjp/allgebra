# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra

cmake_minimum_required(VERSION 3.17)

project(openacc_cmake_example CXX)
set(OpenACC_ACCEL_TARGET "nvptx-none")

# FindCUDAToolkit Requires cmake >= 3.17
find_package(CUDAToolkit REQUIRED)
# FindOpenACC Requires cmake >= 3.12
find_package(OpenACC REQUIRED)

if(NOT ${OpenACC_CXX_FOUND})
  message(SEND_ERROR "OpenACC enabled C++ compiler does not exists")
endif()

if(${OpenACC_CXX_SPEC_DATE})
  message(STATUS "OpenACC Specification date = ${OpenACC_CXX_SPEC_DATE}")
endif()

add_executable(acc acc.cpp)
target_link_libraries(acc OpenACC::OpenACC_CXX)
target_compile_options(acc PUBLIC -foffload=nvptx-none="-misa=sm_35")

add_executable(acc_cublas acc_cublas.cpp)
target_link_libraries(acc_cublas OpenACC::OpenACC_CXX CUDA::cublas)
target_compile_options(acc_cublas PUBLIC -foffload=nvptx-none="-misa=sm_35")
