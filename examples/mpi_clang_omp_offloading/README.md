# OpenMP Offloading Example for C++, clang, MPI

in allgebra:
```
sh ./install_mpi.sh
make -j
make test
```

|Example                                                 | Description                                   |
|:-------------------------------------------------------|:----------------------------------------------|
|[omp_offloading.cpp](./omp_offloading.cpp)              | Minimal example for testing OpenMP Offloading |
|[omp_offloading_cublas.cpp](./omp_offloading_cublas.cpp)| Use OpenMP Offloading with CUDA libraries     |
|[omp_offloading_math.cpp](./omp_offloading_math.cpp)    | Use OpenMP Offloading with math libraries     |

See comments in [Makefile](./Makefile) for detail.
