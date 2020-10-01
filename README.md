allgebra
=========

Docker images for developing C++ and Fortran HPC programs

Naming rule of tags
--------------------

Following image tags are pushed from GitLab CI:

- `0.1.0` and other tags
  - Corresponds to each release
- `latest` = `master`
  - Corresponds to latest `master` branch. This will be fragile. Please use released tags.
- `branch_name`
  - Corresponds to each branch name. Please use only for test purpose.

Images
--------

### allgebra/cuda10_2

OpenACC NVPTX-offload supported GCC with CUDA 10.2

```
docker pull ghcr.io/ricosjp/allgebra/cuda10_2:latest
```

| Software  | Version                       |
|:----------|:------------------------------|
| Ubuntu    | 20.04                         |
| GCC       | 9.3 (OpenMP 4.5, OpenACC 2.0) |
| cmake     | 3.18.2                        |
| CUDA      | 10.2                          |
| OpenBLAS  | 3.8.0                         |
| Intel MKL | 2020.0.166                    |

### allgebra/cuda11_0

OpenACC NVPTX-offload supported GCC with CUDA 11.0

```
docker pull ghcr.io/ricosjp/allgebra/cuda11_0:latest
```

| Software  | Version                       |
|:----------|:------------------------------|
| Ubuntu    | 20.04                         |
| GCC       | 9.3 (OpenMP 4.5, OpenACC 2.0) |
| cmake     | 3.18.2                        |
| CUDA      | 11.0                          |
| OpenBLAS  | 3.8.0                         |
| Intel MKL | 2020.0.166                    |

### allgebra/clang-format

Container for reproducible code formatting

```
docker pull ghcr.io/ricosjp/allgebra/clang-format:latest
```

### allgebra/doxygen

Container for reproducible document generation

```
docker pull ghcr.io/ricosjp/allgebra/doxygen:latest
```
