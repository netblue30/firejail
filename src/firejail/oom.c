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
#include "firejail.h"
#include <sys/wait.h>

void oom_set(const char *oom_string) {
	int oom = atoi(oom_string);
	uid_t uid = getuid();
	if (uid == 0) {
		if (oom < -1000 || oom > 1000) {
			fprintf(stderr, "Error: invalid oom value (-1000 to 1000)\n");
			exit(1);
		}
	}
	else {
		if (oom < 0 || oom > 1000) {
			fprintf(stderr, "Error: invalid oom value (0 to 1000)\n");
			exit(1);
		}
	}

	pid_t parent = getpid();
	pid_t child = fork();
	if (child == -1)
		errExit("fork");
	if (child == 0) {
		EUID_ROOT();
		// elevate privileges
		if (setreuid(0, 0))
			errExit("setreuid");
		if (setregid(0, 0))
			errExit("setregid");

		char *fname;
		if (asprintf(&fname, "/proc/%d/oom_score_adj", parent) == -1)
			errExit("asprintf");
		FILE *fp = fopen(fname, "w");
		if (!fp) {
			fprintf(stderr, "Error: cannot open %s\n", fname);
			exit(1);
		}
		fprintf(fp, "%d", oom);
		fclose(fp);
		free(fname);

		if (asprintf(&fname, "/proc/%d/oom_score", parent) == -1)
			errExit("asprintf");
		fp = fopen(fname, "r");
		if (!fp) {
			fprintf(stderr, "Error: cannot open %s\n", fname);
			exit(1);
		}
		int newoom;
		if (1 != fscanf(fp, "%d", &newoom)) {
			fprintf(stderr, "Error: cannot read from %s\n", fname);
			exit(1);
		}
		fclose(fp);
		free(fname);

		if (!arg_quiet)
			printf("Out-Of-Memory score adjusted, new value %d\n", newoom);
		exit(0);
	}

	int status;
	if (waitpid(child, &status, 0) == -1 )
		errExit("waitpid");
}
