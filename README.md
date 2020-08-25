allgebra
=========

Base container images for HPC

allgebra
---------

OpenACC NVPTX-offload supported GCC with CUDA 11

| Software | Version |
|:---------|:--------|
| Ubuntu   | 20.04   |
| GCC      | 9.3     |
| CUDA     | 11.0    |

allgebra/frontend
------------------

Additional packages for interactive purpose based on `allgebra` image:

| Software       | Version |
|:---------------|:--------|
| Nsight Systems | 11.0    |
| Python         | 3.8.2   |
| GDB            | 9.1     |
| strace         | 5.5     |
| trace-cmd      | 2.8.3   |
| valgrind       | 3.15.0  |

These trace commands may need `--privileged` option for `docker run`
