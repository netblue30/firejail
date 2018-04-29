/*
 * Copyright (C) 2014-2018 Firejail Authors
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

//
// Firejail access database inplementation
//
// The database is a simple list of users allowed to run firejail SUID executable
// It is usually stored in /etc/firejail/firejail.users
// One username per line in the file

#include "../include/common.h"
#include <sys/types.h>
#include <pwd.h>
#include "../../uids.h"

#define MAXBUF 4098
static inline char *get_fname(void) {
	char *fname;
	if (asprintf(&fname, "%s/firejail.users", SYSCONFDIR) == -1)
		errExit("asprintf");
	return fname;
}

// returns 1 if the user is found in the database or if the database was not created
int firejail_user_check(const char *name) {
	assert(name);

	// root is allowed to run firejail by default
	if (strcmp(name, "root") == 0)
		return 1;

	// other system users will run the program as is
	uid_t uid = getuid();
	if ((uid < UID_MIN && uid != 0) || strcmp(name, "nobody") == 0)
		return 0;

	// check file existence
	char *fname = get_fname();
	if (access(fname, F_OK)) {
		free(fname);
		return 1;	// assume the user doesn't care about access checking
	}

	FILE *fp = fopen(fname, "r");
	free(fname);
	if (!fp)
		return 0;

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		// lines starting with # are comments
		if (*buf == '#')
			continue;

		// remove \n
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';

		// compare
		if (strcmp(buf, name) == 0) {
			fclose(fp);
			return 1;
		}
	}

	fclose(fp);
	return 0;
}

// add a user to the database
void firejail_user_add(const char *name) {
	assert(name);

	// is this a real user?
	struct passwd *pw = getpwnam(name);
	if (!pw) {
		fprintf(stderr, "Error: user %s not found on this system.\n", name);
		return;
	}

	// check the user is not already in the database
	char *fname = get_fname();
	assert(fname);
	if (access(fname, F_OK) == 0) {
		if (firejail_user_check(name)) {
			printf("User %s already in the database\n", name);
			return;
		}
	}

	printf("%s created\n", fname);
	FILE *fp = fopen(fname, "a+");
	if (!fp) {
		fprintf(stderr, "Error: cannot open %s\n", fname);
		perror("fopen");
		free(fname);
		return;
	}
	free(fname);

	fprintf(fp, "%s\n", name);
	fclose(fp);
}
