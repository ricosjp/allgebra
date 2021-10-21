/**
 * Copyright 2020 RICOS Co. Ltd.
 *
 * This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
 * https://github.com/ricosjp/allgebra
 */

#include <cstdlib> // atoi, malloc
#include <iostream>
#include <omp.h>

int main(int argc, char **argv) {
  int size = 0;
  if (argc == 2) {
    size = std::atoi(argv[1]);
  } else {
    std::cout << "error, $1 is vector size" << std::endl;
    return 1;
  }

  if (omp_is_initial_device()) {
    printf("CPU now\n");
  } else {
    return 1;
  }

  double *x = (double *)malloc(sizeof(double) * size);
  double *y = (double *)malloc(sizeof(double) * size);

  for (int i = 0; i < size; i++) {
    x[i] = 1.0;
    y[i] = 2.0;
  }

  double dot = 0.0;

  printf("devices %d / %d\n", omp_get_default_device(),
         omp_get_num_devices() - 1);

  printf("GPU start\n");
#pragma omp target teams distribute parallel for reduction(+ : dot) map (to: x[0:size], y[0:size]) map(tofrom: dot)
  for (int i = 0; i < size; i++) {

    if (omp_is_initial_device()) {
      printf("omp offloading is not work\n");
    } else {
      int tid =
          omp_get_team_num() * omp_get_num_threads() + omp_get_thread_num();
      // cat use std::cout in omp target
      printf("i=%d: tid = %d (team %d/%d, thread %d/%d)\n", i, tid,
             omp_get_team_num(), omp_get_num_teams() - 1, omp_get_thread_num(),
             omp_get_num_threads() - 1);
    }

    dot += x[i] * y[i];
  }

  if (dot != 2.0 * size) {
    std::cout << "dot = " << dot << std::endl;
    std::cout << "error!" << std::endl;
    return 1;
  } else {
    std::cout << "dot = " << dot << std::endl;
    std::cout << "Pass!" << std::endl;
    return 0;
  }
}
