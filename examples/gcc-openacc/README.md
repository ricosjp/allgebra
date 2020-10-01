OpenACC Example for C++ using allgebra container
=================================================

|Example                           | Description                         |
|:---------------------------------|:------------------------------------|
|[acc.cpp](./acc.cpp)              | Minimal example for testing OpenACC |
|[acc_cublas.cpp](./acc_cublas.cpp)| Use OpenACC with CUDA libraries     |

Requirements
-------------

- GNU make
- `docker` command works
  - e.g. `docker ps` command does not returns error.
- Internet Access
  - `make` command will download allgebra container automatically.

Makefile
---------

```
make
```

See comments in [Makefile](./Makefile) for detail.

cmake
------

```
make cmake
```

See comments in [CMakeLists.txt](./CMakeLists.txt) for detail.
