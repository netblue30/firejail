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
#include <dirent.h>
#include <sys/wait.h>

typedef struct {
	char *tfile;
} TestFile;

#define MAX_TEST_FILES 32
TestFile tf[MAX_TEST_FILES];
static int files_cnt = 0;

void sysfiles_setup(const char *file) {
	// I am root!
	assert(file);

	if (files_cnt >= MAX_TEST_FILES) {
		fprintf(stderr, "Error: maximum number of system test files exceeded\n");
		exit(1);
	}

	if (access(file, F_OK)) {
		// no such file
		return;
	}


	char *fname = strdup(file);
	if (!fname)
		errExit("strdup");

	tf[files_cnt].tfile = fname;
	files_cnt++;
}

void sysfiles_test(void) {
	// I am root in sandbox mount namespace
	assert(user_uid);
	int i;

	pid_t child = fork();
	if (child == -1)
		errExit("fork");

	if (child == 0) { // child
		// drop privileges
		if (setgid(user_gid) != 0)
			errExit("setgid");
		if (setuid(user_uid) != 0)
			errExit("setuid");

		for (i = 0; i < files_cnt; i++) {
			assert(tf[i].tfile);

			// try to open the file for reading
			FILE *fp = fopen(tf[i].tfile, "r");
			if (fp) {

				printf("   Warning: I can access %s\n", tf[i].tfile);
				fclose(fp);
			}
		}
		exit(0);
	}

	// wait for the child to finish
	int status;
	wait(&status);
}
