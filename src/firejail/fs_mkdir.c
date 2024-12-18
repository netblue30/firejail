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
#include "../include/gcov_wrapper.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <grp.h>
#include <sys/wait.h>
#include <string.h>

static void check(const char *fname) {
	// manufacture /run/user directory
	char *runuser;
	if (asprintf(&runuser, "/run/user/%d/", getuid()) == -1)
		errExit("asprintf");

	if (strncmp(fname, cfg.homedir, strlen(cfg.homedir)) != 0 &&
	    strncmp(fname, "/tmp", 4) != 0 &&
	    strncmp(fname, runuser, strlen(runuser)) != 0) {
		fprintf(stderr, "Error: only files or directories in user home, /tmp, or /run/user/<UID> are supported by mkdir\n");
		exit(1);
	}
	free(runuser);
}

static void mkdir_recursive(char *path) {
	char *subdir = NULL;
	struct stat s;

	if (chdir("/")) {
		fprintf(stderr, "Error: can't chdir to /\n");
		return;
	}

	subdir = strtok(path, "/");
	while(subdir) {
		if (stat(subdir, &s) == -1) {
			/* coverity[toctou] */
			if (mkdir(subdir, 0700) == -1) {
				fwarning("cannot create %s directory\n", subdir);
				return;
			}
		} else if (!S_ISDIR(s.st_mode)) {
			fwarning("'%s exists, but is not a directory\n", subdir);
			return;
		}
		if (chdir(subdir)) {
			fprintf(stderr, "Error: can't chdir to %s\n", subdir);
			return;
		}

		subdir = strtok(NULL, "/");
	}
}

void fs_mkdir(const char *name) {
	EUID_ASSERT();

	// check directory name
	invalid_filename(name, 0); // no globbing
	char *expanded = expand_macros(name);
	check(expanded); // will exit if wrong path

	struct stat s;
	if (stat(expanded, &s) == 0) {
		// file exists, do nothing
		goto doexit;
	}

	// create directory
	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		// drop privileges
		drop_privs(0);

		// create directory
		mkdir_recursive(expanded);

		__gcov_flush();

		_exit(0);
	}
	// wait for the child to finish
	waitpid(child, NULL, 0);

doexit:
	free(expanded);
}

void fs_mkfile(const char *name) {
	EUID_ASSERT();

	// check file name
	invalid_filename(name, 0); // no globbing
	char *expanded = expand_macros(name);
	check(expanded); // will exit if wrong path

	struct stat s;
	if (stat(expanded, &s) == 0) {
		// file exists, do nothing
		goto doexit;
	}

	// create file
	touch_file_as_user(expanded, 0600);

doexit:
	free(expanded);
}
