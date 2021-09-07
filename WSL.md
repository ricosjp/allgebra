Use allgebra in Windows Subsystem for Linux (WSL)
=================================================

Currently (2021/9), it is still hard to use CUDA on WSL which allgebra closely depends on.

[CUDA on WSL document](https://docs.nvidia.com/cuda/wsl-user-guide/index.html) says
> Ensure that you install Build version 20145 or higher. We recommend being on WIP OS 21332 and higher with Linux Kernel 5.4.91+ for the best performance.

This requires [Windows Insider Program][WIP] with beta channel, which is also known as [Windows 11](https://www.microsoft.com/en-us/windows/)

[WIP]: https://insider.windows.com/en-us/getting-started

Usage
------

- Enable [Windows 10 Insider Preview][WIP] with beta channel, and run Windows Update
- Install [NVIDIA Drivers for CUDA on WSL, including DirectML Support](https://developer.nvidia.com/cuda/wsl/download)
- Install [Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
  - Use WSL mode instead of Hyper-V mode

Then you can run `docker` on Powershell

```
PS C:\Users\username> docker run -it --rm --gpus=all ghcr.io/ricosjp/allgebra/cuda10_1/clang12/oss:21.06.1
root@528ba142c5ca:/# cd /examples/clang_omp_offloading/
root@528ba142c5ca:/examples/clang_omp_offloading# make test
clang++ -fopenmp -fopenmp-targets=nvptx64 -Xopenmp-target -march=sm_75 -O3 -std=c++11 -lm omp_offloading.cpp -o omp_offloading.out
clang++ -fopenmp -fopenmp-targets=nvptx64 -Xopenmp-target -march=sm_75 -O3 -std=c++11 -lm omp_offloading_cublas.cpp -o omp_offloading_cublas.out -lcuda -lcublas -lcudart
clang++ -fopenmp -fopenmp-targets=nvptx64 -Xopenmp-target -march=sm_75 -O3 -std=c++11 -lm omp_offloading_math.cpp -o omp_offloading_math.out
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
