HERE := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ALLGEBRA_TOPDIR := $(shell git rev-parse --show-toplevel)

include $(ALLGEBRA_TOPDIR)/common.mk

TARGET := cuda10_1
IMAGE  := $(CI_REGISTRY_IMAGE)/$(subst /,-,$(TARGET)):$(CI_COMMIT_REF_NAME)

# Generate `--build-arg="ARG=$(ARG)"` options
DOCKER_BUILD_ARGS := $(foreach ARG,ALLGEBRA_VERSION GIT_HASH BUILD_DATE,--build-arg="$(ARG)=$($(ARG))")

build:
	docker build $(DOCKER_BUILD_ARGS) -f $(HERE)/Dockerfile -t $(IMAGE) $(ALLGEBRA_TOPDIR)

push: build
	docker push $(IMAGE)

in: build
	docker run -it --rm --gpus all -v $(ALLGEBRA_TOPDIR):/allgebra -w /allgebra $(IMAGE) bash
