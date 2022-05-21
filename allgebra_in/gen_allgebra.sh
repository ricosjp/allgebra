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

CMAKE_MAJOR=3
CMAKE_MINOR=21
CMAKE_PATCH=3

rm -rf ./cuda${CUDA_MAJOR}_${CUDA_MINOR}

# cuda clang mkl
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/clang${CLANG_MAJOR}/mkl
mkdir -p $TARGET_DIR
TARGET_COMPILER=clang; eval "echo \"$(cat ./Dockerfile.mkl.in)\"" > $TARGET_DIR/Dockerfile
ALLGEBRA_TARGET=${TARGET_DIR}; eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile

# cuda clang oss
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/clang${CLANG_MAJOR}/oss
mkdir -p $TARGET_DIR
TARGET_COMPILER=clang; eval "echo \"$(cat ./Dockerfile.oss.in)\"" > $TARGET_DIR/Dockerfile
ALLGEBRA_TARGET=${TARGET_DIR}; eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile

# cuda gcc mkl
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/gcc${GCC_MAJOR}/mkl
mkdir -p $TARGET_DIR
TARGET_COMPILER=gcc; eval "echo \"$(cat ./Dockerfile.mkl.in)\"" > $TARGET_DIR/Dockerfile
ALLGEBRA_TARGET=${TARGET_DIR}; eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile

# cuda gcc oss
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}/gcc${GCC_MAJOR}/oss
mkdir -p $TARGET_DIR
TARGET_COMPILER=gcc; eval "echo \"$(cat ./Dockerfile.oss.in)\"" > $TARGET_DIR/Dockerfile
ALLGEBRA_TARGET=${TARGET_DIR}; eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile

# cuda clang
# cuda gcc

# cuda
TARGET_DIR=cuda${CUDA_MAJOR}_${CUDA_MINOR}
mkdir -p $TARGET_DIR
eval "echo \"$(cat ./Dockerfile.cuda.in)\"" > ${TARGET_DIR}/Dockerfile
ALLGEBRA_TARGET=${TARGET_DIR}; eval "echo \"$(cat ./Makefile.in)\"" > $TARGET_DIR/Makefile
