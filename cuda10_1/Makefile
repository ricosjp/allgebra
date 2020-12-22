PUBLIC_REGISTRY    := ghcr.io/ricosjp/allgebra
CI_REGISTRY_IMAGE  ?= registry.ritc.jp/ricos/allgebra
CI_COMMIT_REF_NAME ?= manual_deploy

ALLGEBRA_VERSION := 20.11.0
GIT_HASH         := $(shell git rev-parse HEAD)
BUILD_DATE       := $(shell date --rfc-3339=ns)

TARGET           := cuda10_1

HERE := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ALLGEBRA_TOPDIR := $(shell readlink -f $(HERE)/..)

IMAGE := $(CI_REGISTRY_IMAGE)/$(subst /,-,$(TARGET)):$(CI_COMMIT_REF_NAME)

build:
	docker build -f $(HERE)/Dockerfile -t $(IMAGE) $(ALLGEBRA_TOPDIR)

push: build
	docker push $(IMAGE)

in: build
	docker run -it --rm --gpus all -v $(ALLGEBRA_TOPDIR):/allgebra -w /allgebra $(IMAGE) bash
