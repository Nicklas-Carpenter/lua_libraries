#include <dlfcn.h>
#include <stdio.h>

struct thing {
	int data;
};

struct thing test;

int main(int argc, char* argv) {
	test.data = 42;
	
	void* handle = dlopen(NULL, RTLD_NOW);
	void* recover = dlsym(handle, "main");
	printf("recover: %x\n", recover);
	// printf("test data: %d\n", ((struct thing *)recover)->data);
	return 0;
}
