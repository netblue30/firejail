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
#include <sys/mman.h>
#include <sys/shm.h>
#include <sys/syscall.h>
#include <sys/types.h>

static void add_default_list(int fd, int allow_debuggers) {
	int r;
	if (!allow_debuggers)
		r = syscall_check_list("@default-nodebuggers", filter_add_blacklist, fd, 0, NULL);
	else
		r = syscall_check_list("@default", filter_add_blacklist, fd, 0, NULL);

	assert(r == 0);
//#ifdef SYS_mknod - emoved in 0.9.29 - it breaks Zotero extension
//		filter_add_blacklist(SYS_mknod, 0);
//#endif
// breaking Firefox nightly when playing youtube videos
// TODO: test again when firefox sandbox is finally released
//#ifdef SYS_get_mempolicy
//	filter_add_blacklist(fd, SYS_get_mempolicy, 0);
//#endif
//#ifdef SYS_quotactl - in use by Firefox
//	filter_add_blacklist(fd, SYS_quotactl, 0);
//#endif
}

// default list
void seccomp_default(const char *fname, int allow_debuggers) {
	assert(fname);

	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	// build filter (no post-exec filter needed because default list is fine for us)
	filter_init(fd);
	add_default_list(fd, allow_debuggers);
	filter_end_blacklist(fd);

	// close file
	close(fd);
}

// drop list
void seccomp_drop(const char *fname1, const char *fname2, char *list, int allow_debuggers) {
	assert(fname1);
	assert(fname2);
	(void) allow_debuggers; // todo: to implemnet it

	// open file for pre-exec filter
	int fd = open(fname1, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname1);
		exit(1);
	}

	// build pre-exec filter: don't blacklist any syscalls in @default-keep
	filter_init(fd);
	char *prelist, *postlist;
	syscalls_in_list(list, "@default-keep", fd, &prelist, &postlist);
	if (prelist)
		if (syscall_check_list(prelist, filter_add_blacklist, fd, 0, NULL)) {
			fprintf(stderr, "Error fseccomp: cannot build seccomp filter\n");
			exit(1);
		}
	filter_end_blacklist(fd);
	// close file
	close(fd);

	if (!postlist)
		return;

	// open file for post-exec filter
	fd = open(fname2, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname2);
		exit(1);
	}

	// build post-exec filter: blacklist remaining syscalls
	filter_init(fd);
	if (syscall_check_list(postlist, filter_add_blacklist, fd, 0, NULL)) {
		fprintf(stderr, "Error fseccomp: cannot build seccomp filter\n");
		exit(1);
	}
	filter_end_blacklist(fd);

	// close file
	close(fd);
}

// default+drop
void seccomp_default_drop(const char *fname1, const char *fname2, char *list, int allow_debuggers) {
	assert(fname1);
	assert(fname2);

	// open file
	int fd = open(fname1, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname1);
		exit(1);
	}

	// build pre-exec filter: blacklist @default, don't blacklist
	// any listed syscalls in @default-keep
	filter_init(fd);
	add_default_list(fd, allow_debuggers);
	char *prelist, *postlist;
	syscalls_in_list(list, "@default-keep", fd, &prelist, &postlist);
	if (prelist)
		if (syscall_check_list(prelist, filter_add_blacklist, fd, 0, NULL)) {
			fprintf(stderr, "Error fseccomp: cannot build seccomp filter\n");
			exit(1);
		}
	filter_end_blacklist(fd);

	// close file
	close(fd);

	if (!postlist)
		return;

	// open file for post-exec filter
	fd = open(fname2, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname2);
		exit(1);
	}

	// build post-exec filter: blacklist remaining syscalls
	filter_init(fd);
	if (syscall_check_list(postlist, filter_add_blacklist, fd, 0, NULL)) {
		fprintf(stderr, "Error fseccomp: cannot build seccomp filter\n");
		exit(1);
	}
	filter_end_blacklist(fd);

	// close file
	close(fd);
}

void seccomp_keep(const char *fname1, const char *fname2, char *list) {
	(void) fname2;

	// open file for pre-exec filter
	int fd = open(fname1, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname1);
		exit(1);
	}

	// build pre-exec filter: whitelist also @default-keep
	filter_init(fd);
	// these syscalls are used by firejail after the seccomp filter is initialized
	int r;
	r = syscall_check_list("@default-keep", filter_add_whitelist, fd, 0, NULL);
	assert(r == 0);

	if (syscall_check_list(list, filter_add_whitelist, fd, 0, NULL)) {
		fprintf(stderr, "Error fseccomp: cannot build seccomp filter\n");
		exit(1);
	}

	filter_end_whitelist(fd);

	// close file
	close(fd);
}

#if defined(__x86_64__) || defined(__aarch64__) || defined(__powerpc64__)
# define filter_syscall SYS_mmap
# undef block_syscall
#elif defined(__i386__)
# define filter_syscall SYS_mmap2
# define block_syscall SYS_mmap
#elif defined(__arm__)
# define filter_syscall SYS_mmap2
# undef block_syscall
#else
# warning "Platform does not support seccomp memory-deny-write-execute filter yet"
# undef filter_syscall
# undef block_syscall
#endif

void memory_deny_write_execute(const char *fname) {
	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	filter_init(fd);

	// build filter
	static const struct sock_filter filter[] = {
#ifdef block_syscall
		// block old multiplexing mmap syscall for i386
		BLACKLIST(block_syscall),
#endif
#ifdef filter_syscall
		// block mmap(,,x|PROT_WRITE|PROT_EXEC) so W&X memory can't be created
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, filter_syscall, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, PROT_WRITE|PROT_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, PROT_WRITE|PROT_EXEC, 0, 1),
		KILL_PROCESS,
		RETURN_ALLOW,
#endif

		// block mprotect(,,PROT_EXEC) so writable memory can't be turned into executable
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_mprotect, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, PROT_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, PROT_EXEC, 0, 1),
		KILL_PROCESS,
		RETURN_ALLOW,

		// same for pkey_mprotect(,,PROT_EXEC), where available
#ifdef SYS_pkey_mprotect
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_pkey_mprotect, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, PROT_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, PROT_EXEC, 0, 1),
		KILL_PROCESS,
		RETURN_ALLOW,
#endif

// shmat is not implemented as a syscall on some platforms (i386, powerpc64, powerpc64le)
#ifdef SYS_shmat
		// block shmat(,,x|SHM_EXEC) so W&X shared memory can't be created
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_shmat, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, SHM_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SHM_EXEC, 0, 1),
		KILL_PROCESS,
		RETURN_ALLOW
#endif
	};
	write_to_file(fd, filter, sizeof(filter));

	filter_end_blacklist(fd);

	// close file
	close(fd);
}
