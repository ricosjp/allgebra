#include <stdio.h>
#include "cuda_runtime.h"

int main()
{
	cudaDeviceProp prp;
	cudaError_t cudaStatus;

	cudaStatus = cudaGetDeviceProperties(&prp, /*device=*/0);
	if (cudaStatus != cudaSuccess) {
		printf("cudaGetDeviceProperties error");
		return 1;
	}

	printf("%d%d\n", prp.major, prp.minor);

	return 0;
}
