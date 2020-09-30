# Get from GitLab CI environmental variables
# See also https://docs.gitlab.com/ee/ci/variables/
CI_REGISTRY_IMAGE  ?= registry.ritc.jp/ricos/allgebra
CI_COMMIT_REF_NAME ?= manual_deploy

CUDA_TARGETS := cuda10_2 cuda11_0
TARGETS := doxygen clang-format $(CUDA_TARGETS)

.PHONY: $(TARGETS)
all: $(TARGETS)
push: $(foreach TARGET,$(TARGETS),$(TARGET)-push)
test: $(foreach TARGET,$(CUDA_TARGETS),$(TARGET)-test-openacc $(TARGET)-test-nsys $(TARGET)-test-mkl)

define docker_commands
$(1): $(1).Dockerfile
	docker build -t $(CI_REGISTRY_IMAGE)/$(1):$(CI_COMMIT_REF_NAME) . -f $(1).Dockerfile

$(1)-in: $(1)
	docker run -it --rm $(CI_REGISTRY_IMAGE)/$(1):$(CI_COMMIT_REF_NAME)

$(1)-push: $(1)
	docker push $(CI_REGISTRY_IMAGE)/$(1):$(CI_COMMIT_REF_NAME)
endef
$(foreach TARGET,$(TARGETS),$(eval $(call docker_commands,$(TARGET))))

define test_commands
$(1)-test-openacc: $(1)
	docker run \
		--gpus all \
		--privileged \
		$(CI_REGISTRY_IMAGE)/$(1):$(CI_COMMIT_REF_NAME) \
		make -C /test test

$(1)-test-nsys: $(1)
	docker run \
		--gpus all \
		--privileged \
		$(CI_REGISTRY_IMAGE)/$(1):$(CI_COMMIT_REF_NAME) \
		make -C /test test-nsys

$(1)-test-mkl: $(1)
	docker run \
		$(CI_REGISTRY_IMAGE)/$(1):$(CI_COMMIT_REF_NAME) \
		pkg-config --exists mkl-dynamic-lp64-iomp
endef
$(foreach TARGET,$(CUDA_TARGETS),$(eval $(call test_commands,$(TARGET))))
