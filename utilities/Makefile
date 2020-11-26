
.PHONY: install
all: allgebra_get_device_cc

allgebra_get_device_cc: allgebra_get_device_cc.cu
	nvcc -o $@ $<

install: allgebra_get_device_cc
	cp $< /usr/bin/
