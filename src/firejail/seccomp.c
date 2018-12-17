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

#ifdef HAVE_SECCOMP
#include "firejail.h"
#include "../include/seccomp.h"
#include <sys/mman.h>

typedef struct filter_list {
	struct filter_list *next;
	struct sock_fprog prog;
	const char *fname;
} FilterList;

static FilterList *filter_list_head = NULL;
static int err_printed = 0;

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
		if (isalnum(*ptr1) || *ptr1 == '_' || *ptr1 == ',' || *ptr1 == ':' || *ptr1 == '@' || *ptr1 == '-')
			*ptr2++ = *ptr1++;
		else {
			fprintf(stderr, "Error: invalid syscall list\n");
			exit(1);
		}
	}

	return rv;
}

// install seccomp filters
int seccomp_install_filters(void) {
	int r = 0;
	FilterList *fl = filter_list_head;
	if (fl) {
		prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);

		for (; fl; fl = fl->next) {
			assert(fl->fname);
			if (arg_debug)
				printf("Installing %s seccomp filter\n", fl->fname);

			if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &fl->prog)) {

				if (!err_printed)
					fwarning("seccomp disabled, it requires a Linux kernel version 3.5 or newer.\n");
				err_printed = 1;
				r = 1;
			}
		}
	}
	return r;
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
	unsigned short entries = (unsigned short) size / (unsigned short) sizeof(struct sock_filter);
	if (arg_debug)
		printf("configuring %d seccomp entries in %s\n", entries, fname);

	// read filter
	struct sock_filter *filter = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
	if (filter == MAP_FAILED)
		goto errexit;

	// close file
	close(fd);

	FilterList *fl = malloc(sizeof(FilterList));
	if (!fl) {
		fprintf(stderr, "Error: cannot allocate memory\n");
		exit(1);
	}
	fl->next = filter_list_head;
	fl->prog.len = entries;
	fl->prog.filter = filter;
	fl->fname = strdup(fname);
	if (fl->fname == NULL)
		errExit("strdup");
	filter_list_head = fl;

	if (arg_debug && access(PATH_FSEC_PRINT, X_OK) == 0) {
		sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2,
			PATH_FSEC_PRINT, fname);
	}

	return 0;
errexit:
	fprintf(stderr, "Error: cannot read %s\n", fname);
	exit(1);
}

// 32 bit arch filter installed on 64 bit architectures
#if defined(__x86_64__)
#if defined(__LP64__)
static void seccomp_filter_32(void) {
	if (seccomp_load(RUN_SECCOMP_32) == 0) {
		if (arg_debug)
			printf("Dual 32/64 bit seccomp filter configured\n");
	}
}
#endif
#endif

static void seccomp_filter_block_secondary(void) {
	if (seccomp_load(RUN_SECCOMP_BLOCK_SECONDARY) == 0) {
		if (arg_debug)
			printf("Secondary arch blocking seccomp filter configured\n");
	}
}

