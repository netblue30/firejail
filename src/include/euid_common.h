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

#ifndef EUID_COMMON_H
#define EUID_COMMON_H
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <assert.h>

#define EUID_ASSERT() { \
	if (getuid() != 0) \
		assert(geteuid() != 0); \
}

extern uid_t firejail_uid;
extern uid_t firejail_gid;

static inline void EUID_ROOT(void) {
	int rv = seteuid(0);
	rv |= setegid(0);
	(void) rv;
}

static inline void EUID_USER(void) {
	if (seteuid(firejail_uid) == -1)
		errExit("seteuid");
	if (setegid(firejail_gid) == -1)
		errExit("setegid");
}

static inline void EUID_PRINT(void) {
	printf("debug: uid %d, euid %d\n", getuid(), geteuid());
	printf("debug: gid %d, egid %d\n", getgid(), getegid());
}

static inline void EUID_INIT(void) {
	firejail_uid = getuid();
	firejail_gid = getgid();
}

#endif
