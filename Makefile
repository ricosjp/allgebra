HERE := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ALLGEBRA_TOPDIR := $(shell git rev-parse --show-toplevel)

TARGET_CUDA=cuda11_7
TARGET_CLANG=clang13
TARGET_GCC=gcc11

REQUIREMENT_TARGETS := $(TARGET_CUDA) $(TARGET_CUDA)/$(TARGET_GCC) $(TARGET_CUDA)/$(TARGET_CLANG)

TARGETS := $(TARGET_CUDA)/$(TARGET_CLANG)/mkl $(TARGET_CUDA)/$(TARGET_CLANG)/oss \
           $(TARGET_CUDA)/$(TARGET_GCC)/mkl $(TARGET_CUDA)/$(TARGET_GCC)/oss 

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

$(TARGET_CUDA):
	$(MAKE) -C $@ build

$(TARGET_CUDA)/$(TARGET_CLANG): $(TARGET_CUDA)
	$(MAKE) -C $@ build

$(TARGET_CUDA)/$(TARGET_CLANG)/mkl: $(TARGET_CUDA)/$(TARGET_CLANG)
	$(MAKE) -C $@ build

$(TARGET_CUDA)/$(TARGET_CLANG)/oss: $(TARGET_CUDA)/$(TARGET_CLANG)
	$(MAKE) -C $@ build

$(TARGET_CUDA)/$(TARGET_GCC): $(TARGET_CUDA)
	$(MAKE) -C $@ build

$(TARGET_CUDA)/$(TARGET_GCC)/mkl: $(TARGET_CUDA)/$(TARGET_GCC)
	$(MAKE) -C $@ build

$(TARGET_CUDA)/$(TARGET_GCC)/oss: $(TARGET_CUDA)/$(TARGET_GCC)
	$(MAKE) -C $@ build

#
# Push containers to GitLab registry on RICOS (registry.ritc.jp/ricos/allgebra)
#
# These targets are used to share built images between CI tasks.
# While the above build tasks do not require GPU but require high performance CPU to build LLVM,
# Testing these containers using ./examples requires GPU.
#

push/$(TARGET_CUDA)/$(TARGET_CLANG)/mkl: $(TARGET_CUDA)/$(TARGET_CLANG)/mkl
	$(MAKE) -C $< push

push/$(TARGET_CUDA)/$(TARGET_CLANG)/oss: $(TARGET_CUDA)/$(TARGET_CLANG)/oss
	$(MAKE) -C $< push

push/$(TARGET_CUDA)/$(TARGET_GCC)/mkl: $(TARGET_CUDA)/$(TARGET_GCC)/mkl
	$(MAKE) -C $< push

push/$(TARGET_CUDA)/$(TARGET_GCC)/oss: $(TARGET_CUDA)/$(TARGET_GCC)/oss
	$(MAKE) -C $< push

push: $(PUSH_TARGETS)

#
# Release to GitHub container registry (ghcr.io)
#

release/$(TARGET_CUDA)/$(TARGET_CLANG)/mkl:
	$(MAKE) -C $(TARGET_CUDA)/$(TARGET_CLANG)/mkl release/push

release/$(TARGET_CUDA)/$(TARGET_CLANG)/oss:
	$(MAKE) -C $(TARGET_CUDA)/$(TARGET_CLANG)/oss release/push

release/$(TARGET_CUDA)/$(TARGET_GCC)/mkl:
	$(MAKE) -C $(TARGET_CUDA)/$(TARGET_GCC)/mkl release/push

release/$(TARGET_CUDA)/$(TARGET_GCC)/oss:
	$(MAKE) -C $(TARGET_CUDA)/$(TARGET_GCC)/oss release/push

release: $(RELEASE_TARGETS)
