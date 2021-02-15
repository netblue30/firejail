/*
 * Copyright (C) 2014-2021 Firejail Authors
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
#include <sys/stat.h>

#define MAXBUF 4096

void save_cgroup(void) {
	if (cfg.cgroup == NULL)
		return;

	FILE *fp = fopen(RUN_CGROUP_CFG, "w");
	if (fp) {
		fprintf(fp, "%s", cfg.cgroup);
		fflush(0);
		SET_PERMS_STREAM(fp, 0, 0, 0644);
		if (fclose(fp))
			goto errout;
	}
	else
		goto errout;

	return;

errout:
	fprintf(stderr, "Error: cannot save cgroup\n");
	exit(1);
}

void load_cgroup(const char *fname) {
	if (!fname)
		return;

	FILE *fp = fopen(fname, "r");
	if (fp) {
		char buf[MAXBUF];
		if (fgets(buf, MAXBUF, fp)) {
			cfg.cgroup = strdup(buf);
			if (!cfg.cgroup)
				errExit("strdup");
		}
		else
			goto errout;

		fclose(fp);
		return;
	}
errout:
	fwarning("cannot load control group\n");
	if (fp)
		fclose(fp);
}


void set_cgroup(const char *path) {
	EUID_ASSERT();

	invalid_filename(path, 0); // no globbing

	// path starts with /sys/fs/cgroup
	if (strncmp(path, "/sys/fs/cgroup", 14) != 0)
		goto errout;

	// path ends in tasks
	char *ptr = strstr(path, "tasks");
	if (!ptr)
		goto errout;
	if (*(ptr + 5) != '\0')
		goto errout;

	// no .. traversal
	ptr = strstr(path, "..");
	if (ptr)
		goto errout;

	// tasks file exists
	struct stat s;
	if (stat(path, &s) == -1)
		goto errout;

	// task file belongs to the user running the sandbox
	if (s.st_uid != getuid() && s.st_gid != getgid())
		goto errout2;

	// add the task to cgroup
	/* coverity[toctou] */
	FILE *fp = fopen(path,	"a");
	if (!fp)
		goto errout;
	pid_t pid = getpid();
	int rv = fprintf(fp, "%d\n", pid);
	(void) rv;
	fclose(fp);
	return;

errout:
	fprintf(stderr, "Error: invalid cgroup\n");
	exit(1);
errout2:
	fprintf(stderr, "Error: you don't have permissions to use this control group\n");
	exit(1);
}
