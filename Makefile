.PHONY: test push

test:
	$(MAKE) -C cuda10_2 test
	$(MAKE) -C cuda11_0 test

push:
	$(MAKE) -C cuda10_2 push
	$(MAKE) -C cuda11_0 push
	$(MAKE) -C clang-format push
