HERE := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ALLGEBRA_TOPDIR := $(shell git rev-parse --show-toplevel)

include $(ALLGEBRA_TOPDIR)/common.mk

TARGETS := cuda10_1 cuda10_1/clang11gcc7 cuda10_1/clang11gcc7/mkl cuda10_1/clang11gcc7/oss
RELEASE_TARGETS := $(foreach TARGET,$(TARGETS),release/$(TARGET))

.PHONY: $(TARGETS) $(RELEASE_TARGETS)

cuda10_1:
	$(MAKE) -C $@

cuda10_1/clang11gcc7: cuda10_1
	$(MAKE) -C $@

cuda10_1/clang11gcc7/mkl: cuda10_1/clang11gcc7
	$(MAKE) -C $@

cuda10_1/clang11gcc7/oss: cuda10_1/clang11gcc7
	$(MAKE) -C $@

push: $(TARGETS)
	docker push $(CI_REGISTRY_IMAGE)/cuda10_1:$(CI_COMMIT_REF_NAME)
	docker push $(CI_REGISTRY_IMAGE)/cuda10_1-clang11gcc7:$(CI_COMMIT_REF_NAME)
	docker push $(CI_REGISTRY_IMAGE)/cuda10_1-clang11gcc7-mkl:$(CI_COMMIT_REF_NAME)
	docker push $(CI_REGISTRY_IMAGE)/cuda10_1-clang11gcc7-oss:$(CI_COMMIT_REF_NAME)

#
# Release to GitHub container registry (ghcr.io)
#

# Generate `--build-arg="ARG=$(ARG)"` options for release build
DOCKER_BUILD_ARGS := $(foreach ARG,ALLGEBRA_VERSION GIT_HASH BUILD_DATE,--build-arg="$(ARG)=$($(ARG))")
DOCKER_BUILD_ARGS += --build-arg="REGISTRY=$(CI_REGISTRY_IMAGE)" --build-arg="TAG=$(CI_COMMIT_REF_NAME)"

release/cuda10_1:
	docker build \
		$(DOCKER_BUILD_ARGS) --build-arg="TARGET=cuda10_1" \
		-f release.Dockerfile \
		-t $(PUBLIC_REGISTRY)/cuda10_1:$(CI_COMMIT_REF_NAME) \
		$(ALLGEBRA_TOPDIR)

release/cuda10_1/clang11gcc7:
	docker build \
		$(DOCKER_BUILD_ARGS) --build-arg="TARGET=cuda10_1-clang11gcc7" \
		-f release.Dockerfile \
		-t $(PUBLIC_REGISTRY)/cuda10_1/clang11gcc7:$(CI_COMMIT_REF_NAME) \
		$(ALLGEBRA_TOPDIR)

release/cuda10_1/clang11gcc7/mkl:
	docker build \
		$(DOCKER_BUILD_ARGS) --build-arg="TARGET=cuda10_1-clang11gcc7-mkl" \
		-f release.Dockerfile \
		-t $(PUBLIC_REGISTRY)/cuda10_1/clang11gcc7/mkl:$(CI_COMMIT_REF_NAME) \
		$(ALLGEBRA_TOPDIR)

release/cuda10_1/clang11gcc7/oss:
	docker build \
		$(DOCKER_BUILD_ARGS) --build-arg="TARGET=cuda10_1-clang11gcc7-oss" \
		-f release.Dockerfile \
		-t $(PUBLIC_REGISTRY)/cuda10_1/clang11gcc7/oss:$(CI_COMMIT_REF_NAME) \
		$(ALLGEBRA_TOPDIR)

release: $(RELEASE_TARGETS)
	docker push $(PUBLIC_REGISTRY)/cuda10_1:$(CI_COMMIT_REF_NAME)
	docker push $(PUBLIC_REGISTRY)/cuda10_1/clang11gcc7:$(CI_COMMIT_REF_NAME)
	docker push $(PUBLIC_REGISTRY)/cuda10_1/clang11gcc7/mkl:$(CI_COMMIT_REF_NAME)
	docker push $(PUBLIC_REGISTRY)/cuda10_1/clang11gcc7/oss:$(CI_COMMIT_REF_NAME)
