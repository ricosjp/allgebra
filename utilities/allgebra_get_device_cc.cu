#include <stdio.h>
#include "cuda_runtime.h"

int main()
{
	cudaDeviceProp prop;
	cudaError_t cudaStatus;

	cudaStatus = cudaGetDeviceProperties(&prop, 0); // 0 is device number
	if (cudaStatus != cudaSuccess) {
		printf("cudaGetDeviceProperties error");
		return 1;
	}

	printf("%d%d\n", prop.major, prop.minor);

	return 0;
}
