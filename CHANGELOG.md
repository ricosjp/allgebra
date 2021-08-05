Be sure that **it is not a [semantic versioning][semver]**. Every release can be a breaking change.
You should use containers with a fixed tag.
Each release will be tagged as calendar versioning `{year}.{month}.{patch}` format.

[semver]: https://semver.org/

Unreleased
===========

- Create CUDA 11.4 based image based on CUDA 10.1 image https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/47
- Update LLVM to 12.0.1 https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/46

21.06.1 - 2021/06/11
=====================

Changes
--------
- Add /.singurality.d/libs in LIBRARY_PATH https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/44

21.06.0 - 2021/06/10
=====================

Changes
--------
- Update LLVM to 12.0.0 https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/43
- Update cmake to 3.20.2 https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/42

21.05.0 - 2021/05/11
=====================

Added
------
- Add MPI example code https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/38
- README for utilities/allgebra_get_device_cc

Changed
-------
- Format C++ codes in exmples/ https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/41
- Remove error comment of `allgebra_get_device_cc` https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/38
- Add `make in` target, and "How to build container" section in README https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/40
- Upgrade to LLVM 11.0.1 https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/36
- Build clang-format and doxygen container on CI https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/34
- Cleanup Makefile, split build CI task into each CUDA versions https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/35

20.12.2 - 2020/12/29
=====================

Added
------
- add liblapacke-dev in OSS containers https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/32

20.12.1 - 2020/12/23
=====================

Changes
--------
- Rewrite gcc9 containers https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/31
  - Upgrade to gcc10
  - Add compiler name to container URI
  - Rewrite Makefile system like clang11gcc7

20.12.0 - 2020/12/22
=====================

Added
------
- add clang11gcc7 OSS container https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/29
- add keep changelog CI https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/29
- add clang11gcc7 MKL container https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/28
- add OpenMP Offloading math function examples https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/24
- add OpenMP Offloading examples https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/22

Changes
--------
- Rewrite clang11gcc7 containers https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/30
  - Rename clang11gcc7/cuda10_1/mkl -> cuda10_1/clang11gcc7/mkl
  - Push intermidiate containers to CI registry
  - Share base images between mkl and oss containers
- change `-` to `_` in all files (expect `clang-format` ) https://gitlab.ritc.jp/ricos/allgebra/-/merge_requests/22

20.10.1 - 2020/10/24
=====================

Added
------
- python3-pandas

Changes
--------
- cmake to 3.18.4
