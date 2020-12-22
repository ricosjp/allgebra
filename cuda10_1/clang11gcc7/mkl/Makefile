HERE := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ALLGEBRA_TOPDIR := $(shell git rev-parse --show-toplevel)

include $(ALLGEBRA_TOPDIR)/common.mk

TARGET := cuda10_1/clang11gcc7/mkl
IMAGE  := $(CI_REGISTRY_IMAGE)/$(subst /,-,$(TARGET)):$(CI_COMMIT_REF_NAME)

DOCKER_BUILD_ARGS := --build-arg="REGISTRY=$(CI_REGISTRY_IMAGE)" --build-arg="TAG=$(CI_COMMIT_REF_NAME)"

build:
	docker build $(DOCKER_BUILD_ARGS) -f $(HERE)/Dockerfile -t $(IMAGE) $(ALLGEBRA_TOPDIR)

push: build
	docker push $(IMAGE)

in: build
	docker run -it --rm --gpus all -v $(ALLGEBRA_TOPDIR):/allgebra -w /allgebra $(IMAGE) bash
