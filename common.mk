# Common parts of Makefiles
#
# Input Variables
# ----------------
#  - REGISTRY : Where the docker image will be pushed

CI_COMMIT_REF_NAME ?= manual_deploy

.PHONY: allgebra test test-nsys test-mkl test-perf in

all: allgebra

login:
ifeq ($(CI_BUILD_TOKEN),)
	docker login $(REGISTRY)
else
	docker login -u gitlab-ci-token -p $(CI_BUILD_TOKEN) $(REGISTRY)
endif

allgebra: Dockerfile
	docker build -t $(REGISTRY):$(CI_COMMIT_REF_NAME) .. -f $(CURDIR)/Dockerfile

push: login allgebra
	docker push $(REGISTRY):$(CI_COMMIT_REF_NAME)
ifeq ($(CI_COMMIT_REF_NAME),master)
	docker build -t $(REGISTRY):latest .. -f $(CURDIR)/Dockerfile
	docker push $(REGISTRY):latest
endif

in: allgebra
	docker run -it \
		--gpus all \
		--privileged \
		$(REGISTRY):$(CI_COMMIT_REF_NAME)

test: test-openacc test-nsys test-mkl

test-openacc: allgebra
	docker run \
		--gpus all \
		--privileged \
		$(REGISTRY):$(CI_COMMIT_REF_NAME) \
		make -C /test test

test-nsys: allgebra
	docker run \
		--gpus all \
		--privileged \
		$(REGISTRY):$(CI_COMMIT_REF_NAME) \
		make -C /test test-nsys

test-mkl: allgebra
	docker run \
		$(REGISTRY):$(CI_COMMIT_REF_NAME) \
		pkg-config --exists mkl-static-lp64-seq

test-perf: allgebra
	docker run \
		$(REGISTRY):$(CI_COMMIT_REF_NAME) \
		perf --version
