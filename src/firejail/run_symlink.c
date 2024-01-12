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
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>


void run_symlink(int argc, char **argv, int run_as_is) {
	EUID_ASSERT();

	char *program = strrchr(argv[0], '/');
	if (program)
		program += 1;
	else
		program = argv[0];
	if (strcmp(program, "firejail") == 0) // this is a regular "firejail program" sandbox starting
		return;

	// drop privileges
	if (setresgid(-1, getgid(), getgid()) != 0)
		errExit("setresgid");
	if (setresuid(-1, getuid(), getuid()) != 0)
		errExit("setresuid");

	// find the real program by looking in PATH
	const char *path = env_get("PATH");
	if (!path) {
		fprintf(stderr, "Error: PATH environment variable not set\n");
		exit(1);
	}

	char *p = find_in_path(program);
	if (!p) {
		fprintf(stderr, "Error: cannot find the program in the path\n");
		exit(1);
	}
	program = p;

	// restore original umask
	umask(orig_umask);

	// restore original environment variables
	env_apply_all();

	// desktop integration is not supported for root user; instead, the original program is started
	if (getuid() == 0 || run_as_is) {
		argv[0] = program;
		execv(program, argv);
		exit(1);
	}

	// start the argv[0] program in a new sandbox
	char *a[3 + argc];
	a[0] =PATH_FIREJAIL;
	a[1] = program;
	int i;
	for (i = 0; i < (argc - 1); i++) {
		a[i + 2] = argv[i + 1];
	}
	a[i + 2] = NULL;
	if (env_get("LD_PRELOAD") != NULL)
		fprintf(stderr, "run_symlink: LD_PRELOAD is: '%s'\n", env_get("LD_PRELOAD"));
	assert(env_get("LD_PRELOAD") == NULL);
	assert(getenv("LD_PRELOAD") == NULL);
	execvp(a[0], a);

	perror("execvp");
	exit(1);
}
