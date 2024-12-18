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
#include <sys/mman.h>
#include <sys/shm.h>
#include <sys/syscall.h>
#include <sys/types.h>

static void add_default_list(int fd, int allow_debuggers, bool native) {
	int r;
	if (!allow_debuggers)
		r = syscall_check_list("@default-nodebuggers", filter_add_blacklist, fd, 0, NULL, native);
	else
		r = syscall_check_list("@default", filter_add_blacklist, fd, 0, NULL, native);

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
void seccomp_default(const char *fname, int allow_debuggers, bool native) {
	assert(fname);

	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	// build filter (no post-exec filter needed because default list is fine for us)
	filter_init(fd, native);
	add_default_list(fd, allow_debuggers, native);
	filter_end_blacklist(fd);

	// close file
	close(fd);
}

// drop list
void seccomp_drop(const char *fname1, const char *fname2, char *list, int allow_debuggers, bool native) {
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
	filter_init(fd, native);

	// allow exceptions in form of !syscall
	syscall_check_list(list, filter_add_whitelist_for_excluded, fd, 0, NULL, native);

	char *prelist, *postlist;
	syscalls_in_list(list, "@default-keep", fd, &prelist, &postlist, native);
	if (prelist)
		if (syscall_check_list(prelist, filter_add_blacklist, fd, 0, NULL, native)) {
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
	filter_init(fd, native);
	if (syscall_check_list(postlist, filter_add_blacklist, fd, 0, NULL, native)) {
		fprintf(stderr, "Error fseccomp: cannot build seccomp filter\n");
		exit(1);
	}
	filter_end_blacklist(fd);

	// close file
	close(fd);
}

// default+drop
void seccomp_default_drop(const char *fname1, const char *fname2, char *list, int allow_debuggers, bool native) {
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
	filter_init(fd, native);

	// allow exceptions in form of !syscall
	syscall_check_list(list, filter_add_whitelist_for_excluded, fd, 0, NULL, native);

	add_default_list(fd, allow_debuggers, native);
	char *prelist, *postlist;
	syscalls_in_list(list, "@default-keep", fd, &prelist, &postlist, native);
	if (prelist)
		if (syscall_check_list(prelist, filter_add_blacklist, fd, 0, NULL, native)) {
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
	filter_init(fd, native);
	if (syscall_check_list(postlist, filter_add_blacklist, fd, 0, NULL, native)) {
		fprintf(stderr, "Error fseccomp: cannot build seccomp filter\n");
		exit(1);
	}
	filter_end_blacklist(fd);

	// close file
	close(fd);
}

void seccomp_keep(const char *fname1, const char *fname2, char *list, bool native) {
	(void) fname2;

	// open file for pre-exec filter
	int fd = open(fname1, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname1);
		exit(1);
	}

	// build pre-exec filter: whitelist also @default-keep
	filter_init(fd, native);

	// allow exceptions in form of !syscall
	syscall_check_list(list, filter_add_blacklist_for_excluded, fd, 0, NULL, native);

	// these syscalls are used by firejail after the seccomp filter is initialized
	int r;
	r = syscall_check_list("@default-keep", filter_add_whitelist, fd, 0, NULL, native);
	assert(r == 0);

	if (syscall_check_list(list, filter_add_whitelist, fd, 0, NULL, native)) {
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
#if defined(__x86_64__)
// i386 syscalls
# define filter_syscall_32 192
# define block_syscall_32 90
# define mprotect_32 125
# define pkey_mprotect_32 380
# define shmat_32 397
# define memfd_create_32 356
#endif
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
# undef filter_syscall_32
# undef block_syscall_32
# undef mprotect_32
# undef pkey_mprotect_32
# undef shmat_32
# undef memfd_create_32
#endif

void memory_deny_write_execute(const char *fname) {
	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	filter_init(fd, true);

	// build filter
	struct sock_filter filter[] = {
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
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,
#endif

		// block mprotect(,,PROT_EXEC) so writable memory can't be turned into executable
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_mprotect, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, PROT_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, PROT_EXEC, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,

		// same for pkey_mprotect(,,PROT_EXEC), where available
#ifdef SYS_pkey_mprotect
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_pkey_mprotect, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, PROT_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, PROT_EXEC, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,
#endif

// shmat is not implemented as a syscall on some platforms (i386, powerpc64, powerpc64le)
#ifdef SYS_shmat
		// block shmat(,,x|SHM_EXEC) so W&X shared memory can't be created
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_shmat, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, SHM_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SHM_EXEC, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,
#endif
#ifdef SYS_memfd_create
		// block memfd_create as it can be used to create
		// arbitrary memory contents which can be later mapped
		// as executable
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_memfd_create, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW
#endif
	};
	write_to_file(fd, filter, sizeof(filter));

	filter_end_blacklist(fd);

	// close file
	close(fd);
}

void memory_deny_write_execute_32(const char *fname) {
	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	filter_init(fd, false);

	// build filter
	struct sock_filter filter[] = {
#if defined(__x86_64__)
#ifdef block_syscall_32
		// block old multiplexing mmap syscall for i386
		BLACKLIST(block_syscall_32),
#endif
#ifdef filter_syscall_32
		// block mmap(,,x|PROT_WRITE|PROT_EXEC) so W&X memory can't be created
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, filter_syscall_32, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, PROT_WRITE|PROT_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, PROT_WRITE|PROT_EXEC, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,
#endif
#ifdef mprotect_32
		// block mprotect(,,PROT_EXEC) so writable memory can't be turned into executable
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, mprotect_32, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, PROT_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, PROT_EXEC, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,
#endif
#ifdef pkey_mprotect_32
		// same for pkey_mprotect(,,PROT_EXEC), where available
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, pkey_mprotect_32, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, PROT_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, PROT_EXEC, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,
#endif

#ifdef shmat_32
		// block shmat(,,x|SHM_EXEC) so W&X shared memory can't be created
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, shmat_32, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, SHM_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SHM_EXEC, 0, 1),
		KILL_OR_RETURN_ERRNO,
		RETURN_ALLOW,
#endif
#ifdef memfd_create_32
		// block memfd_create as it can be used to create
		// arbitrary memory contents which can be later mapped
		// as executable
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, memfd_create_32, 0, 1),
		KILL_OR_RETURN_ERRNO,
#endif
#endif
		RETURN_ALLOW
	};
	write_to_file(fd, filter, sizeof(filter));

	filter_end_blacklist(fd);

	// close file
	close(fd);
}
