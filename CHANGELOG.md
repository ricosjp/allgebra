Be sure that **it is not a [semantic versioning][semver]**. Every release can be broken.
Each release will be named as `{year}.{month}.{patch}` format.

[semver]: https://semver.org/

Unreleased
===========

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
