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
#include <sys/socket.h>
#include <dirent.h>


void x11_test(void) {
	// check regular display 0 sockets
	if (check_unix("/tmp/.X11-unix/X0") == 0)
		printf("MAYBE: X11 socket /tmp/.X11-unix/X0 is available\n");

	if (check_unix("@/tmp/.X11-unix/X0") == 0)
		printf("MAYBE: X11 socket @/tmp/.X11-unix/X0 is available\n");

	// check all unix sockets in /tmp/.X11-unix directory
	DIR *dir;
	if (!(dir = opendir("/tmp/.X11-unix"))) {
		// sleep 2 seconds and try again
		sleep(2);
		if (!(dir = opendir("/tmp/.X11-unix"))) {
			;
		}
	}

	if (dir == NULL)
		printf("GOOD: cannot open /tmp/.X11-unix directory\n");
	else {
		struct dirent *entry;
		while ((entry = readdir(dir)) != NULL) {
			if (strcmp(entry->d_name, "X0") == 0)
				continue;
			if (strcmp(entry->d_name, ".") == 0)
				continue;
			if (strcmp(entry->d_name, "..") == 0)
				continue;
			char *name;
			if (asprintf(&name, "/tmp/.X11-unix/%s", entry->d_name) == -1)
				errExit("asprintf");
			if (check_unix(name) == 0)
				printf("MAYBE: X11 socket %s is available\n", name);
			free(name);
		}
		closedir(dir);
	}
}
