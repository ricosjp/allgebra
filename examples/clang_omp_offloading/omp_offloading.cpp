/**
 * Copyright 2020 RICOS Co. Ltd.
 *
 * This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
 * https://github.com/ricosjp/allgebra
 */

#include <cstdlib> // atoi, malloc
#include <iostream>

int main(int argc, char **argv) {
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
