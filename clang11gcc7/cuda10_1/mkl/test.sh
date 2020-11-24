#!/bin/bash
set -eu

echo_log () {
  echo -e "\e[32m$1\e[m"
}

# Compilers
echo_log "CC=${CC}"
${CC}  --version
echo_log "CXX=${CXX}"
${CXX} --version
echo_log "FC=${FC}"
${FC}  --version
echo_log "nvcc=$(which nvcc)"
nvcc  --version

echo_log "Environment variables"
echo "CPATH              : ${CPATH}"
echo "C_INCLUDE_PATH     : ${C_INCLUDE_PATH}"
echo "CPLUS_INCLUDE_PATH : ${CPLUS_INCLUDE_PATH}"

SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})
ALLGEBRA_TOPDIR=$(readlink -f $SCRIPT_DIR/../../..)

echo_log "Test examples/clang_omp_offloading"
cd ${ALLGEBRA_TOPDIR}/examples/clang_omp_offloading
  make clean
  make
  make debug
cd -
