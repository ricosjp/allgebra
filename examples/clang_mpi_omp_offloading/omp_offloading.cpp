/**
 * Copyright 2020 RICOS Co. Ltd.
 *
 * This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
 * https://github.com/ricosjp/allgebra
 */

#include <cstdlib> // atoi, malloc
#include <iostream>
#include <mpi.h>

int main(int argc, char **argv) {
  int my_rank, numproc;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
  MPI_Comm_size(MPI_COMM_WORLD, &numproc);

  int size = 0;
  if (argc == 2) {
    size = std::atoi(argv[1]);
  } else {
    std::cout << "error, $1 is vector size" << std::endl;
    return 1;
  }

  double *x = (double *)malloc(sizeof(double) * size);
  double *y = (double *)malloc(sizeof(double) * size);

  for (int i = 0; i < size; i++) {
    x[i] = 1.0;
    y[i] = 2.0;
  }

  double dot = 0.0;

  #pragma omp target teams distribute parallel for reduction(+ : dot) map (to: x[0:size], y[0:size]) map(tofrom: dot)
  for (int i = 0; i < size; i++) {
      dot += x[i] * y[i];
  }
  MPI_Allreduce(&dot,&dot,1,MPI_DOUBLE,MPI_SUM,MPI_COMM_WORLD);

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
