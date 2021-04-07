allgebra
=========

Docker images for developing C++ and Fortran HPC programs

Naming rule of tags
--------------------

Following image tags are pushed from GitLab CI to GitHub Packages (ghcr.io):

- `20.10.0` and `YY.MM.X` formatted tags
  - Corresponds to each release formatted `{year}.{month}.{patch}`.
- `latest`
  - Corresponds to `latest` branch. This will be fragile. Please use released tags.

Images
--------

Named in `allgebra/{CUDA}/{Compiler}/{Math}` format:

| Image name                                                                    | CUDA | Compiler                   | Math      |
|:------------------------------------------------------------------------------|:----:|:--------------------------:|:---------:|
| [ghcr.io/ricosjp/allgebra/cuda10_1/clang11gcc7/mkl][cuda10_1/clang11gcc7/mkl] | 10.1 | clang 11, gcc 7, nvcc 10.1 | Intel MKL |
| [ghcr.io/ricosjp/allgebra/cuda10_1/clang11gcc7/oss][cuda10_1/clang11gcc7/oss] | 10.1 | clang 11, gcc 7, nvcc 10.1 | OpenBLAS  |
| [ghcr.io/ricosjp/allgebra/cuda10_2/gcc10/mkl][cuda10_2/gcc10/mkl]             | 10.2 | gcc 10.2, nvcc 10.2        | Intel MKL |
| [ghcr.io/ricosjp/allgebra/cuda10_2/gcc10/oss][cuda10_2/gcc10/oss]             | 10.2 | gcc 10.2, nvcc 10.2        | OpenBLAS  |
| [ghcr.io/ricosjp/allgebra/cuda11_0/gcc10/mkl][cuda11_0/gcc10/mkl]             | 11.0 | gcc 10.2, nvcc 11.0        | Intel MKL |
| [ghcr.io/ricosjp/allgebra/cuda11_0/gcc10/oss][cuda11_0/gcc10/oss]             | 11.0 | gcc 10.2, nvcc 11.0        | OpenBLAS  |

[cuda10_1/clang11gcc7/mkl]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda10_1%2Fclang11gcc7%2Fmkl
[cuda10_1/clang11gcc7/oss]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda10_1%2Fclang11gcc7%2Foss
[cuda10_2/gcc10/mkl]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda10_2%2Fgcc10%2Fmkl
[cuda10_2/gcc10/oss]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda10_2%2Fgcc10%2Foss
[cuda11_0/gcc10/mkl]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda11_0%2Fgcc10%2Fmkl
[cuda11_0/gcc10/oss]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda11_0%2Fgcc10%2Foss

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

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

### CAUTION
Be sure that you need to accept [end user license agreements of CUDA][EULA_CUDA],
and [Intel Simplified Software License][ISSL] to use these containers.
You can find patched source code of GPL applications
derived from [nvidia/cuda container][nvidia/cuda] at [nvidia/OpenSource][nvidia/OpenSource].

[nvidia/cuda]: https://hub.docker.com/r/nvidia/cuda/
[nvidia/OpenSource]: https://developer.download.nvidia.com/compute/cuda/opensource/
[EULA_CUDA]: https://docs.nvidia.com/cuda/eula/index.html
[ISSL]: https://software.intel.com/content/www/us/en/develop/articles/end-user-license-agreement.html
