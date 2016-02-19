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
#include <grp.h>
#include <pwd.h>


void check_user(int argc, char **argv) {
	EUID_ASSERT();
	int i;
	char *user = NULL;

	int found = 0;
	for (i = 1; i < argc; i++) {
		// check options
		if (strcmp(argv[i], "--") == 0)
			break;
		if (strncmp(argv[i], "--", 2) != 0)
			break;
		
		// check user option		
		if (strncmp(argv[i], "--user=", 7) == 0) {
			found = 1;
			user = argv[i] + 7;
			break;
		}
	}
	if (!found)
		return;

	// check root
	if (getuid() != 0) {
		fprintf(stderr, "Error: you need to be root to use --user command line option\n");
		exit(1);
	}
	
	// switch user
	struct passwd *pw = getpwnam(user);
	if (!pw) {
		fprintf(stderr, "Error: cannot find user %s\n", user);
		exit(1);
	}

	printf("Switching to user %s, UID %d, GID %d\n", user, pw->pw_uid, pw->pw_gid);
	int rv = initgroups(user, pw->pw_gid);
	if (rv == -1) {
		perror("initgroups");
		fprintf(stderr, "Error: cannot switch to user %s\n", user);
	}

	rv = setgid(pw->pw_gid);
	if (rv == -1) {
		perror("setgid");
		fprintf(stderr, "Error: cannot switch to user %s\n", user);
	}

	rv = setuid(pw->pw_uid);
	if (rv == -1) {
		perror("setuid");
		fprintf(stderr, "Error: cannot switch to user %s\n", user);
	}

	// build the new command line
	int len = 0;
	for (i = 0; i < argc; i++) {
		len += strlen(argv[i]) + 1; // + ' '
	}
	
	char *cmd = malloc(len + 1); // + '\0'
	if (!cmd)
		errExit("malloc");
	
	char *ptr = cmd;
	int first = 1;
	for (i = 0; i < argc; i++) {
		if (strncmp(argv[i], "--user=", 7) == 0 && first) {
			first = 0;
			continue;
		}
		
		ptr += sprintf(ptr, "%s ", argv[i]);
	}

	// run command
	char *a[4];
	a[0] = "/bin/bash";
	a[1] = "-c";
	a[2] = cmd;
	a[3] = NULL;

	execvp(a[0], a); 

	perror("execvp");
	exit(1);
}
