allgebra
=========

Base container images for HPC

allgebra
---------

OpenACC NVPTX-offload supported GCC with CUDA 11

| Software  | Version    |
|:----------|:-----------|
| Ubuntu    | 20.04      |
| GCC       | 9.3        |
| CUDA      | 11.0       |
| OpenBLAS  | 3.8.0      |
| Intel MKL | 2020.0.166 |

Additional packages for analysis purpose:

| Software       | Version |
|:---------------|:--------|
| Nsight Systems | 11.0    |
| Python         | 3.8.2   |
| gdb            | 9.1     |
| strace         | 5.5     |
| trace-cmd      | 2.8.3   |
| valgrind       | 3.15.0  |
| perf           | 5.4.45  |

These trace commands may need `--privileged` option for `docker run`
