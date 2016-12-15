/*
 * Copyright (C) 2014-2016 Firejail Authors
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

void run_symlink(int argc, char **argv) {
	EUID_ASSERT();
	
	char *program = strrchr(argv[0], '/');
	if (program)
		program += 1;
	else
		program = argv[0];
	if (strcmp(program, "firejail") == 0)
		return;

	// find the real program
	// probably the first entry returend by "which -a" is a symlink - use the second entry!
	char *p = getenv("PATH");
	if (!p) {
		fprintf(stderr, "Error: PATH environment variable not set\n");
		exit(1);
	}
	
	char *path = strdup(p);
	if (!path)
		errExit("strdup");

	char *selfpath = realpath("/proc/self/exe", NULL);
	if (!selfpath)
		errExit("realpath");

	// look in path for our program
	char *tok = strtok(path, ":");
	int found = 0;
	while (tok) {
		char *name;
		if (asprintf(&name, "%s/%s", tok, program) == -1)
			errExit("asprintf");

		struct stat s;
		if (stat(name, &s) == 0) {
			/* coverity[toctou] */
			char* rp = realpath(name, NULL);
			if (!rp)
				errExit("realpath");

			if (strcmp(selfpath, rp) != 0) {
				program = strdup(name);
				found = 1;
				free(rp);
				break;
			}

			free(rp);
		}

		free(name);
		tok = strtok(NULL, ":");
	}
	if (!found) {
		fprintf(stderr, "Error: cannot find the program in the path\n");
		exit(1);
	}

	free(selfpath);


	// start the argv[0] program in a new sandbox
	char *firejail;
	if (asprintf(&firejail, "%s/bin/firejail", PREFIX) == -1)
		errExit("asprintf");

	// drop privileges
	if (setgid(getgid()) < 0)
		errExit("setgid/getgid");
	if (setuid(getuid()) < 0)
		errExit("setuid/getuid");

	// run command
	char *a[3 + argc];
	a[0] = firejail;
	a[1] = program;
	int i;
	for (i = 0; i < (argc - 1); i++) {
		a[i + 2] = argv[i + 1];
	}
	a[i + 2] = NULL;
	assert(getenv("LD_PRELOAD") == NULL);	
	execvp(a[0], a); 

	perror("execvp");
	exit(1);
}
