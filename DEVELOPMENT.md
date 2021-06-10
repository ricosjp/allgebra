For Developers
===============

How to build containers
-----------------------

### Get this repository

Use HTTP

```
git clone https://github.com/ricosjp/allgebra.git
```

Use SSH

```
git clone git@github.com:ricosjp/allgebra.git
```

Use GitHub CLI

```
gh repo clone ricosjp/allgebra
```

### Build all containers

```
make
```

### Build a specific container

```
make -C cuda10_1/clang12/mkl build
```

This will create containers with tag `registry.ritc.jp/ricos/allgebra/cuda10_1-clang12-oss:manual_deploy`.
The registry URL `registry.ritc.jp` and tag `manual_deploy` are set using [GitLab CI environment variables][gitlab-ci-env] in [common.mk](./common.mk),
which will be loaded in each `Makefile`s.
Depenedent containers will be built automatically.

[gitlab-ci-env]: https://docs.gitlab.com/ee/ci/variables/#list-all-environment-variables

### Run into a built container

```
make -C cuda10_1/clang12/mkl in
```

will start bash in the container. Or, with GPU:

```
make -C cuda10_1/clang12/mkl in-gpu
```
