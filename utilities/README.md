allgebra_get_device_cc
-----------------------

Utility for getting [compute capability](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#compute-capabilities) of GPU.

Build
------

Requirements

- nvcc
- GNU make

```
make
```

Usage
------

If the compute capability of GPU is 7.5 (GeForce RTX 2070), this command returns `75`:

```
$ ./allgebra_get_device_cc
75
```
