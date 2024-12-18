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
#include "firemon.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

void x11(pid_t pid, int print_procs) {
	pid_read(pid);

	// print processes
	int i;
	for (i = 0; i < max_pids; i++) {
		if (pids[i].level == 1) {
			if (print_procs || pid == 0)
				pid_print_list(i, arg_wrap);

			char *x11file;
			// todo: use macro from src/firejail/firejail.h for /run/firejail/x11 directory
			if (asprintf(&x11file, "/run/firejail/x11/%d", i) == -1)
				errExit("asprintf");

			FILE *fp = fopen(x11file, "r");
			if (!fp) {
				free(x11file);
				continue;
			}

			int display;
			int rv = fscanf(fp, "%d", &display);
			if (rv == 1)
				printf("  DISPLAY :%d\n", display);
			fclose(fp);
			free(x11file);
		}
	}
	printf("\n");
}
