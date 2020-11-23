# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

#
# Configure
# -----------
# For container metadata
ALLGEBRA_VERSION := 0.2.1
GIT_HASH         := $(shell git rev-parse HEAD)
BUILD_DATE       := $(shell date --rfc-3339=ns)
# Generate `--build-arg="ARG=$(ARG)"` options
DOCKER_BUILD_ARGS := $(foreach ARG,ALLGEBRA_VERSION GIT_HASH BUILD_DATE,--build-arg="$(ARG)=$($(ARG))")

#
# GitHub Container registry of ricosjp
#
# - https://github.com/orgs/ricosjp/packages
# - FIXME `docker login` uses termoshtt's token (see CI setting)
#
REGISTRY := ghcr.io/ricosjp/allgebra

#
# Docker tag
#
# - For CI: Get from GitLab CI environmental variables
# - Manual: Set default for avoiding to push `latest` accidentally
CI_COMMIT_REF_NAME ?= manual_deploy

#
# Targets
# --------
# This Makefile defines many targets including build and test.
# There are three meta target for easy-to-use:
#
# - all(default) : Build all container
# - test         : Test all container
# - push         : Push all container
#
CUDA_TARGETS    := cuda10_2 cuda11_0
MATH_TARGETS    := mkl oss
TARGETS         := $(foreach CUDA,$(CUDA_TARGETS),$(foreach MATH,$(MATH_TARGETS),$(CUDA)_$(MATH)))
SUPPORT_TARGETS := doxygen clang-format
TESTS           := gcc_openacc gfortran_openacc gcc_omp_offloading gfortran_omp_offloading nsys

.PHONY: $(TARGETS) $(SUPPORT_TARGETS) clang11gcc7/cuda10_1/mkl
all: $(TARGETS) $(SUPPORT_TARGETS)
push: $(foreach TARGET,$(TARGETS) $(SUPPORT_TARGETS),$(TARGET)_push)
test: $(foreach TARGET,$(TARGETS),$(foreach TEST,$(TESTS),$(TARGET)_test_$(TEST)))

#
# Define targets for support containers
#
define support_target
$(1): $(1).Dockerfile
	cat $(1).Dockerfile annotations.Dockerfile > $(1)_tmp.Dockerfile
	docker build $(DOCKER_BUILD_ARGS) -t $(REGISTRY)/$(1):$(CI_COMMIT_REF_NAME) . -f $(1)_tmp.Dockerfile
	rm $(1)_tmp.Dockerfile

$(1)_in: $(1)
	docker run -it --rm $(REGISTRY)/$(1):$(CI_COMMIT_REF_NAME)

$(1)_push: $(1)
	docker push $(REGISTRY)/$(1):$(CI_COMMIT_REF_NAME)
endef
$(foreach TARGET,$(SUPPORT_TARGETS),$(eval $(call support_target,$(TARGET))))

#
# Define test targets. It does not defined for support targets
#
define cuda_target

$(1)_$(2): $(1).Dockerfile $(2).Dockerfile annotations.Dockerfile
	cat $(1).Dockerfile $(2).Dockerfile annotations.Dockerfile > $(1)_$(2).Dockerfile
	docker build $(DOCKER_BUILD_ARGS) -t $(REGISTRY)/$(1)/$(2):$(CI_COMMIT_REF_NAME) . -f $(1)_$(2).Dockerfile
	rm $(1)_$(2).Dockerfile

$(1)_$(2)_in: $(1)_$(2)
	docker run -it --rm $(REGISTRY)/$(1)/$(2):$(CI_COMMIT_REF_NAME)

$(1)_$(2)_push: $(1)_$(2)
	docker push $(REGISTRY)/$(1)/$(2):$(CI_COMMIT_REF_NAME)

$(1)_$(2)_test_gcc_openacc: $(1)_$(2)
	docker run \
		--gpus all \
		--privileged \
		$(REGISTRY)/$(1)/$(2):$(CI_COMMIT_REF_NAME) \
		make -C /examples/gcc_openacc test

$(1)_$(2)_test_gfortran_openacc: $(1)_$(2)
	docker run \
		--gpus all \
		--privileged \
		$(REGISTRY)/$(1)/$(2):$(CI_COMMIT_REF_NAME) \
		make -C /examples/gfortran_openacc test

$(1)_$(2)_test_gcc_omp_offloading: $(1)_$(2)
	docker run \
		--gpus all \
		--privileged \
		$(REGISTRY)/$(1)/$(2):$(CI_COMMIT_REF_NAME) \
		make -C /examples/gcc_omp_offloading test

$(1)_$(2)_test_gfortran_omp_offloading: $(1)_$(2)
	docker run \
		--gpus all \
		--privileged \
		$(REGISTRY)/$(1)/$(2):$(CI_COMMIT_REF_NAME) \
		make -C /examples/gfortran_omp_offloading test

$(1)_$(2)_test_nsys: $(1)_$(2)
	docker run \
		--gpus all \
		--privileged \
		$(REGISTRY)/$(1)/$(2):$(CI_COMMIT_REF_NAME) \
		make -C /examples/gcc_openacc prof
endef
$(foreach CUDA,$(CUDA_TARGETS),$(foreach MATH,$(MATH_TARGETS),$(eval $(call cuda_target,$(CUDA),$(MATH)))))

clang11gcc7/cuda10_1/mkl:
	docker build $(DOCKER_BUILD_ARGS) -f $@/Dockerfile . -t $(REGISTRY)/$@:$(CI_COMMIT_REF_NAME) --target=release
