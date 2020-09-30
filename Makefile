# Get from GitLab CI environmental variables
# See also https://docs.gitlab.com/ee/ci/variables/
CI_REGISTRY_IMAGE  ?= registry.ritc.jp/ricos/allgebra
CI_COMMIT_REF_NAME ?= manual_deploy

TARGETS := doxygen clang-format cuda10_2 cuda11_0

.PHONY: $(TARGETS)
all: $(TARGETS)

define docker_build
$(1): $(1).Dockerfile
	docker build -t $(CI_REGISTRY_IMAGE)/$(1):$(CI_COMMIT_REF_NAME) . -f $(1).Dockerfile
endef

$(foreach TARGET,$(TARGETS),$(eval $(call docker_build,$(TARGET))))

push: $(TARGETS)
	$(foreach TARGET,$(TARGETS), \
		docker push $(CI_REGISTRY_IMAGE)/$(TARGET):$(CI_COMMIT_REF_NAME); \
	)
