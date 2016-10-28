/*
 * Copyright (C) 2014-2016 Firejail Authors
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
#include "../include/seccomp.h"

static struct sock_filter filter[] = {
	VALIDATE_ARCHITECTURE,
	EXAMINE_SYSCALL,

#if defined(__x86_64__)
#define X32_SYSCALL_BIT 0x40000000
	// handle X32 ABI
	BPF_JUMP(BPF_JMP+BPF_JGE+BPF_K, X32_SYSCALL_BIT, 1, 0),
	BPF_JUMP(BPF_JMP+BPF_JGE+BPF_K, 0, 1, 0),
	RETURN_ERRNO(EPERM),
#endif

	// syscall list
#ifdef SYS_mount		
	BLACKLIST(SYS_mount),  // mount/unmount filesystems
#endif
#ifdef SYS_umount2		
	BLACKLIST(SYS_umount2),
#endif
#ifdef SYS_ptrace 		
	BLACKLIST(SYS_ptrace), // trace processes
#endif
#ifdef SYS_kexec_file_load		
	BLACKLIST(SYS_kexec_file_load),
#endif
#ifdef SYS_kexec_load		
	BLACKLIST(SYS_kexec_load), // loading a different kernel
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
#ifdef 	SYS_ioperm	
	BLACKLIST(SYS_ioperm),
#endif
#ifdef SYS_iopl		
	BLACKLIST(SYS_iopl), // io permissions
#endif
#ifdef 	SYS_ioprio_set	
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
	RETURN_ALLOW
};

static struct sock_fprog prog = {
	.len = (unsigned short)(sizeof(filter) / sizeof(filter[0])),
	.filter = filter,
};

typedef struct sbox_config {
	char *name;
	char *path;
	unsigned filters;
} SboxConfig;


int sbox_run(unsigned filter, int num, ...) {
	EUID_ROOT();
	char *path = NULL;
	int i;
	va_list valist;
	va_start(valist, num);

	// build argument list
	char *arg[num + 1];
	for (i = 0; i < num; i++)
		arg[i] = va_arg(valist, char*);
	arg[i] = NULL;
	va_end(valist);
	
#if 0
{
int i;
for (i = 0; i <= num; i++)
	printf("#%s# ", arg[i]);
printf("\n");
}	
#endif
	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		// apply filters
		if (filter & SBOX_CAPS)
			caps_drop_all();

		if (filter & SBOX_SECCOMP) {
			if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
				perror("prctl(NO_NEW_PRIVS)");
			}
			if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog)) {
				perror("prctl(PR_SET_SECCOMP)");
			}
		}

		if (filter & SBOX_ROOT) {
			// elevate privileges in order to get grsecurity working
			if (setreuid(0, 0))
				errExit("setreuid");
			if (setregid(0, 0))
				errExit("setregid");
		}
		else if (filter & SBOX_USER)
			drop_privs(1);

		execvp(arg[0], arg);
		perror("execl");
		_exit(1);
	}

	int status;
	if (waitpid(child, &status, 0) == -1 ) {
		errExit("waitpid");
	}
	if (WIFEXITED(status) && status != 0) {
		fprintf(stderr, "Error: cannot run fnet\n");
		exit(1);
	}
	
	return status;
}
