REGISTRY  := registry.ritc.jp/ricos/allgebra
CI_COMMIT_REF_NAME ?= manual_deploy

.PHONY: allgebra allgebra-frontend test test-nsys in

all: allgebra-frontend

login:
ifeq ($(CI_BUILD_TOKEN),)
	docker login $(REGISTRY)
else
	docker login -u gitlab-ci-token -p $(CI_BUILD_TOKEN) $(REGISTRY)
endif

allgebra: Dockerfile
	docker build -t $(REGISTRY):$(CI_COMMIT_REF_NAME) . --target=base-devel

allgebra-frontend: allgebra
	docker build -t $(REGISTRY)/frontend:$(CI_COMMIT_REF_NAME) . --target=frontend

push: login allgebra
	docker push $(REGISTRY):$(CI_COMMIT_REF_NAME)
ifeq ($(CI_COMMIT_REF_NAME),master)
	docker build -t $(REGISTRY):latest . -f Dockerfile
	docker push $(REGISTRY):latest
endif

in: allgebra
	docker run -it \
		-u `id -u`:`id -g` \
		--gpus all \
		-v $(PWD)/test:/test \
		$(REGISTRY):$(CI_COMMIT_REF_NAME)

frontend: allgebra-frontend
	docker run -it \
		-u `id -u`:`id -g` \
		--gpus all \
		--privileged \
		-v $(PWD)/test:/test \
		$(REGISTRY)/frontend:$(CI_COMMIT_REF_NAME)

test: allgebra
	docker run \
		-u `id -u`:`id -g` \
		--gpus all \
		-v $(PWD)/test:/test \
		$(REGISTRY):$(CI_COMMIT_REF_NAME) \
		make -C /test test

test-nsys: allgebra-frontend
	docker run \
		-u `id -u`:`id -g` \
		--gpus all \
		-v $(PWD)/test:/test \
		$(REGISTRY)/frontend:$(CI_COMMIT_REF_NAME) \
		make -C /test test-nsys
