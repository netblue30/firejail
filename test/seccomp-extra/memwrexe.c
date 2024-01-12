// This file is part of Firejail project
// Copyright (C) 2014-2024 Firejail Authors
// License GPL v2

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/syscall.h>

static void usage(void) {
	printf("memwrexe options\n");
	printf("where options is:\n");
	printf("\tmmap - mmap test\n");
	printf("\tmprotect - mprotect test\n");
	printf("\tmemfd_create - memfd_create test\n");
}

int main(int argc, char **argv) {
	if (argc != 2) {
		fprintf(stderr, "TESTING ERROR: memwrexe insufficient params\n");
		usage();
		return 1;
	}

	if (strcmp(argv[1], "mmap") == 0) {
		// open some file
		int fd = open("memwrexe.c", O_RDONLY);
		if (fd == -1) {
			fprintf(stderr, "TESTING ERROR: file not found, cannot run mmap test\n");
			return 1;
		}

		int size = lseek(fd, 0, SEEK_END);
		if (size == -1) {
			fprintf(stderr, "TESTING ERROR: file not found, cannot run mmap test\n");
			return 1;
		}

		void *p = mmap (0, size, PROT_WRITE|PROT_READ|PROT_EXEC, MAP_SHARED, fd, 0);
		if (p == MAP_FAILED) {
			printf("mmap failed\n");
			return 0;
		}

		printf("mmap successful\n");

		// wait for expect to timeout
		sleep(100);

		return 0;
	}

	else if (strcmp(argv[1], "mprotect") == 0) {
		// open some file
		int fd = open("memwrexe.c", O_RDWR);
		if (fd == -1) {
			fprintf(stderr, "TESTING ERROR: file not found, cannot run mmap test\n");
			return 1;
		}

		int size = lseek(fd, 0, SEEK_END);
		if (size == -1) {
			fprintf(stderr, "TESTING ERROR: file not found, cannot run mmap test\n");
			return 1;
		}

		void *p = mmap (0, size, PROT_READ, MAP_SHARED, fd, 0);
		if (p == MAP_FAILED) {
			fprintf(stderr, "TESTING ERROR: cannot map file for mprotect test\n");
			return 1;
		}

		int rv = mprotect(p, size, PROT_READ|PROT_WRITE|PROT_EXEC);
		if (rv) {
			printf("mprotect failed\n");
			return 1;
		}

		printf("mprotect successful\n");

		// wait for expect to timeout
		sleep(100);

		return 0;
	}

	else if (strcmp(argv[1], "memfd_create") == 0) {
		int fd = syscall(SYS_memfd_create, "memfd_create", 0);
		if (fd == -1) {
			printf("memfd_create failed\n");
			return 1;
		}
		printf("memfd_create successful\n");

		// wait for expect to timeout
		sleep(100);

		return 0;
	}
}
