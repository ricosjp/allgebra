.PHONY: test

test:
	$(MAKE) -C cuda10_2 test
	$(MAKE) -C cuda11_0 test
