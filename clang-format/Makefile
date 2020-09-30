REGISTRY := ghcr.io/ricosjp/allgebra/clang-format
CI_COMMIT_REF_NAME ?= manual_deploy

.PHONY: clang-format

all: clang-format

login:
ifeq ($(CI_BUILD_TOKEN),)
	docker login $(REGISTRY)
else
	docker login -u gitlab-ci-token -p $(CI_BUILD_TOKEN) $(REGISTRY)
endif

clang-format: Dockerfile
	docker build -t $(REGISTRY):$(CI_COMMIT_REF_NAME) .

push: login clang-format
	docker push $(REGISTRY):$(CI_COMMIT_REF_NAME)
ifeq ($(CI_COMMIT_REF_NAME),master)
	docker build -t $(REGISTRY):latest .
	docker push $(REGISTRY):latest
endif
