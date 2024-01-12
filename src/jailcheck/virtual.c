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


#define MAX_TEST_FILES 16
static char *dirs[MAX_TEST_FILES];
static char *files[MAX_TEST_FILES];
static int files_cnt = 0;

void virtual_setup(const char *directory) {
	// I am root!
	assert(directory);
	assert(*directory == '/');
	assert(files_cnt < MAX_TEST_FILES);

	// try to open the dir as root
	DIR *dir = opendir(directory);
	if (!dir) {
		fprintf(stderr, "Warning: directory %s not found, skipping\n", directory);
		return;
	}
	closedir(dir);

	// create a test file
	char *test_file;
	if (asprintf(&test_file, "%s/jailcheck-private-%d", directory, getpid()) == -1)
		errExit("asprintf");

	FILE *fp = fopen(test_file, "w");
	if (!fp) {
		printf("Warning: I cannot create test file in directory %s, skipping...\n", directory);
		return;
	}
	fprintf(fp, "this file was created by firetest utility, you can safely delete it\n");
	fclose(fp);
	if (strcmp(directory, user_home_dir) == 0) {
		int rv = chown(test_file, user_uid, user_gid);
		if (rv)
			errExit("chown");
	}

	char *dname = strdup(directory);
	if (!dname)
		errExit("strdup");
	dirs[files_cnt] = dname;
	files[files_cnt] = test_file;
	files_cnt++;
}

void virtual_destroy(void) {
	// remove test files
	int i;

	for (i = 0; i < files_cnt; i++) {
		int rv = unlink(files[i]);
		(void) rv;
	}
	files_cnt = 0;
}

void virtual_test(void) {
	// I am root in sandbox mount namespace
	assert(user_uid);
	int i;

	int cnt = 0;
	cnt += printf("   Virtual dirs: "); fflush(0);

	for (i = 0; i < files_cnt; i++) {
		assert(files[i]);

		// I am root!
		pid_t child = fork();
		if (child == -1)
			errExit("fork");

		if (child == 0) { // child
			// drop privileges
			if (setgid(user_gid) != 0)
				errExit("setgid");
			if (setuid(user_uid) != 0)
				errExit("setuid");

			// try to open the file for reading
			FILE *fp = fopen(files[i], "r");
			if (fp)
				fclose(fp);
			else {
				if (cnt == 0)
					cnt += printf("\n                 ");
				cnt += printf("%s, ", dirs[i]);
				if (cnt > 60)
					cnt = 0;
			}
			fflush(0);
			exit(cnt);
		}

		// wait for the child to finish
		int status;
		wait(&status);
		cnt = WEXITSTATUS(status);
	}
	printf("\n");
}
