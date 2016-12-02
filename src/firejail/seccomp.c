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

#ifdef HAVE_SECCOMP
#include "firejail.h"
#include "../include/seccomp.h"

char *seccomp_check_list(const char *str) {
	assert(str);
	if (strlen(str) == 0) {
		fprintf(stderr, "Error: empty syscall lists are not allowed\n");
		exit(1);
	}
	
	int len = strlen(str) + 1;
	char *rv = malloc(len);
	if (!rv)
		errExit("malloc");
	memset(rv, 0, len);
	
	const char *ptr1 = str;
	char *ptr2 = rv;
	while (*ptr1 != '\0') {
		if (isalnum(*ptr1) || *ptr1 == '_' || *ptr1 == ',' || *ptr1 == ':')
			*ptr2++ = *ptr1++;
		else {
			fprintf(stderr, "Error: invalid syscall list\n");
			exit(1);
		}
	}
						
	return rv;
}


int seccomp_load(const char *fname) {
	assert(fname);
	
	// open filter file
	int fd = open(fname, O_RDONLY);
	if (fd == -1)
		goto errexit;

	// calculate the number of entries
	int size = lseek(fd, 0, SEEK_END);
	if (size == -1)
		goto errexit;
	if (lseek(fd, 0 , SEEK_SET) == -1)
		goto errexit;
	unsigned short entries = (unsigned short) size / (unsigned short) sizeof(struct sock_filter);
	if (arg_debug)
		printf("reading %d seccomp entries from %s\n", entries, fname);

	// read filter
	struct sock_filter *filter = malloc(size);
	if (filter == NULL)
		goto errexit;
	memset(filter, 0, size);
	int rd = 0;
	while (rd < size) {
		int rv = read(fd, (unsigned char *) filter + rd, size - rd);
		if (rv == -1)
			goto errexit;
		rd += rv;
	}
	
	// close file
	close(fd);

	// install filter
	struct sock_fprog prog = {
		.len = entries,
		.filter = filter,
	};
	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) || prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
		fprintf(stderr, "Warning: seccomp disabled, it requires a Linux kernel version 3.5 or newer.\n");
		return 1;
	}
	
	return 0;
	
errexit:
	fprintf(stderr, "Error: cannot read %s\n", fname);
	exit(1);
}

// i386 filter installed on amd64 architectures
void seccomp_filter_32(void) {
	if (seccomp_load(RUN_SECCOMP_I386) == 0) {
		if (arg_debug)
			printf("Dual i386/amd64 seccomp filter configured\n");
	}
}

// amd64 filter installed on i386 architectures
void seccomp_filter_64(void) {
	if (seccomp_load(RUN_SECCOMP_AMD64) == 0) {
		if (arg_debug)
			printf("Dual i386/amd64 seccomp filter configured\n");
	}
}

// drop filter for seccomp option
int seccomp_filter_drop(int enforce_seccomp) {
	// default seccomp
	if (cfg.seccomp_list_drop == NULL && cfg.seccomp_list == NULL) {
#if defined(__x86_64__)
		seccomp_filter_32();
#endif
#if defined(__i386__)
		seccomp_filter_64();
#endif
	}
	// default seccomp filter with additional drop list
	else if (cfg.seccomp_list && cfg.seccomp_list_drop == NULL) {
#if defined(__x86_64__)
		seccomp_filter_32();
#endif
#if defined(__i386__)
		seccomp_filter_64();
#endif
		if (arg_debug)
			printf("Build default+drop seccomp filter\n");
		
		// build the seccomp filter as a regular user
		int rv;
		if (arg_allow_debuggers)
			rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 6,
				PATH_FSECCOMP, "default", "drop", RUN_SECCOMP_CFG, cfg.seccomp_list, "allow-debuggers");
		else
			rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 5,
				PATH_FSECCOMP, "default", "drop", RUN_SECCOMP_CFG, cfg.seccomp_list);
		if (rv)
			exit(rv);
	}
	
	// drop list without defaults - secondary filters are not installed
	else if (cfg.seccomp_list == NULL && cfg.seccomp_list_drop) {
		if (arg_debug)
			printf("Build drop seccomp filter\n");

		// build the seccomp filter as a regular user
		int rv;
		if (arg_allow_debuggers)
			rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 5,
				PATH_FSECCOMP, "drop", RUN_SECCOMP_CFG, cfg.seccomp_list_drop,  "allow-debuggers");
		else
			rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 4,
				PATH_FSECCOMP, "drop", RUN_SECCOMP_CFG, cfg.seccomp_list_drop);

		if (rv)
			exit(rv);
	}
	else {
		assert(0);
	}
	
	// load the filter
	if (seccomp_load(RUN_SECCOMP_CFG) == 0) {
		if (arg_debug)
			printf("seccomp filter configured\n");
	}
	else if (enforce_seccomp) {
		fprintf(stderr, "Error: a seccomp-enabled Linux kernel is required, exiting...\n");
		exit(1);
	}
	
	if (arg_debug && access(PATH_FSECCOMP, X_OK) == 0)
		sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 3,
			PATH_FSECCOMP, "print", RUN_SECCOMP_CFG);

	return seccomp_load(RUN_SECCOMP_CFG);
}

// keep filter for seccomp option
int seccomp_filter_keep(void) {
	if (arg_debug)
		printf("Build drop seccomp filter\n");
	
	// build the seccomp filter as a regular user
	sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 4,
		PATH_FSECCOMP, "keep", RUN_SECCOMP_CFG, cfg.seccomp_list_keep);
	if (arg_debug)
		printf("seccomp filter configured\n");

		
	return seccomp_load(RUN_SECCOMP_CFG);
}

void seccomp_print_filter(pid_t pid) {
	EUID_ASSERT();

	// if the pid is that of a firejail  process, use the pid of the first child process
	EUID_ROOT();
	char *comm = pid_proc_comm(pid);
	EUID_USER();
	if (comm) {
		if (strcmp(comm, "firejail") == 0) {
			pid_t child;
			if (find_child(pid, &child) == 0) {
				pid = child;
			}
		}
		free(comm);
	}

	// check privileges for non-root users
	uid_t uid = getuid();
	if (uid != 0) {
		uid_t sandbox_uid = pid_get_uid(pid);
		if (uid != sandbox_uid) {
			fprintf(stderr, "Error: permission denied.\n");
			exit(1);
		}
	}

	// find the seccomp filter
	EUID_ROOT();
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, RUN_SECCOMP_CFG) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(fname, &s) == -1) {
		printf("Cannot access seccomp filter.\n");
		exit(1);
	}

	// read and print the filter - run this as root, the user doesn't have access
	sbox_run(SBOX_ROOT | SBOX_SECCOMP, 3, PATH_FSECCOMP, "print", fname);
	free(fname);

	exit(0);
}

#endif // HAVE_SECCOMP

