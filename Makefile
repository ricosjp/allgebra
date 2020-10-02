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
SUPPORT_TARGETS := doxygen clang-format
TARGETS         := $(SUPPORT_TARGETS) $(CUDA_TARGETS)

.PHONY: $(TARGETS)
all: $(TARGETS)
push: $(foreach TARGET,$(TARGETS),$(TARGET)-push)
test: $(foreach TARGET,$(CUDA_TARGETS),\
	$(TARGET)-test-gcc-openacc \
	$(TARGET)-test-gfortran-openacc \
	$(TARGET)-test-nsys \
	$(TARGET)-test-mkl)

#
# Define build and push targets for all containers
#
define docker_commands
$(1): $(1).Dockerfile
	cat $(1).Dockerfile annotations.Dockerfile > $(1)-tmp.Dockerfile
	docker build $(DOCKER_BUILD_ARGS) -t $(REGISTRY)/$(1):$(CI_COMMIT_REF_NAME) . -f $(1)-tmp.Dockerfile
	rm $(1)-tmp.Dockerfile

$(1)-in: $(1)
	docker run -it --rm $(REGISTRY)/$(1):$(CI_COMMIT_REF_NAME)

$(1)-push: $(1)
	docker push $(REGISTRY)/$(1):$(CI_COMMIT_REF_NAME)
endef
$(foreach TARGET,$(TARGETS),$(eval $(call docker_commands,$(TARGET))))

#
# Define test targets. It does not defined for support targets
#
define test_commands
$(1)-test-gcc-openacc: $(1)
	docker run \
		--gpus all \
		--privileged \
		$(REGISTRY)/$(1):$(CI_COMMIT_REF_NAME) \
		make -C /examples/gcc-openacc test

$(1)-test-gfortran-openacc: $(1)
	docker run \
		--gpus all \
		--privileged \
		$(REGISTRY)/$(1):$(CI_COMMIT_REF_NAME) \
		make -C /examples/gfortran-openacc test

$(1)-test-nsys: $(1)
	docker run \
		--gpus all \
		--privileged \
		$(REGISTRY)/$(1):$(CI_COMMIT_REF_NAME) \
		make -C /examples/gcc-openacc prof

$(1)-test-mkl: $(1)
	docker run \
		$(REGISTRY)/$(1):$(CI_COMMIT_REF_NAME) \
		pkg-config --exists mkl-dynamic-lp64-iomp
endef
$(foreach TARGET,$(CUDA_TARGETS),$(eval $(call test_commands,$(TARGET))))
