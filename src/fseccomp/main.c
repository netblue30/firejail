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
#include "fseccomp.h"
#include "../include/seccomp.h"
int arg_quiet = 0;
int arg_seccomp_error_action = SECCOMP_RET_ERRNO | EPERM; // error action: errno, log or kill

static const char *const usage_str =
	"Usage:\n"
	"\tfseccomp debug-syscalls\n"
	"\tfseccomp debug-syscalls32\n"
	"\tfseccomp debug-errnos\n"
	"\tfseccomp debug-protocols\n"
	"\tfseccomp protocol build list file\n"
	"\tfseccomp secondary 64 file\n"
	"\tfseccomp secondary 32 file\n"
	"\tfseccomp secondary block file\n"
	"\tfseccomp default file\n"
	"\tfseccomp default file allow-debuggers\n"
	"\tfseccomp default32 file\n"
	"\tfseccomp default32 file allow-debuggers\n"
	"\tfseccomp drop file1 file2 list\n"
	"\tfseccomp drop file1 file2 list allow-debuggers\n"
	"\tfseccomp drop32 file1 file2 list\n"
	"\tfseccomp drop32 file1 file2 list allow-debuggers\n"
	"\tfseccomp default drop file1 file2 list\n"
	"\tfseccomp default drop file1 file2 list allow-debuggers\n"
	"\tfseccomp default32 drop file1 file2 list\n"
	"\tfseccomp default32 drop file1 file2 list allow-debuggers\n"
	"\tfseccomp keep file1 file2 list\n"
	"\tfseccomp keep32 file1 file2 list\n"
	"\tfseccomp memory-deny-write-execute file\n"
	"\tfseccomp memory-deny-write-execute.32 file\n"
	"\tfseccomp restrict-namespaces file list\n"
	"\tfseccomp restrict-namespaces.32 file list\n";

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
	if (argc < 2) {
		usage();
		return 1;
	}
	if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-?") ==0) {
		usage();
		return 0;
	}

	warn_dumpable();

	char *quiet = getenv("FIREJAIL_QUIET");
	if (quiet && strcmp(quiet, "yes") == 0)
		arg_quiet = 1;

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

	if (argc == 2 && strcmp(argv[1], "debug-syscalls") == 0)
		syscall_print();
	else if (argc == 2 && strcmp(argv[1], "debug-syscalls32") == 0)
		syscall_print_32();
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
		seccomp_default(argv[2], 0, true);
	else if (argc == 4 && strcmp(argv[1], "default") == 0 && strcmp(argv[3], "allow-debuggers") == 0)
		seccomp_default(argv[2], 1, true);
	else if (argc == 3 && strcmp(argv[1], "default32") == 0)
		seccomp_default(argv[2], 0, false);
	else if (argc == 4 && strcmp(argv[1], "default32") == 0 && strcmp(argv[3], "allow-debuggers") == 0)
		seccomp_default(argv[2], 1, false);
	else if (argc == 5 && strcmp(argv[1], "drop") == 0)
		seccomp_drop(argv[2], argv[3], argv[4], 0, true);
	else if (argc == 6 && strcmp(argv[1], "drop") == 0 && strcmp(argv[5], "allow-debuggers") == 0)
		seccomp_drop(argv[2], argv[3], argv[4], 1, true);
	else if (argc == 5 && strcmp(argv[1], "drop32") == 0)
		seccomp_drop(argv[2], argv[3], argv[4], 0, false);
	else if (argc == 6 && strcmp(argv[1], "drop32") == 0 && strcmp(argv[5], "allow-debuggers") == 0)
		seccomp_drop(argv[2], argv[3], argv[4], 1, false);
	else if (argc == 6 && strcmp(argv[1], "default") == 0 && strcmp(argv[2], "drop") == 0)
		seccomp_default_drop(argv[3], argv[4], argv[5], 0, true);
	else if (argc == 7 && strcmp(argv[1], "default") == 0 && strcmp(argv[2], "drop") == 0 && strcmp(argv[6], "allow-debuggers") == 0)
		seccomp_default_drop(argv[3], argv[4], argv[5], 1, true);
	else if (argc == 6 && strcmp(argv[1], "default32") == 0 && strcmp(argv[2], "drop") == 0)
		seccomp_default_drop(argv[3], argv[4], argv[5], 0, false);
	else if (argc == 7 && strcmp(argv[1], "default32") == 0 && strcmp(argv[2], "drop") == 0 && strcmp(argv[6], "allow-debuggers") == 0)
		seccomp_default_drop(argv[3], argv[4], argv[5], 1, false);
	else if (argc == 5 && strcmp(argv[1], "keep") == 0)
		seccomp_keep(argv[2], argv[3], argv[4], true);
	else if (argc == 5 && strcmp(argv[1], "keep32") == 0)
		seccomp_keep(argv[2], argv[3], argv[4], false);
	else if (argc == 3 && strcmp(argv[1], "memory-deny-write-execute") == 0)
		memory_deny_write_execute(argv[2]);
	else if (argc == 3 && strcmp(argv[1], "memory-deny-write-execute.32") == 0)
		memory_deny_write_execute_32(argv[2]);
	else if (argc == 4 && strcmp(argv[1], "restrict-namespaces") == 0)
		deny_ns(argv[2], argv[3]);
	else if (argc == 4 && strcmp(argv[1], "restrict-namespaces.32") == 0)
		deny_ns_32(argv[2], argv[3]);
	else {
		fprintf(stderr, "Error fseccomp: invalid arguments\n");
		return 1;
	}

	return 0;
}
