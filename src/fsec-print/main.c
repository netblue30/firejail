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
#include "fsec_print.h"

static const char *const usage_str =
	"Usage:\n"
	"\tfsec-print file - disassemble seccomp filter\n";

static void usage(void) {
	puts(usage_str);
}

int arg_quiet = 0;
void filter_add_errno(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void) fd;
	(void) syscall;
	(void) arg;
	(void) ptrarg;
	(void) native;
}

void filter_add_blacklist_override(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void) fd;
	(void) syscall;
	(void) arg;
	(void) ptrarg;
	(void) native;
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


	// print filter
	print(filter, entries);

	// free mapped memory
	if (munmap(filter, size) == -1)
		perror("Error un-mmapping the file");

	// close file
	close(fd);
	return 0;
errexit:
	if (fd != -1)
		close(fd);
	fprintf(stderr, "Error: cannot read %s\n", fname);
	exit(1);

}
