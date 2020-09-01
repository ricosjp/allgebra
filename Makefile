REGISTRY  := registry.ritc.jp/ricos/allgebra
CI_COMMIT_REF_NAME ?= manual_deploy

.PHONY: allgebra test test-nsys test-mkl in

all: allgebra

login:
ifeq ($(CI_BUILD_TOKEN),)
	docker login $(REGISTRY)
else
	docker login -u gitlab-ci-token -p $(CI_BUILD_TOKEN) $(REGISTRY)
endif

allgebra: Dockerfile
	docker build -t $(REGISTRY):$(CI_COMMIT_REF_NAME) .

push: login allgebra
	docker push $(REGISTRY):$(CI_COMMIT_REF_NAME)
ifeq ($(CI_COMMIT_REF_NAME),master)
	docker build -t $(REGISTRY):latest . -f Dockerfile
	docker push $(REGISTRY):latest
endif

in: allgebra
	docker run -it \
		--gpus all \
		--privileged \
		--mount type=bind,src=$(PWD)/test,dst=/test \
		$(REGISTRY):$(CI_COMMIT_REF_NAME)

test: allgebra
	docker run \
		--gpus all \
		--privileged \
		--mount type=bind,src=$(PWD)/test,dst=/test \
		$(REGISTRY):$(CI_COMMIT_REF_NAME) \
		make -C /test test

test-nsys: allgebra
	docker run \
		--gpus all \
		--privileged \
		--mount type=bind,src=$(PWD)/test,dst=/test \
		$(REGISTRY):$(CI_COMMIT_REF_NAME) \
		make -C /test test-nsys

test-mkl: allgebra
	docker run \
		$(REGISTRY):$(CI_COMMIT_REF_NAME) \
		pkg-config --exists mkl-static-lp64-seq
