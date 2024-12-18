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
#include "firejail.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <net/if.h>
#include <stdarg.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include "../include/seccomp.h"
#include "../include/gcov_wrapper.h"

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

static int __attribute__((noreturn)) sbox_do_exec_v(unsigned filtermask, char * const arg[]) {
	// build a new, clean environment
	int env_index = 0;
	char *new_environment[256] = { NULL };
	// preserve firejail-specific env vars
	const char *cl = env_get("FIREJAIL_FILE_COPY_LIMIT");
	if (cl) {
		if (asprintf(&new_environment[env_index++], "FIREJAIL_FILE_COPY_LIMIT=%s", cl) == -1)
			errExit("asprintf");
	}
	if (arg_quiet) // --quiet is passed as an environment variable
		new_environment[env_index++] = "FIREJAIL_QUIET=yes";
	if (arg_debug) // --debug is passed as an environment variable
		new_environment[env_index++] = "FIREJAIL_DEBUG=yes";
	if (cfg.seccomp_error_action)
		if (asprintf(&new_environment[env_index++], "FIREJAIL_SECCOMP_ERROR_ACTION=%s", cfg.seccomp_error_action) == -1)
			errExit("asprintf");
	new_environment[env_index++] = "FIREJAIL_PLUGIN="; // always set

	if (filtermask & SBOX_STDIN_FROM_FILE) {
		int fd;
		if((fd = open(SBOX_STDIN_FILE, O_RDONLY)) == -1) {
			fprintf(stderr,"Error: cannot open %s\n", SBOX_STDIN_FILE);
			exit(1);
		}
		if (dup2(fd, STDIN_FILENO) == -1)
			errExit("dup2");
		close(fd);
	}
	else if ((filtermask & SBOX_ALLOW_STDIN) == 0) {
		int fd = open("/dev/null",O_RDWR, 0);
		if (fd != -1) {
			if (dup2(fd, STDIN_FILENO) == -1)
				errExit("dup2");
			close(fd);
		}
		else // the user could run the sandbox without /dev/null
			close(STDIN_FILENO);
	}

	// close all other file descriptors
	if ((filtermask & SBOX_KEEP_FDS) == 0)
		close_all(NULL, 0);

	umask(027);

	// apply filters
	if (filtermask & SBOX_CAPS_NONE) {
		caps_drop_all();
	} else {
		uint64_t set = 0;
		if (filtermask & SBOX_CAPS_NETWORK) {
#ifndef HAVE_GCOV // the following filter will prevent GCOV from saving info in .gcda files
			set |= ((uint64_t) 1) << CAP_NET_ADMIN;
			set |= ((uint64_t) 1) << CAP_NET_RAW;
#endif
		}
		if (filtermask & SBOX_CAPS_HIDEPID) {
#ifndef HAVE_GCOV // the following filter will prevent GCOV from saving info in .gcda files
			set |= ((uint64_t) 1) << CAP_SYS_PTRACE;
			set |= ((uint64_t) 1) << CAP_SYS_PACCT;
#endif
		}
		if (filtermask & SBOX_CAPS_NET_SERVICE) {
#ifndef HAVE_GCOV // the following filter will prevent GCOV from saving info in .gcda files
			set |= ((uint64_t) 1) << CAP_NET_BIND_SERVICE;
			set |= ((uint64_t) 1) << CAP_NET_BROADCAST;
#endif
		}
		if (set != 0) { // some SBOX_CAPS_ flag was specified, drop all other capabilities
#ifndef HAVE_GCOV // the following filter will prevent GCOV from saving info in .gcda files
			caps_set(set);
#endif
		}
	}

	if (filtermask & SBOX_SECCOMP) {
		struct sock_filter filter[] = {
			VALIDATE_ARCHITECTURE,
			EXAMINE_SYSCALL,

#if defined(__x86_64__)
#define X32_SYSCALL_BIT 0x40000000
			// handle X32 ABI
			BPF_JUMP(BPF_JMP + BPF_JGE + BPF_K, X32_SYSCALL_BIT, 1, 0),
			BPF_JUMP(BPF_JMP + BPF_JGE + BPF_K, 0, 1, 0),
			KILL_OR_RETURN_ERRNO,
#endif

		// syscall list
#ifdef SYS_mount
			BLACKLIST(SYS_mount), // mount/unmount filesystems
#endif
#ifdef SYS_umount
			BLACKLIST(SYS_umount),
#endif
#ifdef SYS_umount2
			BLACKLIST(SYS_umount2),
#endif
#ifdef SYS_fsopen
			BLACKLIST(SYS_fsopen), // mount syscalls introduced 2019
#endif
#ifdef SYS_fsconfig
			BLACKLIST(SYS_fsconfig),
#endif
#ifdef SYS_fsmount
			BLACKLIST(SYS_fsmount),
#endif
#ifdef SYS_move_mount
			BLACKLIST(SYS_move_mount),
#endif
#ifdef SYS_fspick
			BLACKLIST(SYS_fspick),
#endif
#ifdef SYS_open_tree
			BLACKLIST(SYS_open_tree),
#endif
#ifdef SYS_ptrace
			BLACKLIST(SYS_ptrace), // trace processes
#endif
#ifdef SYS_process_vm_readv
			BLACKLIST(SYS_process_vm_readv),
#endif
#ifdef SYS_process_vm_writev
			BLACKLIST(SYS_process_vm_writev),
#endif
#ifdef SYS_kexec_file_load
			BLACKLIST(SYS_kexec_file_load), // loading a different kernel
#endif
#ifdef SYS_kexec_load
			BLACKLIST(SYS_kexec_load),
#endif
#ifdef SYS_name_to_handle_at
			BLACKLIST(SYS_name_to_handle_at),
#endif
#ifdef SYS_open_by_handle_at
			BLACKLIST(SYS_open_by_handle_at), // open by handle
#endif
#ifdef SYS_init_module
			BLACKLIST(SYS_init_module), // kernel module handling
#endif
#ifdef SYS_finit_module // introduced in 2013
			BLACKLIST(SYS_finit_module),
#endif
#ifdef SYS_create_module
			BLACKLIST(SYS_create_module),
#endif
#ifdef SYS_delete_module
			BLACKLIST(SYS_delete_module),
#endif
#ifdef SYS_iopl
			BLACKLIST(SYS_iopl), // io permissions
#endif
#ifdef SYS_ioperm
			BLACKLIST(SYS_ioperm),
#endif
#ifdef SYS_ioprio_set
			BLACKLIST(SYS_ioprio_set),
#endif
#ifdef SYS_ni_syscall // new io permissions call on arm devices
			BLACKLIST(SYS_ni_syscall),
#endif
#ifdef SYS_swapon
			BLACKLIST(SYS_swapon), // swap on/off
#endif
#ifdef SYS_swapoff
			BLACKLIST(SYS_swapoff),
#endif
#ifdef SYS_syslog
			BLACKLIST(SYS_syslog), // kernel printk control
#endif
#ifdef SYS_personality
			BLACKLIST(SYS_personality), // execution domain
#endif
			RETURN_ALLOW
		};

		struct sock_fprog prog = {
			.len = (unsigned short)(sizeof(filter) / sizeof(filter[0])),
			.filter = filter,
		};

		if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
			perror("prctl(NO_NEW_PRIVS)");
		}
		if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog)) {
			perror("prctl(PR_SET_SECCOMP)");
		}
	}

	if (filtermask & SBOX_USER)
		drop_privs(1);
	else if (filtermask & SBOX_ROOT) {
		// https://seclists.org/oss-sec/2021/q4/43
		struct rlimit tozero = { .rlim_cur = 0, .rlim_max = 0 };
		if (setrlimit(RLIMIT_CORE, &tozero))
			errExit("setrlimit");

		// elevate privileges in order to get grsecurity working
		if (setreuid(0, 0))
			errExit("setreuid");
		if (setregid(0, 0))
			errExit("setregid");
	}
	else assert(0);

	if (arg[0]) { // get rid of scan-build warning
		int fd = open(arg[0], O_PATH | O_CLOEXEC);
		if (fd == -1) {
			if (errno == ENOENT) {
				fprintf(stderr, "Error: %s does not exist\n", arg[0]);
				exit(1);
			} else {
				errExit("open");
			}
		}
		struct stat s;
		if (fstat(fd, &s) == -1)
			errExit("fstat");
		if (s.st_uid != 0 && s.st_gid != 0) {
			fprintf(stderr, "Error: %s is not owned by root, refusing to execute\n", arg[0]);
			exit(1);
		}
		if (s.st_mode & 00002) {
			fprintf(stderr, "Error: %s is world writable, refusing to execute\n", arg[0]);
			exit(1);
		}
		__gcov_dump();
		fexecve(fd, arg, new_environment);
	} else {
		assert(0);
	}
	perror("fexecve");
	_exit(1);
}

int sbox_run(unsigned filtermask, int num, ...) {
	va_list valist;
	va_start(valist, num);

	// build argument list
	char **arg = calloc(num + 1, sizeof(char *));
	if (!arg)
		errExit("calloc");
	int i;
	for (i = 0; i < num; i++)
		arg[i] = va_arg(valist, char *);
	arg[i] = NULL;
	va_end(valist);

	int status = sbox_run_v(filtermask, arg);

	free(arg);

	return status;
}

int sbox_run_v(unsigned filtermask, char * const arg[]) {
	assert(arg);

	if (arg_debug) {
		printf("sbox run: ");
		int i = 0;
		while (arg[i]) {
			printf("%s ", arg[i]);
			i++;
		}
		printf("\n");
	}

	// KEEP_FDS only makes sense with sbox_exec_v
	assert((filtermask & SBOX_KEEP_FDS) == 0);

	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		EUID_ROOT();
		sbox_do_exec_v(filtermask, arg);
	}

	int status;
	if (waitpid(child, &status, 0) == -1 ) {
		errExit("waitpid");
	}
	if (WIFSIGNALED(status) ||
	   (WIFEXITED(status) && WEXITSTATUS(status) != 0)) {
		fprintf(stderr, "Error: failed to run %s, exiting...\n", arg[0]);
		exit(1);
	}

	return status;
}

void sbox_exec_v(unsigned filtermask, char * const arg[]) {
	EUID_ROOT();

	if (arg_debug) {
		printf("sbox exec: ");
		int i = 0;
		while (arg[i]) {
			printf("%s ", arg[i]);
			i++;
		}
		printf("\n");
	}

	sbox_do_exec_v(filtermask, arg);
}
