/*
 * Copyright (C) 2014-2024 Firejail Authors
 *
 * This file is part of firejail project
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
#include "fsec_optimize.h"
#include "../include/syscall.h"

int arg_seccomp_error_action = SECCOMP_RET_ERRNO | EPERM; // error action: errno, log or kill

static const char *const usage_str =
	"Usage:\n"
	"\tfsec-optimize file - optimize seccomp filter\n";

static void usage(void) {
	puts(usage_str);
}

int main(int argc, char **argv) {
#if 0
{
//system("cat /proc/self/status");
int i;
for (i = 0; i < argc; i++)
	printf("*%s* ", argv[i]);
printf("\n");
}
#endif
	if (argc != 2) {
		usage();
		return 1;
	}

	if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-?") == 0) {
		usage();
		return 0;
	}

	warn_dumpable();

	char *error_action = getenv("FIREJAIL_SECCOMP_ERROR_ACTION");
	if (error_action) {
		if (strcmp(error_action, "kill") == 0)
			arg_seccomp_error_action = SECCOMP_RET_KILL;
		else if (strcmp(error_action, "log") == 0)
			arg_seccomp_error_action = SECCOMP_RET_LOG;
		else {
			arg_seccomp_error_action = errno_find_name(error_action);
			if (arg_seccomp_error_action == -1)
				errExit("seccomp-error-action: unknown errno");
			arg_seccomp_error_action |= SECCOMP_RET_ERRNO;
		}
	}

	char *fname = argv[1];

	// open input file
	int fd = open(fname, O_RDONLY);
	if (fd == -1)
		goto errexit;

	// calculate the number of entries
	int size = lseek(fd, 0, SEEK_END);
	if (size == -1) // todo: check maximum size of seccomp filter (4KB?)
		goto errexit;
	unsigned short entries = (unsigned short) size / (unsigned short) sizeof(struct sock_filter);

	// read filter
	struct sock_filter *filter = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
	if (filter == MAP_FAILED)
		goto errexit;
	close(fd);

	// duplicate the filter memory and unmap the file
	struct sock_filter *outfilter = duplicate(filter, entries);
	if (munmap(filter, size) == -1)
		perror("Error un-mmapping the file");

	// optimize filter
	entries = optimize(outfilter, entries);

	// write the new file and free memory
	fd = open(argv[1], O_WRONLY | O_TRUNC | O_CREAT, 0755);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot open output file\n");
		return 1;
	}
	size = write(fd, outfilter, entries * sizeof(struct sock_filter));
	if (size != (int) (entries * sizeof(struct sock_filter))) {
		fprintf(stderr, "Error: cannot write output file\n");
		return 1;
	}
	close(fd);
	free(outfilter);

	return 0;
errexit:
	if (fd != -1)
		close(fd);
	fprintf(stderr, "Error: cannot read %s\n", fname);
	exit(1);

}
