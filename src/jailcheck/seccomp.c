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
#include "jailcheck.h"
#define MAXBUF 4096

void seccomp_test(pid_t pid) {
	char *file;
	if (asprintf(&file, "/proc/%d/status", pid) == -1)
		errExit("asprintf");

	FILE *fp = fopen(file, "r");
	if (!fp) {
		printf("  Error: cannot open %s\n", file);
		free(file);
		return;
	}

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		if (strncmp(buf, "Seccomp:", 8) == 0) {
			int val = -1;
			int rv = sscanf(buf + 8, "\t%d", &val);
			if (rv != 1 || val == 0)
				printf("   Warning: seccomp not enabled\n");
			break;
		}
	}
	fclose(fp);
	free(file);
}
