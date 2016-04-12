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

static char **paths = NULL;
static int path_cnt = 0;
static char initialized = 0;

static void add_path(const char *path) {
	assert(paths);
	assert(path_cnt);
	
	// filter out duplicates
	int i;
	int empty = 0;
	for (i = 0; i < path_cnt; i++) {
		if (paths[i] && strcmp(path, paths[i]) == 0) {
			return;
		}
		if (!paths[i]) {
			empty = i;
			break;
		}
	}

	paths[empty] = strdup(path);
	if (!paths[empty])
		errExit("strdup");
}

char **build_paths(void) {
	if (initialized) {
		assert(paths);
		return paths;
	}
	initialized = 1;
	
	int cnt = 5;	// 4 default paths + 1 NULL to end the array
	char *path1 = getenv("PATH");
	if (path1) {
		char *path2 = strdup(path1);
		if (!path2)
			errExit("strdup");
		
		// use path2 to count the entries
		char *ptr = strtok(path2, ":");
		while (ptr) {
			cnt++;
			ptr = strtok(NULL, ":");
		}
		free(path2);
		path_cnt = cnt;

		// allocate paths array
		paths = malloc(sizeof(char *) * cnt);
		if (!paths)
			errExit("malloc");
		memset(paths, 0, sizeof(char *) * cnt);

		// add default paths
		add_path("/usr/local/bin");
		add_path("/usr/bin");
		add_path("/bin");
		add_path("/usr/local/sbin");
		add_path("/usr/sbin");
		add_path("/sbin");

		path2 = strdup(path1);
		if (!path2)
			errExit("strdup");
		
		// use path2 to count the entries
		ptr = strtok(path2, ":");
		while (ptr) {
			cnt++;
			add_path(ptr);
			ptr = strtok(NULL, ":");
		}
		free(path2);
	}
	
	return paths;
}