// drop filter for seccomp option
int seccomp_filter_drop(void) {
	// if we have multiple seccomp commands, only one of them is executed
	// in the following order:
	//	- seccomp.drop list
	//	- seccomp list
	//	- seccomp
	if (cfg.seccomp_list_drop == NULL) {
		// default seccomp
		if (cfg.seccomp_list == NULL) {
			if (arg_seccomp_block_secondary)
				seccomp_filter_block_secondary();
			else {
#if defined(__x86_64__)
#if defined(__LP64__)
				seccomp_filter_32();
#endif
#endif
			}
		}
		// default seccomp filter with additional drop list
		else { // cfg.seccomp_list != NULL
			if (arg_seccomp_block_secondary)
				seccomp_filter_block_secondary();
			else {
#if defined(__x86_64__)
#if defined(__LP64__)
				seccomp_filter_32();
#endif
#endif
			}
			if (arg_debug)
				printf("Build default+drop seccomp filter\n");

			// build the seccomp filter as a regular user
			int rv;
			if (arg_allow_debuggers)
				rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 7,
					      PATH_FSECCOMP, "default", "drop", RUN_SECCOMP_CFG, RUN_SECCOMP_POSTEXEC, cfg.seccomp_list, "allow-debuggers");
			else
				rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 6,
					      PATH_FSECCOMP, "default", "drop", RUN_SECCOMP_CFG, RUN_SECCOMP_POSTEXEC, cfg.seccomp_list);
			if (rv)
				exit(rv);

			// optimize the new filter
			rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2, PATH_FSEC_OPTIMIZE, RUN_SECCOMP_CFG);
			if (rv)
				exit(rv);
		}
	}

	// drop list without defaults - secondary filters are not installed
	// except when secondary architectures are explicitly blocked
	else { // cfg.seccomp_list_drop != NULL
		if (arg_seccomp_block_secondary)
			seccomp_filter_block_secondary();
		if (arg_debug)
			printf("Build drop seccomp filter\n");

		// build the seccomp filter as a regular user
		int rv;
		if (arg_allow_debuggers)
			rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 6,
				      PATH_FSECCOMP, "drop", RUN_SECCOMP_CFG, RUN_SECCOMP_POSTEXEC, cfg.seccomp_list_drop,  "allow-debuggers");
		else
			rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 5,
				PATH_FSECCOMP, "drop", RUN_SECCOMP_CFG, RUN_SECCOMP_POSTEXEC, cfg.seccomp_list_drop);

		if (rv)
			exit(rv);

		// optimize the drop filter
		rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2, PATH_FSEC_OPTIMIZE, RUN_SECCOMP_CFG);
		if (rv)
			exit(rv);
	}

	// load the filter
	if (seccomp_load(RUN_SECCOMP_CFG) == 0) {
		if (arg_debug)
			printf("seccomp filter configured\n");
	}

	if (arg_debug && access(PATH_FSEC_PRINT, X_OK) == 0) {
		struct stat st;
		if (stat(RUN_SECCOMP_POSTEXEC, &st) != -1 && st.st_size != 0) {
			printf("configuring postexec seccomp filter in %s\n", RUN_SECCOMP_POSTEXEC);
			sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2,
				  PATH_FSEC_PRINT, RUN_SECCOMP_POSTEXEC);
		}
	}

	return 0;
}

// keep filter for seccomp option
int seccomp_filter_keep(void) {
	// secondary filters are not installed except when secondary
	// architectures are explicitly blocked
	if (arg_seccomp_block_secondary)
		seccomp_filter_block_secondary();

	if (arg_debug)
		printf("Build keep seccomp filter\n");

	// build the seccomp filter as a regular user
	int rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 5,
		 PATH_FSECCOMP, "keep", RUN_SECCOMP_CFG, RUN_SECCOMP_POSTEXEC, cfg.seccomp_list_keep);

	if (rv) {
		fprintf(stderr, "Error: cannot configure seccomp filter\n");
		exit(rv);
	}

	if (arg_debug)
		printf("seccomp filter configured\n");

	// load the filter
	if (seccomp_load(RUN_SECCOMP_CFG) == 0) {
		if (arg_debug)
			printf("seccomp filter configured\n");
	}

	if (arg_debug && access(PATH_FSEC_PRINT, X_OK) == 0) {
		struct stat st;
		if (stat(RUN_SECCOMP_POSTEXEC, &st) != -1 && st.st_size != 0) {
			printf("configuring postexec seccomp filter in %s\n", RUN_SECCOMP_POSTEXEC);
			sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2,
				  PATH_FSEC_PRINT, RUN_SECCOMP_POSTEXEC);
		}
	}

	return 0;
}

void seccomp_print_filter(pid_t pid) {
	EUID_ASSERT();

	// in case the pid is that of a firejail process, use the pid of the first child process
	pid = switch_to_child(pid);

	// now check if the pid belongs to a firejail sandbox
	if (invalid_sandbox(pid)) {
		fprintf(stderr, "Error: no valid sandbox\n");
		exit(1);
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
	sbox_run(SBOX_ROOT | SBOX_SECCOMP, 2, PATH_FSEC_PRINT, fname);
	free(fname);

	exit(0);
}

#endif // HAVE_SECCOMP
