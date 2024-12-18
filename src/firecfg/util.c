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

#include "firecfg.h"

// return 1 if the program is found
static int find(const char *program, const char *directory) {
	int retval = 0;

	char *fname;
	if (asprintf(&fname, "/%s/%s", directory, program) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(fname, &s) == 0) {
		if (arg_debug)
			printf("found %s in directory %s\n", program, directory);
		retval = 1;
	}

	free(fname);
	return retval;
}


// return 1 if program is installed on the system
int which(const char *program) {
	// check some well-known paths
	if (find(program, "/bin") || find(program, "/usr/bin") ||
	    find(program, "/sbin") || find(program, "/usr/sbin") ||
	    find(program, "/usr/games"))
		return 1;

	// check environment
	char *path1 = getenv("PATH");
	if (path1) {
		char *path2 = strdup(path1);
		if (!path2)
			errExit("strdup");

		// use path2 to count the entries
		char *ptr = strtok(path2, ":");
		while (ptr) {
			// Ubuntu 18.04 is adding  /snap/bin to PATH;
			// they populate /snap/bin with symbolic links to /usr/bin/ programs;
			// most symlinked programs are not installed by default.
			// Removing /snap/bin from our search
			if (strcmp(ptr, "/snap/bin") != 0) {
				if (find(program, ptr)) {
					free(path2);
					return 1;
				}
			}
			ptr = strtok(NULL, ":");
		}
		free(path2);
	}

	return 0;
}

// return 1 if the file is a link
int is_link(const char *fname) {
	assert(fname);
	if (*fname == '\0')
		return 0;

	struct stat s;
	if (lstat(fname, &s) == 0) {
		if (S_ISLNK(s.st_mode))
			return 1;
	}

	return 0;
}
