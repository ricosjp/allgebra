REGISTRY := ghcr.io/ricosjp/allgebra/doxygen
CI_COMMIT_REF_NAME ?= manual_deploy

.PHONY: doxygen

all: doxygen

login:
ifeq ($(CI_BUILD_TOKEN),)
	docker login $(REGISTRY)
else
	docker login -u gitlab-ci-token -p $(CI_BUILD_TOKEN) $(REGISTRY)
endif

doxygen: Dockerfile
	docker build -t $(REGISTRY):$(CI_COMMIT_REF_NAME) .

push: login doxygen
	docker push $(REGISTRY):$(CI_COMMIT_REF_NAME)
ifeq ($(CI_COMMIT_REF_NAME),master)
	docker build -t $(REGISTRY):latest .
	docker push $(REGISTRY):latest
endif

version:
	docker run -it --rm $(REGISTRY):$(CI_COMMIT_REF_NAME) doxygen --version
