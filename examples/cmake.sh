#!/bin/bash
# Entrypoint for testing in docker
set -eux

cmake -Bbuild /test
cmake --build build

./build/acc_naked   1000000
./build/acc_fortran 1000000
./build/acc_cublas  1000000
