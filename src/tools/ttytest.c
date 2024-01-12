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

#define _XOPEN_SOURCE 600
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>

int main(void) {
	int fdm;
	int rc;

	// initial
	system("ls -l /dev/pts");

	fdm = posix_openpt(O_RDWR);
	if (fdm < 0) {
		perror("posix_openpt");
		return 1;
	}

	rc = grantpt(fdm);
	if (rc != 0) {
		perror("grantpt");
		return 1;
	}

	rc = unlockpt(fdm);
	if (rc != 0) {
		perror("unlockpt");
		return 1;
	}

	// final
	system("ls -l /dev/pts");

	return 0;
}
