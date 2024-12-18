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

//
// Firejail access database implementation
//
// The database is a simple list of users allowed to run firejail SUID executable
// It is usually stored in /etc/firejail/firejail.users
// One username per line in the file

#include "../include/common.h"
#include "../include/firejail_user.h"
#include <sys/types.h>
#include <pwd.h>
#include <errno.h>

#define MAXBUF 4098

// minimum values for uid and gid extracted from /etc/login.defs
int uid_min = 0;
int gid_min = 0;

static void init_uid_gid_min(void) {
	if (uid_min != 0 && gid_min != 0)
		return;

	// read the real values from login.def
	FILE *fp = fopen("/etc/login.defs", "r");
	if (!fp) {
		fp = fopen("/usr/etc/login.defs", "r"); // openSUSE
		if (!fp)
			goto errexit;
	}

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		// comments
		if (*buf == '#')
			continue;
		// skip empty space
		char *ptr = buf;
		while (*ptr == ' ' || *ptr == '\t')
			ptr++;

		if (strncmp(ptr, "UID_MIN", 7) == 0) {
			int rv = sscanf(ptr + 7, "%d", &uid_min);
			if (rv != 1 || uid_min < 0) {
				fclose(fp);
				goto errexit;
			}
		}
		else if (strncmp(ptr, "GID_MIN", 7) == 0) {
			int rv = sscanf(ptr + 7, "%d", &gid_min);
			if (rv != 1 || gid_min < 0) {
				fclose(fp);
				goto errexit;
			}
		}

		if (uid_min != 0 && gid_min != 0)
			break;

	}
	fclose(fp);

	if (uid_min == 0 || gid_min == 0)
		goto errexit;
//printf("uid_min %d, gid_min %d\n", uid_min, gid_min);

	return;

errexit:
	fprintf(stderr, "Error: cannot read UID_MIN and/or GID_MIN from /etc/login.defs, using 1000 by default\n");
	uid_min = 1000;
	gid_min = 1000;
}



static inline char *get_fname(void) {
	char *fname;
	if (asprintf(&fname, "%s/firejail.users", SYSCONFDIR) == -1)
		errExit("asprintf");
	return fname;
}


// returns 1 if the user is found in the database or if the database was not created
int firejail_user_check(const char *name) {
	assert(name);
	init_uid_gid_min();

	// root is allowed to run firejail by default
	if (strcmp(name, "root") == 0)
		return 1;

	// user nobody is never allowed
	if (strcmp(name, "nobody") == 0)
		return 0;

	// check file existence
	char *fname = get_fname();
	assert(fname);
	if (access(fname, F_OK) == -1 && errno == ENOENT) {
		// assume the user doesn't care about access checking
		free(fname);
		return 1;
	}

	FILE *fp = fopen(fname, "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot read %s\n", fname);
		perror("fopen");
		exit(1);
	}
	free(fname);

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
		exit(1);
	}

	// check the user is not already in the database
	char *fname = get_fname();
	assert(fname);
	if (access(fname, F_OK) == 0) {
		if (firejail_user_check(name)) {
			printf("User %s already in the database\n", name);
			free(fname);
			return;
		}
	}
	else
		printf("Creating %s\n", fname);

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
