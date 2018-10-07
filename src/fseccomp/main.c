/*
 * Copyright (C) 2014-2018 Firejail Authors
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
#include "fseccomp.h"
int arg_quiet = 0;

static void usage(void) {
	printf("Usage:\n");
	printf("\tfseccomp debug-syscalls\n");
	printf("\tfseccomp debug-errnos\n");
	printf("\tfseccomp debug-protocols\n");
	printf("\tfseccomp protocol build list file\n");
	printf("\tfseccomp secondary 64 file\n");
	printf("\tfseccomp secondary 32 file\n");
	printf("\tfseccomp secondary block file\n");
	printf("\tfseccomp default file\n");
	printf("\tfseccomp default file allow-debuggers\n");
	printf("\tfseccomp drop file1 file2 list\n");
	printf("\tfseccomp drop file1 file2 list allow-debuggers\n");
	printf("\tfseccomp default drop file1 file2 list\n");
	printf("\tfseccomp default drop file1 file2 list allow-debuggers\n");
	printf("\tfseccomp keep file1 file2 list\n");
	printf("\tfseccomp memory-deny-write-execute file\n");
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
	if (argc < 2) {
		usage();
		return 1;
	}

	char *quiet = getenv("FIREJAIL_QUIET");
	if (quiet && strcmp(quiet, "yes") == 0)
		arg_quiet = 1;

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
	else if (argc == 4 && strcmp(argv[1], "secondary") == 0 && strcmp(argv[2], "32") == 0)
		seccomp_secondary_32(argv[3]);
	else if (argc == 4 && strcmp(argv[1], "secondary") == 0 && strcmp(argv[2], "block") == 0)
		seccomp_secondary_block(argv[3]);
	else if (argc == 3 && strcmp(argv[1], "default") == 0)
		seccomp_default(argv[2], 0);
	else if (argc == 4 && strcmp(argv[1], "default") == 0 && strcmp(argv[3], "allow-debuggers") == 0)
		seccomp_default(argv[2], 1);
	else if (argc == 5 && strcmp(argv[1], "drop") == 0)
		seccomp_drop(argv[2], argv[3], argv[4], 0);
	else if (argc == 6 && strcmp(argv[1], "drop") == 0 && strcmp(argv[5], "allow-debuggers") == 0)
		seccomp_drop(argv[2], argv[3], argv[4], 1);
	else if (argc == 6 && strcmp(argv[1], "default") == 0 && strcmp(argv[2], "drop") == 0)
		seccomp_default_drop(argv[3], argv[4], argv[5], 0);
	else if (argc == 7 && strcmp(argv[1], "default") == 0 && strcmp(argv[2], "drop") == 0 && strcmp(argv[6], "allow-debuggers") == 0)
		seccomp_default_drop(argv[3], argv[4], argv[5], 1);
	else if (argc == 5 && strcmp(argv[1], "keep") == 0)
		seccomp_keep(argv[2], argv[3], argv[4]);
	else if (argc == 3 && strcmp(argv[1], "memory-deny-write-execute") == 0)
		memory_deny_write_execute(argv[2]);
	else {
		fprintf(stderr, "Error fseccomp: invalid arguments\n");
		return 1;
	}

	return 0;
}
