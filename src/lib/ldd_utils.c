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

#include "../include/ldd_utils.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

const char * const default_lib_paths[] = {
	"/usr/lib/x86_64-linux-gnu",	// Debian & friends
	"/lib/x86_64-linux-gnu",		// CentOS, Fedora
	"/usr/lib",
	"/lib",
	"/lib64",
	LIBDIR,
	"/usr/local/lib64",
	"/usr/local/lib",
	"/usr/lib/x86_64-linux-gnu/mesa", // libGL.so is sometimes a symlink into this directory
	"/usr/lib/x86_64-linux-gnu/mesa-egl", // libGL.so is sometimes a symlink into this directory
//    "/usr/lib/x86_64-linux-gnu/plasma-discover",
	NULL
};

// return 1 if this is a 64 bit program/library
int is_lib_64(const char *exe) {
	int retval = 0;
	int fd = open(exe, O_RDONLY);
	if (fd < 0)
		return 0;

	unsigned char buf[EI_NIDENT];
	ssize_t len = 0;
	while (len < EI_NIDENT) {
		ssize_t sz = read(fd, buf, EI_NIDENT);
		if (sz <= 0)
			goto doexit;
		len += sz;
	}

	if (buf[EI_CLASS] == ELFCLASS64)
		retval = 1;

doexit:
	close(fd);
	return retval;
}
