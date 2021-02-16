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
#include "faudit.h"
#include <fcntl.h>
#include <pwd.h>

static char *username = NULL;
static char *homedir = NULL;

static void check_home_file(const char *name) {
	assert(homedir);

	char *fname;
	if (asprintf(&fname, "%s/%s", homedir, name) ==  -1)
		errExit("asprintf");

	if (access(fname, R_OK) == 0) {
		printf("UGLY: I can access files in %s directory. ", fname);
		printf("Use \"firejail --blacklist=%s\" to block it.\n", fname);
	}
	else
		printf("GOOD: I cannot access files in %s directory.\n", fname);

	free(fname);
}

void files_test(void) {
	struct passwd *pw = getpwuid(getuid());
	if (!pw) {
		fprintf(stderr, "Error: cannot retrieve user account information\n");
		return;
	}

	username = strdup(pw->pw_name);
	if (!username)
		errExit("strdup");
	homedir = strdup(pw->pw_dir);
	if (!homedir)
		errExit("strdup");

	// check access to .ssh directory
	check_home_file(".ssh");

	// check access to .gnupg directory
	check_home_file(".gnupg");

	// check access to Firefox browser directory
	check_home_file(".mozilla");

	// check access to Chromium browser directory
	check_home_file(".config/chromium");

	// check access to Debian Icedove directory
	check_home_file(".icedove");

	// check access to Thunderbird directory
	check_home_file(".thunderbird");
}
