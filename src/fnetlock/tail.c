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
#include "fnetlock.h"

void tail(const char *logfile) {
	assert(logfile);

	// wait for no more than 5 seconds for the logfile to appear in the filesystem
	int cnt = 5;
	while (access(logfile, R_OK) && cnt > 0)
		cnt--;
	if (cnt == 0)
		exit(1);

	off_t last_size = 0;

	while (1) {
		int fd = open(logfile, O_RDONLY);
		if (fd == -1)
			return;

		off_t size = lseek(fd, 0, SEEK_END);
		if (size < 0) {
			close(fd);
			return;
		}

		char *content = NULL;
		int mmapped = 0;
		if (size && size != last_size) {
			content = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
			close(fd);
			if (content != MAP_FAILED)
				mmapped = 1;
		}

		if (mmapped) {
			printf("%.*s", (int) (size - last_size), content + last_size);
			fflush(0);
			munmap(content, size);
			last_size = size;
		}

		sleep(1);
	}
}
