#!/bin/bash

OS_VERSION=20.04

CUDA_MAJOR=11
CUDA_MINOR=6
CUDA_PATCH=2

CLANG_MAJOR=13
CLANG_MINOR=0
CLANG_PATCH=1

GCC_MAJOR=10
GCC_MINOR=3
GCC_PATCH=0

OMPI_MAJOR=4
OMPI_MINOR=1
OMPI_PATCH=0

CMAKE_MAJOR=3
CMAKE_MINOR=21
CMAKE_PATCH=3

rm -rf ./cuda${CUDA_MAJOR}_${CUDA_MINOR}

#
# generate blas files
#

# cuda clang mkl
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/clang${CLANG_MAJOR}/mkl
TARGET_COMPILER=clang; TARGET_MAJOR=${CLANG_MAJOR}; ALLGEBRA_TARGET=${TARGET_DIR}
mkdir -p $TARGET_DIR
eval "echo \"$(cat ./Dockerfile.mkl.in)\"" > $TARGET_DIR/Dockerfile
eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile

# cuda clang oss
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/clang${CLANG_MAJOR}/oss
TARGET_COMPILER=clang; TARGET_MAJOR=${CLANG_MAJOR}; ALLGEBRA_TARGET=${TARGET_DIR}
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
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/clang${CLANG_MAJOR}
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
