#!/bin/bash

OS_VERSION=22.04

CUDA_MAJOR=11
CUDA_MINOR=7
CUDA_PATCH=0

LLVM_MAJOR=14
LLVM_MINOR=0
LLVM_PATCH=4

GCC_MAJOR=11
GCC_MINOR=2
GCC_PATCH=0

OMPI_MAJOR=4
OMPI_MINOR=1
OMPI_PATCH=3

CMAKE_MAJOR=3
CMAKE_MINOR=23
CMAKE_PATCH=1

rm -rf ./cuda${CUDA_MAJOR}_${CUDA_MINOR}

#
# generate blas files
#

# cuda clang mkl
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/clang${LLVM_MAJOR}/mkl
TARGET_COMPILER=clang; TARGET_MAJOR=${LLVM_MAJOR}; ALLGEBRA_TARGET=${TARGET_DIR}
mkdir -p $TARGET_DIR
eval "echo \"$(cat ./Dockerfile.mkl.in)\"" > $TARGET_DIR/Dockerfile
eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile

# cuda clang oss
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/clang${LLVM_MAJOR}/oss
TARGET_COMPILER=clang; TARGET_MAJOR=${LLVM_MAJOR}; ALLGEBRA_TARGET=${TARGET_DIR}
mkdir -p $TARGET_DIR
eval "echo \"$(cat ./Dockerfile.oss.in)\"" > $TARGET_DIR/Dockerfile
eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile

# cuda gcc mkl
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/gcc${GCC_MAJOR}/mkl
TARGET_COMPILER=gcc; TARGET_MAJOR=${GCC_MAJOR}; ALLGEBRA_TARGET=${TARGET_DIR}
mkdir -p $TARGET_DIR
eval "echo \"$(cat ./Dockerfile.mkl.in)\"" > $TARGET_DIR/Dockerfile
eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile

# cuda gcc oss
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/gcc${GCC_MAJOR}/oss
TARGET_COMPILER=gcc; TARGET_MAJOR=${GCC_MAJOR}; ALLGEBRA_TARGET=${TARGET_DIR}
mkdir -p $TARGET_DIR
eval "echo \"$(cat ./Dockerfile.oss.in)\"" > $TARGET_DIR/Dockerfile
eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile

#
# generate gcc/clang files
#

# cuda clang
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/clang${LLVM_MAJOR}
mkdir -p $TARGET_DIR
eval "echo \"$(cat ./Dockerfile.clang.in)\"" > $TARGET_DIR/Dockerfile
ALLGEBRA_TARGET=${TARGET_DIR}; eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile

# cuda gcc
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/gcc${GCC_MAJOR}
mkdir -p $TARGET_DIR
eval "echo \"$(cat ./Dockerfile.gcc.in)\"" > $TARGET_DIR/Dockerfile
ALLGEBRA_TARGET=${TARGET_DIR}; eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile

#
# generate cuda files
#
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}
mkdir -p $TARGET_DIR
eval "echo \"$(cat ./Dockerfile.cuda.in)\"" > ${TARGET_DIR}/Dockerfile
ALLGEBRA_TARGET=${TARGET_DIR}; eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile
