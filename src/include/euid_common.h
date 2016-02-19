/*
 * Copyright (C) 2014-2016 netblue30 (netblue30@yahoo.com)
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

extern uid_t firejail_uid;
extern uid_t firejail_uid_switch;

static inline void EUID_ROOT(void) {
	if (seteuid(0) == -1)
		fprintf(stderr, "Error: cannot switch euid to root\n");
}

static inline void EUID_USER(void) {
	if (seteuid(firejail_uid) == -1)
		fprintf(stderr, "Error: cannot switch euid to user\n");
}

static inline void EUID_PRINT(void) {
	printf("debug: uid %d, euid %d\n", getuid(), geteuid());
}

static inline void EUID_INIT(void) {
	firejail_uid = getuid();
}

#endif
