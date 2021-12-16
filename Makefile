HERE := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ALLGEBRA_TOPDIR := $(shell git rev-parse --show-toplevel)

REQUIREMENT_TARGETS := cuda11_4 cuda11_4/gcc10 cuda11_4/clang12 cuda11_4/clang13

TARGETS := cuda11_4/clang12/mkl cuda11_4/clang12/oss \
           cuda11_4/clang13/mkl cuda11_4/clang13/oss \
           cuda11_4/gcc10/mkl cuda11_4/gcc10/oss \
           clang-format poetry

PUSH_TARGETS    := $(foreach TARGET,$(TARGETS),push/$(TARGET))
RELEASE_TARGETS := $(foreach TARGET,$(TARGETS),release/$(TARGET))

.PHONY: $(REQUIREMENT_TARGETS) $(TARGETS) $(PUSH_TARGETS) $(RELEASE_TARGETS)
all: $(TARGETS)

#
# Build layered containers
#
# For example, `cuda10_1` is used for `cuda10_1/clang12`, and it is used in `cuda10_1/clang12/mkl`.
# Acutual build command is rewritten in common.mk, which will be included in each target's Makefile
#

cuda11_4:
	$(MAKE) -C $@ build

cuda11_4/clang12: cuda11_4
	$(MAKE) -C $@ build

cuda11_4/clang12/mkl: cuda11_4/clang12
	$(MAKE) -C $@ build

cuda11_4/clang12/oss: cuda11_4/clang12
	$(MAKE) -C $@ build

cuda11_4/clang13: cuda11_4
	$(MAKE) -C $@ build

cuda11_4/clang13/mkl: cuda11_4/clang13
	$(MAKE) -C $@ build

cuda11_4/clang13/oss: cuda11_4/clang13
	$(MAKE) -C $@ build

cuda11_4/gcc10: cuda11_4
	$(MAKE) -C $@ build

cuda11_4/gcc10/mkl: cuda11_4/gcc10
	$(MAKE) -C $@ build

cuda11_4/gcc10/oss: cuda11_4/gcc10
	$(MAKE) -C $@ build

clang-format:
	$(MAKE) -C $@ build

poetry:
	$(MAKE) -C $@ build

#
# Push containers to GitLab registry on RICOS (registry.ritc.jp/ricos/allgebra)
#
# These targets are used to share built images between CI tasks.
# While the above build tasks do not require GPU but require high performance CPU to build LLVM,
# Testing these containers using ./examples requires GPU.
#

push/cuda11_4/clang12/mkl: cuda11_4/clang12/mkl
	$(MAKE) -C $< push

push/cuda11_4/clang12/oss: cuda11_4/clang12/oss
	$(MAKE) -C $< push

push/cuda11_4/clang13/mkl: cuda11_4/clang13/mkl
	$(MAKE) -C $< push

push/cuda11_4/clang13/oss: cuda11_4/clang13/oss
	$(MAKE) -C $< push

push/cuda11_4/gcc10/mkl: cuda11_4/gcc10/mkl
	$(MAKE) -C $< push

push/cuda11_4/gcc10/oss: cuda11_4/gcc10/oss
	$(MAKE) -C $< push

push/clang-format: clang-format
	$(MAKE) -C $< push

push/poetry: poetry
	$(MAKE) -C $< push

push: $(PUSH_TARGETS)

#
# Release to GitHub container registry (ghcr.io)
#

release/cuda11_4/clang12/mkl:
	$(MAKE) -C cuda11_4/clang12/mkl release/push

release/cuda11_4/clang12/oss:
	$(MAKE) -C cuda11_4/clang12/oss release/push

release/cuda11_4/clang13/mkl:
	$(MAKE) -C cuda11_4/clang13/mkl release/push

release/cuda11_4/clang13/oss:
	$(MAKE) -C cuda11_4/clang13/oss release/push

release/cuda11_4/gcc10/mkl:
	$(MAKE) -C cuda11_4/gcc10/mkl release/push

release/cuda11_4/gcc10/oss:
	$(MAKE) -C cuda11_4/gcc10/oss release/push

release/clang-format:
	$(MAKE) -C clang-format release/push

release/poetry:
	$(MAKE) -C poetry release/push

release: $(RELEASE_TARGETS)
