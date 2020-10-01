# FindOpenACC Requires 3.12
# FindCUDAToolkit Requires 3.17
cmake_minimum_required(VERSION 3.17)

project(openacc_cmake_example CXX)

set(OpenACC_ACCEL_TARGET "nvptx-none")

find_package(CUDAToolkit REQUIRED)
find_package(OpenACC REQUIRED)

if(NOT ${OpenACC_CXX_FOUND})
  message(SEND_ERROR "OpenACC enabled C++ compiler does not exists")
endif()

if(NOT ${OpenACC_Fortran_FOUND})
  message(SEND_ERROR "OpenACC enabled Fortran compiler does not exists")
endif()

# OpenACC Specification
#
# - Version 2.5: 201510
# - Version 2.6: 201711
# - Version 2.7: 201811
if(${OpenACC_CXX_SPEC_DATE})
  message(STATUS "OpenACC Specification date = ${OpenACC_CXX_SPEC_DATE}")
endif()

add_executable(acc acc.cpp)
target_link_libraries(acc OpenACC::OpenACC_CXX)
target_compile_options(acc PUBLIC -foffload=nvptx-none="-misa=sm_35")

add_executable(acc_cublas acc_cublas.cpp)
target_link_libraries(acc_cublas OpenACC::OpenACC_CXX CUDA::cublas)
target_compile_options(acc_cublas PUBLIC -foffload=nvptx-none="-misa=sm_35")
