#include <stdio.h>

int main(int argc, char **argv) {
	printf("Arguments:\n");

	int i;
	for (i = 0; i < argc; i++) {
		printf("#%s#\n", argv[i]);
	}
	
	return 0;
}
