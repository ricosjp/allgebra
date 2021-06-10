allgebra
=========

Docker images for developing C++ and Fortran HPC programs

Naming rule of tags
--------------------

Following image tags are pushed from private GitLab CI to public GitHub Container Registry (ghcr.io):

- `{year}.{month}.{patch}` formatted tags, e.g. `20.10.0`
  - Be sure that **it is not a [semantic versioning][semver]**. Every release can be a breaking change. You should use containers with a fixed tag.
  - See [CHANGELOG](./CHANGELOG.md) for detail about changes
- `latest`
  - Corresponds to `latest` branch. **DO NOT USE** unless you are watching all changes in the `latest` branch.

[semver]: https://semver.org/

Images
--------

Named in `allgebra/{GPU}/{Compiler}/{Math}` format:

| Image name                                                            | CUDA | Compiler            | Math      |
|:----------------------------------------------------------------------|:----:|:-------------------:|:---------:|
| [ghcr.io/ricosjp/allgebra/cuda10_1/clang12/mkl][cuda10_1/clang12/mkl] | 10.1 | clang 12, nvcc 10.1 | Intel MKL |
| [ghcr.io/ricosjp/allgebra/cuda10_1/clang12/oss][cuda10_1/clang12/oss] | 10.1 | clang 12, nvcc 10.1 | OpenBLAS  |
| [ghcr.io/ricosjp/allgebra/cuda10_2/gcc10/mkl][cuda10_2/gcc10/mkl]     | 10.2 | gcc 10.2, nvcc 10.2 | Intel MKL |
| [ghcr.io/ricosjp/allgebra/cuda10_2/gcc10/oss][cuda10_2/gcc10/oss]     | 10.2 | gcc 10.2, nvcc 10.2 | OpenBLAS  |
| [ghcr.io/ricosjp/allgebra/cuda11_0/gcc10/mkl][cuda11_0/gcc10/mkl]     | 11.0 | gcc 10.2, nvcc 11.0 | Intel MKL |
| [ghcr.io/ricosjp/allgebra/cuda11_0/gcc10/oss][cuda11_0/gcc10/oss]     | 11.0 | gcc 10.2, nvcc 11.0 | OpenBLAS  |

[cuda10_1/clang12/mkl]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda10_1%2Fclang12%2Fmkl
[cuda10_1/clang12/oss]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda10_1%2Fclang12%2Foss
[cuda10_2/gcc10/mkl]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda10_2%2Fgcc10%2Fmkl
[cuda10_2/gcc10/oss]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda10_2%2Fgcc10%2Foss
[cuda11_0/gcc10/mkl]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda11_0%2Fgcc10%2Fmkl
[cuda11_0/gcc10/oss]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda11_0%2Fgcc10%2Foss

In addition, there are support containers for reproducible development

| Image name                                                     | Application                 |
|:---------------------------------------------------------------|:----------------------------|
| [ghcr.io/ricosjp/allgebra/clang-format][allgebra/clang-format] | [clang-format][clang-format]|
| [ghcr.io/ricosjp/allgebra/doxygen][allgebra/doxygen]           | [doxygen][doxygen]          |

[allgebra/clang-format]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fclang-format
[allgebra/doxygen]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fdoxygen
[clang-format]: https://clang.llvm.org/docs/ClangFormat.html
[doxygen]: https://www.doxygen.nl/index.html

OpenMP Offloading, OpenACC
---------------------------
The OSS compilers in allgebra containers (gcc, gfortran and clang) are compiled with OpenMP and OpenACC supports.
There are several examples in this repository, and they are also copied into the above containers.

| Compiler         | OpenMP Offloading                                             | OpenACC                                         |
|:-----------------|:--------------------------------------------------------------|:------------------------------------------------|
| clang/libomp     | [clang_omp_offloading](./examples/clang_omp_offloading)       | -                                               |
| gcc/libgomp      | [gcc_omp_offloading](./examples/gcc_omp_offloading)           | [gcc_openacc](./examples/gcc_openacc)           |
| gfortran/libgomp | [gfortran_omp_offloading](./examples/gfortran_omp_offloading) | [gfortran_openacc](./examples/gfortran_openacc) |

The requirements of these examples are following:

- Use Linux
- Install [Docker](https://docs.docker.com/engine/install/)
- Install [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker)

For example, you can build and run the clang with OpenMP Offloading example as following:

```
$ docker run --rm -it --gpus=all ghcr.io/ricosjp/allgebra/cuda10_1/clang12/oss:21.06.0
root@41b65ab23aaf:/# cd /examples/clang_omp_offloading
root@41b65ab23aaf:/examples/clang_omp_offloading# make test
clang++ -fopenmp -fopenmp-targets=nvptx64 -Xopenmp-target -march=sm_70 -O3 -std=c++11 -lm omp_offloading.cpp -o omp_offloading.out
clang++ -fopenmp -fopenmp-targets=nvptx64 -Xopenmp-target -march=sm_70 -O3 -std=c++11 -lm omp_offloading_cublas.cpp -o omp_offloading_cublas.out -lcuda -lcublas -lcudart
clang++ -fopenmp -fopenmp-targets=nvptx64 -Xopenmp-target -march=sm_70 -O3 -std=c++11 -lm omp_offloading_math.cpp -o omp_offloading_math.out
./omp_offloading.out 1000000
dot = 2e+06
Pass!
./omp_offloading_cublas.out 1000000
dot = 2e+06
Pass!
./omp_offloading_math.out 1000000
ret = 909297
Pass!
```

[allgebra_get_device_cc](../../utilities) command is contained in the allgebra containers,
and it detects the [compute capability](compute capability) of your GPU using CUDA API.
On a system with NVIDIA TITAN V (compute capability 7.0), for example, it returns `70`:

```
root@3f6b34672c01:/# allgebra_get_device_cc
70
```

This output is used to generate the flag `-Xopenmp-target -march=sm_70` in above example.

Build containers manually
--------------------------
See [DEVELOPMENT.md](./DEVELOPMENT.md)

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
