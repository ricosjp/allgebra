# Copyright 2020 RICOS Co. Ltd.
#
# This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
# https://github.com/ricosjp/allgebra
#

PUBLIC_REGISTRY    := ghcr.io/ricosjp/allgebra
CI_REGISTRY_IMAGE  ?= registry.ritc.jp/ricos/allgebra
CI_COMMIT_REF_NAME ?= manual_deploy

ALLGEBRA_VERSION := 20.12.2
GIT_HASH         := $(shell git rev-parse HEAD)
BUILD_DATE       := $(shell date --rfc-3339=ns)

#
# Following definitions assumes $(TARGET) is defined in parent Makefile
#

ESCAPED       = $(subst /,-,$(TARGET))
IMAGE         = $(CI_REGISTRY_IMAGE)/$(ESCAPED):$(CI_COMMIT_REF_NAME)
RELEASE_IMAGE = $(PUBLIC_REGISTRY)/$(TARGET):$(CI_COMMIT_REF_NAME)

DOCKER_BUILD_ARGS := --build-arg="REGISTRY=$(CI_REGISTRY_IMAGE)" --build-arg="TAG=$(CI_COMMIT_REF_NAME)"

build:
	docker build $(DOCKER_BUILD_ARGS) -f $(HERE)/Dockerfile -t $(IMAGE) $(ALLGEBRA_TOPDIR)

push: build
	docker push $(IMAGE)

release/build:
	docker build \
		$(DOCKER_BUILD_ARGS) --build-arg="TARGET=$(ESCAPED)" \
		-f $(ALLGEBRA_TOPDIR)/release.Dockerfile \
		-t $(RELEASE_IMAGE) \
		$(ALLGEBRA_TOPDIR)

release/push: release/build
	docker push $(RELEASE_IMAGE)
