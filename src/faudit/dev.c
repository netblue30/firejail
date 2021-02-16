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
#include <dirent.h>

void dev_test(void) {
	DIR *dir;
	if (!(dir = opendir("/dev"))) {
		fprintf(stderr, "Error: cannot open /dev directory\n");
		return;
	}

	struct dirent *entry;
	printf("INFO: files visible in /dev directory: ");
	int cnt = 0;
	while ((entry = readdir(dir)) != NULL) {
		if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
			continue;

		printf("%s, ", entry->d_name);
		cnt++;
	}
	printf("\n");

	if (cnt > 20)
		printf("MAYBE: /dev directory seems to be fully populated. Use --private-dev or --whitelist to restrict the access.\n");
	else
		printf("GOOD: Access to /dev directory is restricted.\n");
	closedir(dir);
}
