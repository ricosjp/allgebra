REGISTRY           := ghcr.io/ricosjp/allgebra
CI_COMMIT_REF_NAME ?= manual_deploy

ALLGEBRA_VERSION := 20.11.0
GIT_HASH         := $(shell git rev-parse HEAD)
BUILD_DATE       := $(shell date --rfc-3339=ns)
TARGET           := clang11gcc7/cuda10_1/mkl

# Generate `--build-arg="ARG=$(ARG)"` options
DOCKER_BUILD_ARGS := $(foreach ARG,ALLGEBRA_VERSION GIT_HASH BUILD_DATE TARGET,--build-arg="$(ARG)=$($(ARG))")

TARGET_DIR      := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ALLGEBRA_TOPDIR := $(shell readlink -f $(TARGET_DIR)/../../..)

build:
	docker build $(DOCKER_BUILD_ARGS) -f $(TARGET_DIR)/Dockerfile -t $(REGISTRY)/$(TARGET):$(CI_COMMIT_REF_NAME) --target=release $(ALLGEBRA_TOPDIR)

push: build
	docker push $(REGISTRY)/$(TARGET):$(CI_COMMIT_REF_NAME)
