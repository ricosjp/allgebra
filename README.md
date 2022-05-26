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
| [ghcr.io/ricosjp/allgebra/cuda11_7/clang13/mkl][cuda11_7/clang13/mkl] | 11.7 | clang 13, gcc 11, nvcc 11.7 | Intel MKL |
| [ghcr.io/ricosjp/allgebra/cuda11_7/clang13/oss][cuda11_7/clang13/oss] | 11.7 | clang 13, gcc 11, nvcc 11.7 | OpenBLAS  |
| [ghcr.io/ricosjp/allgebra/cuda11_7/gcc11/mkl][cuda11_7/gcc11/mkl]     | 11.7 | gcc 11, nvcc 11.7 | Intel MKL |
| [ghcr.io/ricosjp/allgebra/cuda11_7/gcc11/oss][cuda11_7/gcc11/oss]     | 11.7 | gcc 11, nvcc 11.7 | OpenBLAS  |

[cuda11_7/clang13/mkl]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda11_7%2Fclang13%2Fmkl
[cuda11_7/clang13/oss]: https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda11_7%2Fclang13%2Foss
[cuda11_7/gcc11/mkl]:   https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda11_7%2Fgcc11%2Fmkl
[cuda11_7/gcc11/oss]:   https://github.com/orgs/ricosjp/packages/container/package/allgebra%2Fcuda11_7%2Fgcc11%2Foss

In addition, there are support tools in each containers.

- [clang-format](https://clang.llvm.org/docs/ClangFormat.html)
- [clang-tidy](https://clang.llvm.org/extra/clang-tidy/)
- [doxygen](https://www.doxygen.nl/index.html)
- [poetry](https://github.com/python-poetry/poetry)

OpenMP Offloading, OpenACC examples
------------------------------------

The OSS compilers in allgebra containers (gcc, gfortran and clang) are compiled with OpenMP and OpenACC supports.
There are several examples in this repository, and they are also copied into the above containers.

| Compiler         | OpenMP Offloading                                             | OpenACC                                         |
|:-----------------|:--------------------------------------------------------------|:------------------------------------------------|
| clang/libomp     | [clang_omp_offloading](./examples/clang_omp_offloading)       | -                                               |
| gcc/libgomp      | [gcc_omp_offloading](./examples/gcc_omp_offloading)           | [gcc_openacc](./examples/gcc_openacc)           |
| gfortran/libgomp | [gfortran_omp_offloading](./examples/gfortran_omp_offloading) | [gfortran_openacc](./examples/gfortran_openacc) |

The requirements of these examples are following:

- Use Linux
  - If you'd like to use WSL2, see [Use allgebra on WSL](./WSL.md)
- Install [Docker](https://docs.docker.com/engine/install/)
- Install [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker)

You can build and run e.g. the clang with OpenMP Offloading example as following:

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

[allgebra_get_device_cc](./utilities) command is contained in the allgebra containers,
and it detects the [compute capability](compute capability) of your GPU using CUDA API.
On a system with NVIDIA TITAN V (compute capability 7.0), for example, it returns `70`:

```
root@3f6b34672c01:/# allgebra_get_device_cc
70
```

This output is used to generate the flag `-Xopenmp-target -march=sm_70` in above example.

With Singularity
-----------------

[Singularity](https://sylabs.io/singularity/) is a container runtime focused on HPC and AI.
Since singularity supports Docker and OCI container images, allgebra containers can be used as it is.

```
singularity run --nv docker://ghcr.io/ricosjp/allgebra/cuda10_1/clang12/mkl:latest
```

`--nv` is an option for using NVIDIA GPU in the container.
See the [official document](https://singularity.hpcng.org/user-docs/3.7/gpu.html#nvidia-gpus-cuda) for detail.

You can build a SIF (Singularity Image Format) file from an allgebra container:

```
singularity build allgebra_clang_mkl.sif docker://ghcr.io/ricosjp/allgebra/cuda10_1/clang12/mkl:latest
```

and run it:

```
singularity run --nv allgebra_clang_mkl.sif
```

`--nv` option is required for `singularity run` and not for `singularity build`
since `singularity build` only download the container and converts it.

Be sure that this `allgebra_clang_mkl.sif` contains CUDA and MKL binaries.
You have to accept the [End User License Agreement of CUDA][EULA_CUDA],
and follow the [Intel Simplified Software License][ISSL].

`ALLGEBRA_*` environment variables
-----------------------------------

In order to identify the CUDA and LLVM versions in container, following environment variables are defined:

| name                        | example                | description |
|:----------------------------|:-----------------------|:------------|
| ALLGEBRA_CUDA_INSTALL_DIR   | /usr/local/cuda-11.4   | The top directory where CUDA is installed |
| ALLGEBRA_CUDA_VERSION       | 11.4                   | Installed CUDA version |
| ALLGEBRA_CUDA_VERSION_MAJOR | 11                     | The major version of CUDA |
| ALLGEBRA_CUDA_VERSION_MINOR | 4                      | The minor version of CUDA |
| ALLGEBRA_CUDA_VERSION_PATCH | 1                      | The patch version of CUDA |
| ALLGEBRA_LLVM_INSTALL_DIR   | /usr/local/llvm-12.0.1 | The top directory where LLVM is installed |
| ALLGEBRA_LLVM_VERSION       | 12.0.1                 | Installed LLVM version |
| ALLGEBRA_LLVM_VERSION_MAJOR | 12                     | The major version of LLVM |
| ALLGEBRA_LLVM_VERSION_MINOR | 0                      | The minor version of LLVM |
| ALLGEBRA_LLVM_VERSION_PATCH | 1                      | The patch version of LLVM |

Build containers manually
--------------------------

See [DEVELOPMENT.md](./DEVELOPMENT.md)

License
--------

Copyright 2020 RICOS Co. Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

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
