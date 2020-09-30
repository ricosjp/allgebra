# Get from GitLab CI environmental variables
# See also https://docs.gitlab.com/ee/ci/variables/
CI_REGISTRY_IMAGE  ?= registry.ritc.jp/ricos/allgebra
CI_COMMIT_REF_NAME ?= manual_deploy

TARGETS := doxygen clang-format cuda10_2 cuda11_0

.PHONY: $(TARGETS)
all: $(TARGETS)
push: $(foreach TARGET,$(TARGETS),$(TARGET)-push)

define docker_commands
$(1): $(1).Dockerfile
	docker build -t $(CI_REGISTRY_IMAGE)/$(1):$(CI_COMMIT_REF_NAME) . -f $(1).Dockerfile

$(1)-in: $(1)
	docker run -it --rm $(CI_REGISTRY_IMAGE)/$(1):$(CI_COMMIT_REF_NAME)

$(1)-push: $(1)
	docker push $(CI_REGISTRY_IMAGE)/$(1):$(CI_COMMIT_REF_NAME)
endef
$(foreach TARGET,$(TARGETS),$(eval $(call docker_commands,$(TARGET))))
