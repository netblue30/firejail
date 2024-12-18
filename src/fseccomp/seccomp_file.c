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
#include "fseccomp.h"
#include "../include/seccomp.h"
#include <sys/syscall.h>

void write_to_file(int fd, const void *data, size_t size) {
	assert(data);
	assert(size);

	size_t written = 0;
	while (written < size) {
		int rv = write(fd, (unsigned char *) data + written, size - written);
		if (rv == -1) {
			fprintf(stderr, "Error fseccomp: cannot write seccomp file\n");
			exit(1);
		}
		written += rv;
	}
}

void filter_init(int fd, bool native) {
	struct sock_filter filter_native[] = {
		VALIDATE_ARCHITECTURE,
		EXAMINE_SYSCALL,
#if defined(__x86_64__)
		HANDLE_X32
#endif
	};
	struct sock_filter filter_32[] = {
		VALIDATE_ARCHITECTURE_32,
		EXAMINE_SYSCALL
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

	if (native)
		write_to_file(fd, filter_native, sizeof(filter_native));
	else
		write_to_file(fd, filter_32, sizeof(filter_32));
}

static void write_whitelist(int fd, int syscall) {
	struct sock_filter filter[] = {
		WHITELIST(syscall)
	};
	write_to_file(fd, filter, sizeof(filter));
}

static void write_blacklist(int fd, int syscall) {
	struct sock_filter filter[] = {
		BLACKLIST(syscall)
	};
	write_to_file(fd, filter, sizeof(filter));
}

void filter_add_whitelist(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void) arg;
	(void) ptrarg;
	(void) native;

	if (syscall >= 0) {
		write_whitelist(fd, syscall);
	}
}

// handle seccomp list exceptions (seccomp x,y,!z)
void filter_add_whitelist_for_excluded(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void) arg;
	(void) ptrarg;
	(void) native;

	if (syscall < 0) {
		write_whitelist(fd, -syscall);
	}
}

void filter_add_blacklist(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void) arg;
	(void) ptrarg;
	(void) native;

	if (syscall >= 0) {
		write_blacklist(fd, syscall);
	}
}

void filter_add_blacklist_override(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void) arg;
	(void) ptrarg;
	(void) native;

	if (syscall >= 0) {
		int saved_error_action = arg_seccomp_error_action;
		arg_seccomp_error_action = SECCOMP_RET_KILL;
		write_blacklist(fd, syscall);
		arg_seccomp_error_action = saved_error_action;
	}
}

// handle seccomp list exceptions (seccomp x,y,!z)
void filter_add_blacklist_for_excluded(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void) arg;
	(void) ptrarg;
	(void) native;

	if (syscall < 0) {
		write_blacklist(fd, -syscall);
	}
}

void filter_add_errno(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void) ptrarg;
	(void) native;

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
		KILL_OR_RETURN_ERRNO
	};
	write_to_file(fd, filter, sizeof(filter));
}
