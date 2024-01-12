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
#include "../include/seccomp.h"
#include "../include/rundefs.h"
#include <fcntl.h>
#include <linux/filter.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <unistd.h>
#include <stdio.h>

__attribute__((constructor))
static void load_seccomp(void) {
	int fd = open(RUN_SECCOMP_POSTEXEC, O_RDONLY);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot open seccomp postexec filter file %s\n", RUN_SECCOMP_POSTEXEC);
		return;
	}

	off_t size = lseek(fd, 0, SEEK_END);
	if (size <= 0) {
		close(fd);
		return;
	}
	unsigned short entries = (unsigned short) size / (unsigned short) sizeof(struct sock_filter);
	struct sock_filter *filter = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
	close(fd);

	if (filter == MAP_FAILED) {
		fprintf(stderr, "Error: cannot map seccomp postexec filter data\n");
		return;
	}

	// install filter
	struct sock_fprog prog = {
		.len = entries,
		.filter = filter,
	};

	prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
#ifdef SECCOMP_FILTER_FLAG_LOG
	syscall(SYS_seccomp, SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_LOG, &prog);
#else
	prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
#endif
	munmap(filter, size);
}
