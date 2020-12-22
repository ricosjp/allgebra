PUBLIC_REGISTRY    := ghcr.io/ricosjp/allgebra
CI_REGISTRY_IMAGE  ?= registry.ritc.jp/ricos/allgebra
CI_COMMIT_REF_NAME ?= manual_deploy

TARGETS := cuda10_1 cuda10_1/clang11gcc7 cuda10_1/clang11gcc7/mkl cuda10_1/clang11gcc7/oss

.PHONY: $(TARGETS)

cuda10_1:
	$(MAKE) -C $@

cuda10_1/clang11gcc7: cuda10_1
	$(MAKE) -C $@

cuda10_1/clang11gcc7/mkl: cuda10_1/clang11gcc7
	$(MAKE) -C $@

cuda10_1/clang11gcc7/oss: cuda10_1/clang11gcc7
	$(MAKE) -C $@

push: $(TARGETS)
	$(foreach TARGET,$(subst /,-,$(TARGETS)),docker push $(CI_REGISTRY_IMAGE)/$(TARGET):$(CI_COMMIT_REF_NAME);)
