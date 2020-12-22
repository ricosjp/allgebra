PUBLIC_REGISTRY    := ghcr.io/ricosjp/allgebra
CI_REGISTRY_IMAGE  ?= registry.ritc.jp/ricos/allgebra
CI_COMMIT_REF_NAME ?= manual_deploy

HERE := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ALLGEBRA_TOPDIR := $(shell git rev-parse --show-toplevel)

TARGET := cuda10_1/clang11gcc7/oss
IMAGE  := $(CI_REGISTRY_IMAGE)/$(subst /,-,$(TARGET)):$(CI_COMMIT_REF_NAME)

DOCKER_BUILD_ARGS := --build-arg="REGISTRY=$(CI_REGISTRY_IMAGE)" --build-arg="TAG=$(CI_COMMIT_REF_NAME)"

build:
	docker build $(DOCKER_BUILD_ARGS) -f $(HERE)/Dockerfile -t $(IMAGE) $(ALLGEBRA_TOPDIR)

push: build
	docker push $(IMAGE)

in: build
	docker run -it --rm --gpus all -v $(ALLGEBRA_TOPDIR):/allgebra -w /allgebra $(IMAGE) bash
