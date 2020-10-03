allgebra
=========

Docker images for developing C++ and Fortran HPC programs

Naming rule of tags
--------------------

Following image tags are pushed from GitLab CI:

- `20.10.0` and `YY.MM.X` formatted tags
  - Corresponds to each release formatted `{year}.{month}.{patch}`.
- `latest`
  - Corresponds to `latest` branch. This will be fragile. Please use released tags.

Images
--------

Named in `allgebra/{CUDA}/{MATH}` format:

Supported CUDA Versions:

- 10.2
- 11.0

Supported mathematical library backends:

- Intel(R) MKL (mkl)
- Combine OSS libraries (oss)
  - OpenBLAS, ...

### allgebra/cuda10_2/mkl

OpenACC NVPTX-offload supported GCC with CUDA 10.2

```
docker pull ghcr.io/ricosjp/allgebra/cuda10_2/mkl:20.10.0
```

| Software  | Version                       |
|:----------|:------------------------------|
| Ubuntu    | 20.04                         |
| GCC       | 9.3 (OpenMP 4.5, OpenACC 2.0) |
| cmake     | 3.18.2                        |
| CUDA      | 10.2                          |
| Intel MKL | 2020.0.166                    |

### allgebra/cuda11_0/mkl

OpenACC NVPTX-offload supported GCC with CUDA 11.0

```
docker pull ghcr.io/ricosjp/allgebra/cuda11_0/mkl:20.10.0
```

| Software  | Version                       |
|:----------|:------------------------------|
| Ubuntu    | 20.04                         |
| GCC       | 9.3 (OpenMP 4.5, OpenACC 2.0) |
| cmake     | 3.18.2                        |
| CUDA      | 11.0                          |
| Intel MKL | 2020.0.166                    |

### allgebra/cuda10_2/oss

OpenACC NVPTX-offload supported GCC with CUDA 10.2

```
docker pull ghcr.io/ricosjp/allgebra/cuda10_2/oss:20.10.0
```

| Software  | Version                       |
|:----------|:------------------------------|
| Ubuntu    | 20.04                         |
| GCC       | 9.3 (OpenMP 4.5, OpenACC 2.0) |
| cmake     | 3.18.2                        |
| CUDA      | 10.2                          |
| OpenBLAS  | 3.8.0                         |

### allgebra/cuda11_0/oss

OpenACC NVPTX-offload supported GCC with CUDA 11.0

```
docker pull ghcr.io/ricosjp/allgebra/cuda11_0/oss:20.10.0
```

| Software  | Version                       |
|:----------|:------------------------------|
| Ubuntu    | 20.04                         |
| GCC       | 9.3 (OpenMP 4.5, OpenACC 2.0) |
| cmake     | 3.18.2                        |
| CUDA      | 11.0                          |
| OpenBLAS  | 3.8.0                         |

Support Images
---------------

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

License
--------

Copyright 2020 RICOS Co. Ltd.

ricosjp/allgebra itself is distributed under Apache-2.0. See [LICENSE](./LICENSE).

Be sure that you need to accept [end user license agreements of CUDA][EULA_CUDA],
and [Intel Simplified Software License][ISSL] to use these containers.
You can find patched source code of GPL applications
derived from [nvidia/cuda container][nvidia/cuda] at [nvidia/OpenSource][nvidia/OpenSource].

[nvidia/cuda]: https://hub.docker.com/r/nvidia/cuda/
[nvidia/OpenSource]: https://developer.download.nvidia.com/compute/cuda/opensource/
[EULA_CUDA]: https://docs.nvidia.com/cuda/eula/index.html
[ISSL]: https://software.intel.com/content/www/us/en/develop/articles/end-user-license-agreement.html
