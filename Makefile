HERE := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ALLGEBRA_TOPDIR := $(shell git rev-parse --show-toplevel)

TARGETS := cuda10_1 cuda10_1/clang11gcc7 cuda10_1/clang11gcc7/mkl cuda10_1/clang11gcc7/oss \
           cuda10_2 cuda10_2/gcc10 cuda10_2/gcc10/mkl cuda10_2/gcc10/oss \
           cuda11_0 cuda11_0/gcc10 cuda11_0/gcc10/mkl cuda11_0/gcc10/oss
RELEASE_TARGETS := $(foreach TARGET,$(TARGETS),release/$(TARGET))

.PHONY: $(TARGETS) $(RELEASE_TARGETS)
all: $(TARGETS)

cuda10_1:
	$(MAKE) -C $@

cuda10_1/clang11gcc7: cuda10_1
	$(MAKE) -C $@

cuda10_1/clang11gcc7/mkl: cuda10_1/clang11gcc7
	$(MAKE) -C $@

cuda10_1/clang11gcc7/oss: cuda10_1/clang11gcc7
	$(MAKE) -C $@

cuda10_2:
	$(MAKE) -C $@

cuda10_2/gcc10: cuda10_2
	$(MAKE) -C $@

cuda10_2/gcc10/mkl: cuda10_2/gcc10
	$(MAKE) -C $@

cuda10_2/gcc10/oss: cuda10_2/gcc10
	$(MAKE) -C $@

cuda11_0:
	$(MAKE) -C $@

cuda11_0/gcc10: cuda11_0
	$(MAKE) -C $@

cuda11_0/gcc10/mkl: cuda11_0/gcc10
	$(MAKE) -C $@

cuda11_0/gcc10/oss: cuda11_0/gcc10
	$(MAKE) -C $@

push: $(TARGETS)
	$(foreach TARGET,$(TARGETS),make -C $(TARGET) push;)

#
# Release to GitHub container registry (ghcr.io)
#

# Generate `--build-arg="ARG=$(ARG)"` options for release build
DOCKER_BUILD_ARGS := $(foreach ARG,ALLGEBRA_VERSION GIT_HASH BUILD_DATE,--build-arg="$(ARG)=$($(ARG))")
DOCKER_BUILD_ARGS += --build-arg="REGISTRY=$(CI_REGISTRY_IMAGE)" --build-arg="TAG=$(CI_COMMIT_REF_NAME)"

release/cuda10_1/clang11gcc7/mkl:
	make -C cuda10_1/clang11gcc7/mkl release/build

release/cuda10_1/clang11gcc7/oss:
	make -C cuda10_1/clang11gcc7/oss release/build

release/cuda10_2/gcc10/mkl:
	make -C cuda10_2/gcc10/mkl release/build

release/cuda10_2/gcc10/oss:
	make -C cuda10_2/gcc10/oss release/build

release/cuda11_0/gcc10/mkl:
	make -C cuda11_0/gcc10/mkl release/build

release/cuda11_0/gcc10/oss:
	make -C cuda11_0/gcc10/oss release/build

release: $(RELEASE_TARGETS)
	$(foreach TARGET,$(TARGETS),make -C $(RELEASE_TARGETS) release/push;)
