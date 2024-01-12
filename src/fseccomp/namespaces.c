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
#define _GNU_SOURCE
#include "fseccomp.h"
#include "../include/seccomp.h"
#include <sys/syscall.h>

#include <sched.h>
#ifndef CLONE_NEWCGROUP
#define CLONE_NEWCGROUP 0x02000000
#endif
#ifndef CLONE_NEWTIME
#define CLONE_NEWTIME 0x00000080
#endif

// 64-bit architectures
#if INTPTR_MAX == INT64_MAX
#if defined __x86_64__
// i386 syscalls
#define clone_32 120
#define clone3_32 435
#define unshare_32 310
#define setns_32 346
#else
#warning 32 bit namespaces filter not implemented yet for your architecture
#endif
#endif


static int build_ns_mask(const char *list) {
	int mask = 0;

	char *dup = strdup(list);
	if (!dup)
		errExit("strdup");

	char *token = strtok(dup, ",");
	while (token) {
		if (strcmp(token, "cgroup") == 0)
			mask |= CLONE_NEWCGROUP;
		else if (strcmp(token, "ipc") == 0)
			mask |= CLONE_NEWIPC;
		else if (strcmp(token, "net") == 0)
			mask |= CLONE_NEWNET;
		else if (strcmp(token, "mnt") == 0)
			mask |= CLONE_NEWNS;
		else if (strcmp(token, "pid") == 0)
			mask |= CLONE_NEWPID;
		else if (strcmp(token, "time") == 0)
			mask |= CLONE_NEWTIME;
		else if (strcmp(token, "user") == 0)
			mask |= CLONE_NEWUSER;
		else if (strcmp(token, "uts") == 0)
			mask |= CLONE_NEWUTS;
		else {
			fprintf(stderr, "Error fseccomp: %s is not a valid namespace\n", token);
			exit(1);
		}

		token = strtok(NULL, ",");
	}

	free(dup);
	return mask;
}

void deny_ns(const char *fname, const char *list) {
	int mask = build_ns_mask(list);
	// CLONE_NEWTIME means something different for clone
	// create a second mask without it
	int clone_mask = mask & ~CLONE_NEWTIME;

	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	filter_init(fd, true);

	// build filter
	struct sock_filter filter[] = {
#ifdef SYS_clone
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_clone, 0, 4),
		// s390 has first and second argument flipped
#if defined __s390__
		EXAMINE_ARGUMENT(1),
#else
		EXAMINE_ARGUMENT(0),
#endif
		BPF_JUMP(BPF_JMP+BPF_JSET+BPF_K, clone_mask, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,
#endif
#ifdef SYS_clone3
		// cannot inspect clone3 argument because
		// seccomp does not dereference pointers
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_clone3, 0, 1),
		RETURN_ERRNO(ENOSYS), // hint to use clone instead
#endif
#ifdef SYS_unshare
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_unshare, 0, 4),
		EXAMINE_ARGUMENT(0),
		BPF_JUMP(BPF_JMP+BPF_JSET+BPF_K, mask, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,
#endif
#ifdef SYS_setns
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_setns, 0, 4),
		EXAMINE_ARGUMENT(1),
		// always fail if argument is zero
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, 0, 1, 0),
		BPF_JUMP(BPF_JMP+BPF_JSET+BPF_K, mask, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW
#endif
	};
	if (sizeof(filter))
		write_to_file(fd, filter, sizeof(filter));

	filter_end_blacklist(fd);

	// close file
	close(fd);
}

void deny_ns_32(const char *fname, const char *list) {
	int mask = build_ns_mask(list);
	// CLONE_NEWTIME means something different for clone
	// create a second mask without it
	int clone_mask = mask & ~CLONE_NEWTIME;

	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	filter_init(fd, false);

	// build filter
	struct sock_filter filter[] = {
#ifdef clone_32
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, clone_32, 0, 4),
		EXAMINE_ARGUMENT(0),
		BPF_JUMP(BPF_JMP+BPF_JSET+BPF_K, clone_mask, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,
#endif
#ifdef clone3_32
		// cannot inspect clone3 argument because
		// seccomp does not dereference pointers
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, clone3_32, 0, 1),
		RETURN_ERRNO(ENOSYS), // hint to use clone instead
#endif
#ifdef unshare_32
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, unshare_32, 0, 4),
		EXAMINE_ARGUMENT(0),
		BPF_JUMP(BPF_JMP+BPF_JSET+BPF_K, mask, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,
#endif
#ifdef setns_32
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, setns_32, 0, 4),
		EXAMINE_ARGUMENT(1),
		// always fail if argument is zero
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, 0, 1, 0),
		BPF_JUMP(BPF_JMP+BPF_JSET+BPF_K, mask, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW
#endif
	};

	// For Debian 10 and older, the size of the filter[] array will be 0.
	// The following filter will end up being generated:
	//
	//     FILE: /run/firejail/mnt/seccomp/seccomp.namespaces.32
	//       line OP JT JF K
	//     =================================
	//       0000: 20 00 00 00000004 ld data.architecture
	//       0001: 15 01 00 40000003 jeq ARCH_32 0003 (false 0002)
	//       0002: 06 00 00 7fff0000 ret ALLOW
	//       0003: 20 00 00 00000000 ld data.syscall-number
	//       0004: 06 00 00 7fff0000 ret ALLOW
	//
	if (sizeof(filter))
		write_to_file(fd, filter, sizeof(filter));

	filter_end_blacklist(fd);

	// close file
	close(fd);
}
