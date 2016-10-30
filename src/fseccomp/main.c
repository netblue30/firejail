#include "fseccomp.h"

static void usage(void) {
	printf("Usage:\n");
	printf("\tfseccomp debug-syscalls\n");
	printf("\tfseccomp debug-errnos\n");
	printf("\tfseccomp debug-protocols\n");
	printf("\tfseccomp protocol build list file\n");
}

int main(int argc, char **argv) {
#if 0
{
system("cat /proc/self/status");
int i;
for (i = 0; i < argc; i++)
        printf("*%s* ", argv[i]);
printf("\n");
}       
#endif
	if (argc < 2)
		return 1;
		
	if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-?") ==0) {
		usage();
		return 0;
	}
	else if (argc == 2 && strcmp(argv[1], "debug-syscalls") == 0)
		syscall_print();
	else if (argc == 2 && strcmp(argv[1], "debug-errnos") == 0)
		errno_print();
	else if (argc == 2 && strcmp(argv[1], "debug-protocols") == 0)
		protocol_print();
	else if (argc == 5 && strcmp(argv[1], "protocol") == 0 && strcmp(argv[2], "build") == 0)
		protocol_build_filter(argv[3], argv[4]);
	else {
		fprintf(stderr, "Error fseccomp: invalid arguments\n");
		return 1;
	}

	return 0;
}