/**
 * Copyright 2020 RICOS Co. Ltd.
 *
 * This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
 * https://github.com/ricosjp/allgebra
 */

#include <cstdlib> // atoi, malloc
#include <cublas_v2.h>
#include <iostream>
#include <mpi.h>
#include <omp.h>

int main(int argc, char **argv) {
  int size = 0;
  if (argc == 2) {
    size = std::atoi(argv[1]);
  } else {
    std::cout << "error, $1 is vector size" << std::endl;
    return 1;
  }

  int my_rank, numproc;
  MPI_Init(NULL, NULL);
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
  MPI_Comm_size(MPI_COMM_WORLD, &numproc);

  size_t devices = omp_get_num_devices();
  size_t device = my_rank % devices;
  omp_set_default_device(device);

  std::cout << "rank = " << my_rank << ", device = " << device << std::endl;

  double *x = (double *)malloc(sizeof(double) * size);
  double *y = (double *)malloc(sizeof(double) * size);

  for (int i = 0; i < size; i++) {
    x[i] = 1.0;
    y[i] = 2.0;
  }

  double dot = 0.0;

#pragma omp target enter data map(to : x [0:size], y [0:size])
#pragma omp target data use_device_ptr(x, y)
  {
    cublasHandle_t h;
    cublasCreate(&h);
    cublasDdot(h, size, x, 1, y, 1, &dot);
    cublasDestroy(h);
  }

  MPI_Allreduce(&dot, &dot, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);

  if (dot != 2.0 * size * numproc) {
    std::cout << "dot = " << dot << std::endl;
    std::cout << "error!" << std::endl;
    MPI_Finalize();
    return 1;
  } else {
    std::cout << "dot = " << dot << std::endl;
    std::cout << "Pass!" << std::endl;
    MPI_Finalize();
    return 0;
  }
}
