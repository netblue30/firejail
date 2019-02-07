/*
 * Copyright (C) 2014-2019 Firejail Authors
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
#include "fseccomp.h"
#include "../include/seccomp.h"
#include <sys/syscall.h>

void write_to_file(int fd, const void *data, int size) {
	assert(data);
	assert(size);

	int written = 0;
	while (written < size) {
		int rv = write(fd, (unsigned char *) data + written, size - written);
		if (rv == -1) {
			fprintf(stderr, "Error fseccomp: cannot write seccomp file\n");
			exit(1);
		}
		written += rv;
	}
}

void filter_init(int fd) {
	struct sock_filter filter[] = {
		VALIDATE_ARCHITECTURE,
#if defined(__x86_64__)
		EXAMINE_SYSCALL,
		HANDLE_X32
#else
		EXAMINE_SYSCALL
#endif
	};

#if 0
{
	int i;
	unsigned char *ptr = (unsigned char *) &filter[0];
	for (i = 0; i < sizeof(filter); i++, ptr++)
		printf("%x, ", (*ptr) & 0xff);
	printf("\n");
}
#endif

	write_to_file(fd, filter, sizeof(filter));
}

void filter_add_whitelist(int fd, int syscall, int arg, void *ptrarg) {
	(void) arg;
	(void) ptrarg;

	struct sock_filter filter[] = {
		WHITELIST(syscall)
	};
	write_to_file(fd, filter, sizeof(filter));
}

void filter_add_blacklist(int fd, int syscall, int arg, void *ptrarg) {
	(void) arg;
	(void) ptrarg;

	struct sock_filter filter[] = {
		BLACKLIST(syscall)
	};
	write_to_file(fd, filter, sizeof(filter));
}

void filter_add_errno(int fd, int syscall, int arg, void *ptrarg) {
	(void) ptrarg;
	struct sock_filter filter[] = {
		BLACKLIST_ERRNO(syscall, arg)
	};
	write_to_file(fd, filter, sizeof(filter));
}

void filter_end_blacklist(int fd) {
	struct sock_filter filter[] = {
		RETURN_ALLOW
	};
	write_to_file(fd, filter, sizeof(filter));
}

void filter_end_whitelist(int fd) {
	struct sock_filter filter[] = {
		KILL_PROCESS
	};
	write_to_file(fd, filter, sizeof(filter));
}
