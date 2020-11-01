/**
 * Copyright 2020 RICOS Co. Ltd.
 *
 * This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
 * https://github.com/ricosjp/allgebra
 */

#include <cstdlib> // atoi, malloc
#include <cmath> // atoi, malloc
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
    x[i] = 2.0;
  }

  double ret = 0.0;

  #pragma omp target teams distribute parallel for reduction(+ : ret) map (to: x[0:size]) map(tofrom: ret)
  for (int i = 0; i < size; i++) {
      ret += std::sin(x[i]);
  }

  if (std::abs(ret - std::sin(2.0) * size) > 1.0e-6) {
    std::cout << "ret = " << ret << std::endl;
    std::cout << "error!" << std::endl;
    return 1;
  } else {
    std::cout << "ret = " << ret << std::endl;
    std::cout << "Pass!" << std::endl;
    return 0;
  }
}
