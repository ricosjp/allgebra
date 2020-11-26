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

IMAGE := $(REGISTRY)/$(TARGET):$(CI_COMMIT_REF_NAME)

build:
	docker build $(DOCKER_BUILD_ARGS) -f $(TARGET_DIR)/Dockerfile -t $(IMAGE) --target=release $(ALLGEBRA_TOPDIR)

push: build
	docker push $(IMAGE)

test: build
	docker run --rm --gpus all -v $(ALLGEBRA_TOPDIR):/allgebra -w /allgebra $(IMAGE) /allgebra/$(TARGET)/test.sh

in: build
	docker run -it --rm --gpus all -v $(ALLGEBRA_TOPDIR):/allgebra -w /allgebra $(IMAGE) bash
