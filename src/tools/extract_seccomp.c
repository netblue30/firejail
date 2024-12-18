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

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <linux/filter.h>

#define MAXBUF 1024
#define errExit(msg) \
	do { \
		char msgout[256]; \
		snprintf(msgout, 256, "Error %d: %s", __LINE__, (msg)); \
		perror(msgout); \
		exit(1); \
	} while (0);

// dump all seccomp filters of a process
// for further analysis with fsec-print
// requires kernel 4.4 or higher

void dump_filter(const char *dname, unsigned cnt, const struct sock_filter *f, size_t nmemb) {
	char fname[MAXBUF];
	snprintf(fname, MAXBUF, "%s/%u", dname, cnt);
	printf("Writing file %s\n", fname);
	FILE *fp = fopen(fname, "w");
	if (!fp) {
		printf("Error: Cannot open %s for writing: %s\n", fname, strerror(errno));
		exit(1);
	}
	if (fwrite(f, sizeof(struct sock_filter), nmemb, fp) != nmemb) {
		printf("Error: Cannot write %s\n", fname);
		exit(1);
	}
	fclose(fp);
}

int main(int argc, char **argv) {
	if (argc != 2)
		goto usage;
	pid_t pid = (pid_t) strtol(argv[1], NULL, 10);
	if (pid <= 0)
		goto usage;

	printf("** Attaching to process with pid %d **\n", pid);
	long rv = ptrace(PTRACE_ATTACH, pid, 0, 0);
	if (rv != 0) {
		printf("Error: Cannot attach: %s\n", strerror(errno));
		exit(1);
	}
	waitpid(pid, NULL, 0);
	printf("Attached\n");

	char dname[MAXBUF];
	snprintf(dname, MAXBUF, "/tmp/seccomp-%d", pid);
	printf("** Creating directory %s **\n", dname);
	if (mkdir(dname, 0755) < 0) {
		printf("Error: Cannot create directory: %s\n", strerror(errno));
		exit(1);
	}
	printf("Created\n");

	printf("** Extracting seccomp filters **\n");
	unsigned cnt = 0;
	while ((rv = ptrace(PTRACE_SECCOMP_GET_FILTER, pid, cnt, NULL)) > 0) {
		struct sock_filter *f = malloc(rv * sizeof(struct sock_filter));
		if (!f)
			errExit("malloc");
		if (ptrace(PTRACE_SECCOMP_GET_FILTER, pid, cnt, f) < 0)
			errExit("ptrace");

		dump_filter(dname, cnt, f, rv);
		free(f);
		cnt++;
	}

	if (cnt)
		printf("Dumped %u filters\n", cnt);
	else {
		printf("No seccomp filter was found\n");
		printf("** Cleanup **\n");
		if (remove(dname) == 0)
			printf("Removed %s\n", dname);
		else
			printf("Could not remove %s: %s\n", dname, strerror(errno));
	}

	printf("Bye ...\n");
	return 0;

usage:
	printf("Usage: %s <PID>\n", argv[0]);
	return 1;
}
