/*
 * Copyright (C) 2014-2018 Firejail Authors
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
#include "libpostexecseccomp.h"
#include "../include/seccomp.h"
#include <fcntl.h>
#include <linux/filter.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <unistd.h>

__attribute__((constructor))
static void load_seccomp(void) {
	int fd = open(RUN_SECCOMP_POSTEXEC, O_RDONLY);
	if (fd == -1)
		return;

	off_t size = lseek(fd, 0, SEEK_END);
	if (size <= 0) {
		close(fd);
		return;
	}
	unsigned short entries = (unsigned short) size / (unsigned short) sizeof(struct sock_filter);
	struct sock_filter *filter = MAP_FAILED;
	if (size != 0)
		filter = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);

	close(fd);

	if (filter == MAP_FAILED)
		return;

	// install filter
	struct sock_fprog prog = {
		.len = entries,
		.filter = filter,
	};

	prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
	prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
	munmap(filter, size);
}
