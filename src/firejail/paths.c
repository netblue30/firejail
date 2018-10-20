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
#include "firejail.h"
#include <sys/stat.h>

static char **paths = 0;
static unsigned int path_cnt = 0;
static unsigned int longest_path_elt = 0;

static void init_paths(void) {
	char *path = getenv("PATH");
	char *p;
	if (!path) {
		path = "/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin";
		setenv("PATH", path, 1);
	}
	path = strdup(path);
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

	// fill in 'paths' with pointers to elements of 'path'
	char *elt;
	unsigned int i = 0, j;
	unsigned int len;
	while ((elt = strsep(&path, ":")) != 0) {
		// skip any entry that is not absolute
		if (elt[0] != '/')
			goto skip;

		// strip trailing slashes (this also prevents '/' from being a path entry).
		len = strlen(elt);
		while (len > 0 && elt[len-1] == '/')
			elt[--len] = '\0';
		if (len == 0)
			goto skip;

		// filter out duplicate entries
		for (j = 0; j < i; j++)
			if (strcmp(elt, paths[j]) == 0)
				goto skip;

		paths[i++] = elt;
		if (len > longest_path_elt)
			longest_path_elt = len;

		skip:;
	}

	assert(paths[i] == 0);
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
