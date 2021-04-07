HERE := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ALLGEBRA_TOPDIR := $(shell git rev-parse --show-toplevel)

include $(ALLGEBRA_TOPDIR)/common.mk

TARGET := clang-format
IMAGE  := $(CI_REGISTRY_IMAGE)/$(subst /,-,$(TARGET)):$(CI_COMMIT_REF_NAME)

#
# For release build
#
RELEASE_IMAGE     := $(PUBLIC_REGISTRY)/$(TARGET):$(CI_COMMIT_REF_NAME)
DOCKER_BUILD_ARGS := $(foreach ARG,ALLGEBRA_VERSION GIT_HASH BUILD_DATE,--build-arg="$(ARG)=$($(ARG))")
DOCKER_BUILD_ARGS += --build-arg="REGISTRY=$(CI_REGISTRY_IMAGE)" --build-arg="TAG=$(CI_COMMIT_REF_NAME)"

.PHONY: build push version release/$(TARGET)

build:
	docker build -f $(HERE)/Dockerfile -t $(IMAGE) $(ALLGEBRA_TOPDIR)

push: build
	docker push $(IMAGE)

version: build
	docker run -it --rm $(IMAGE) clang-format --version

release/$(TARGET):
	docker build \
		$(DOCKER_BUILD_ARGS) --build-arg="TARGET=$(TARGET)" \
		-f $(ALLGEBRA_TOPDIR)/release.Dockerfile \
		-t $(RELEASE_IMAGE) \
		$(ALLGEBRA_TOPDIR)

release: release/$(TARGET)
	docker push $(RELEASE_IMAGE)
