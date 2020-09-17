allgebra
=========

OpenACC NVPTX-offload supported GCC with CUDA 10.2

```
docker pull registry.ritc.jp/ricos/allgebra/cuda10_2:latest
```

| Software  | Version    |
|:----------|:-----------|
| Ubuntu    | 20.04      |
| GCC       | 9.3        |
| CUDA      | 10.2       |
| OpenBLAS  | 3.8.0      |
| Intel MKL | 2020.0.166 |

Additional packages for analysis purpose:

| Software       | Version |
|:---------------|:--------|
| Nsight Systems | 10.2    |
| Python         | 3.8.2   |
| gdb            | 9.1     |
| strace         | 5.5     |
| trace-cmd      | 2.8.3   |
| valgrind       | 3.15.0  |

These trace commands may need `--privileged` option for `docker run`
