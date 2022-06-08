/*
 * Copyright (C) 2014-2022 Firejail Authors
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
#include "../include/gcov_wrapper.h"
#include <sys/wait.h>
#include <errno.h>

#define MAXBUF 4096

void save_cgroup(void) {
	if (cfg.cgroup == NULL)
		return;

	FILE *fp = fopen(RUN_CGROUP_CFG, "wxe");
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

static int is_cgroup_path(const char *fname) {
	// path starts with /sys/fs/cgroup
	if (strncmp(fname, "/sys/fs/cgroup", 14) != 0)
		return 0;

	// no .. traversal
	char *ptr = strstr(fname, "..");
	if (ptr)
		return 0;

	return 1;
}

void check_cgroup_file(const char *fname) {
	assert(fname);
	invalid_filename(fname, 0); // no globbing

	if (!is_cgroup_path(fname))
		goto errout;

	const char *base = gnu_basename(fname);
	if (strcmp(base, "tasks") != 0 &&  // cgroup v1
	    strcmp(base, "cgroup.procs") != 0)
		goto errout;

	if (access(fname, W_OK) == 0)
		return;

errout:
	fprintf(stderr, "Error: invalid cgroup\n");
	exit(1);
}

static void do_set_cgroup(const char *fname, pid_t pid) {
	FILE *fp = fopen(fname, "ae");
	if (!fp) {
		fwarning("cannot open %s for writing: %s\n", fname, strerror(errno));
		return;
	}

	int rv = fprintf(fp, "%d\n", pid);
	(void) rv;
	fclose(fp);
}

void set_cgroup(const char *fname, pid_t pid) {
	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		drop_privs(0);

		do_set_cgroup(fname, pid);

		__gcov_flush();

		_exit(0);
	}
	waitpid(child, NULL, 0);
}
