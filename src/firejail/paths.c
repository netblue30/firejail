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
#include <sys/stat.h>

static char **paths = 0;
static unsigned int path_cnt = 0;
static unsigned int longest_path_elt = 0;

static char *elt = NULL; // moved from inside init_paths in order to get rid of scan-build warning
static void init_paths(void) {
	const char *env_path = env_get("PATH");
	char *p;
	if (!env_path) {
		env_path = "/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin";
		env_store_name_val("PATH", env_path, SETENV);
	}
	char *path = strdup(env_path);
	if (!path)
		errExit("strdup");

	// size the paths array
	for (p = path; *p; p++)
		if (*p == ':')
			path_cnt++;
	path_cnt += 2; // one because we were counting fenceposts, one for the NULL at the end

	paths = calloc(path_cnt, sizeof(char *));
	if (!paths)
		errExit("calloc");
	memset(paths, 0, path_cnt * sizeof(char *)); // get rid of false positive error from GCC static analyzer

	// lots of distros set /bin as a symlink to /usr/bin;
	// we remove /bin form the path to speed up path-based operations such as blacklist
	int bin_symlink = 0;
	p = realpath("/bin", NULL);
	if (p) {
		if (strcmp(p, "/usr/bin") == 0)
			bin_symlink = 1;
	}
	free(p);

	// fill in 'paths' with pointers to elements of 'path'
	unsigned int i = 0, j;
	unsigned int len;
	while ((elt = strsep(&path, ":")) != NULL) {
		// skip any entry that is not absolute
		if (elt[0] != '/')
			goto skip;

		// strip trailing slashes (this also prevents '/' from being a path entry).
		len = strlen(elt);
		while (len > 0 && elt[len-1] == '/')
			elt[--len] = '\0';
		if (len == 0)
			goto skip;

		//deal with /bin - /usr/bin symlink
		if (bin_symlink > 0) {
			if (strcmp(elt, "/bin") == 0 || strcmp(elt, "/usr/bin") == 0)
				bin_symlink++;
			if (bin_symlink == 3) {
				bin_symlink = 0;
				if (arg_debug)
					printf("...skip path %s\n", elt);
				goto skip;
			}
		}

		// filter out duplicate entries
		for (j = 0; j < i; j++)
			if (strcmp(elt, paths[j]) == 0)
				goto skip;

		if (arg_debug)
			printf("Add path entry %s\n", elt);
		paths[i++] = elt;
		if (len > longest_path_elt)
			longest_path_elt = len;

skip:;
	}
	assert(paths[i] == NULL);
	path_cnt = i;
	if (arg_debug)
		printf("Number of path entries: %u\n", path_cnt);

	// path_cnt may be too big now, if entries were skipped above
	path_cnt = i+1;
}


char **build_paths(void) {
	if (!paths)
		init_paths();
	assert(paths);
	return paths;
}

// Note: the NULL element at the end of 'paths' is included in this count.
unsigned int count_paths(void) {
	if (!path_cnt)
		init_paths();
	assert(path_cnt);
	return path_cnt;
}

// Return 1 if PROGRAM exists in $PATH and is runnable by the
// invoking user (not root).
// In other words, tests "will execvp(PROGRAM, ...) succeed?"
int program_in_path(const char *program) {
	assert(program && *program);
	assert(strchr(program, '/') == 0);
	assert(strcmp(program, ".") != 0);
	assert(strcmp(program, "..") != 0);

	if (!paths)
		init_paths();
	assert(paths);

	size_t proglen = strlen(program);
	char *scratch = malloc(longest_path_elt + proglen + 2);
	if (!scratch)
		errExit("malloc");

	int found = 0;
	size_t dlen;
	char **p;
	for (p = paths; *p; p++) {
		char *dir = *p;
		dlen = strlen(dir);

		// init_paths should ensure that this is true; as long
		// as it is true, 'scratch' has enough space for "$p/$program".
		assert(dlen <= longest_path_elt);

		memcpy(scratch, dir, dlen);
		scratch[dlen++] = '/';

		// copy proglen+1 bytes to copy the nul terminator at
		// the end of 'program'.
		memcpy(scratch + dlen, program, proglen+1);

		if (access(scratch, X_OK) == 0) {
			// must also verify that this is a regular file
			// ('x' permission means something different for directories).
			// exec follows symlinks, so use stat, not lstat.
			struct stat st;
			if (stat_as_user(scratch, &st)) {
				perror(scratch);
				exit(1);
			}
			if (S_ISREG(st.st_mode)) {
				found = 1;
				break;
			}
		}
	}

	free(scratch);
	return found;
}
