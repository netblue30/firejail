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
#include "../include/seccomp.h"
#include <sys/mman.h>
#include <sys/wait.h>

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
	if (isalnum(*ptr1) || *ptr1 == '_' || *ptr1 == ',' || *ptr1 == ':'
				   || *ptr1 == '@' || *ptr1 == '-' || *ptr1 == '$' || *ptr1 == '!')
			*ptr2++ = *ptr1++;
		else {
			fprintf(stderr, "Error: invalid syscall list entry %s\n", str);
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
			int rv = 0;
#ifdef SECCOMP_FILTER_FLAG_LOG
			if (checkcfg(CFG_SECCOMP_LOG))
				rv = syscall(SYS_seccomp, SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_LOG, &fl->prog);
			else
				rv = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &fl->prog);
#else
			rv = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &fl->prog);
#endif

			if (rv == -1) {
				if (!err_printed)
					fwarning("seccomp disabled, it requires a Linux kernel version 3.5 or newer.\n");
				err_printed = 1;
				r = 1;
			}
		}
	}
	return r;
}

static void seccomp_save_file_list(const char *fname) {
	assert(fname);

	FILE *fp = fopen(RUN_SECCOMP_LIST, "ae");
	if (!fp)
		errExit("fopen");

	fprintf(fp, "%s\n", fname);
	fclose(fp);
	int rv = chown(RUN_SECCOMP_LIST, getuid(), getgid());
	(void) rv;
}

#define MAXBUF 4096
static int load_file_list_flag = 0;
void seccomp_load_file_list(void) {
	FILE *fp = fopen(RUN_SECCOMP_LIST, "re");
	if (!fp)
		return; // no seccomp configuration whatsoever

	load_file_list_flag = 1;
	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		// clean '\n'
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';
		seccomp_load(buf);
	}

	fclose(fp);
	load_file_list_flag = 0;
}


int seccomp_load(const char *fname) {
	assert(fname);

	// open filter file
	int fd = open(fname, O_RDONLY|O_CLOEXEC);
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

	// save the file name in seccomp list
	if (!load_file_list_flag)
		seccomp_save_file_list(fname);

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
int seccomp_filter_drop(bool native) {
	const char *filter, *postexec_filter;

	if (native) {
		filter = RUN_SECCOMP_CFG;
		postexec_filter = RUN_SECCOMP_POSTEXEC;
	} else {
		filter = RUN_SECCOMP_32;
		postexec_filter = RUN_SECCOMP_POSTEXEC_32;
	}

	// if we have multiple seccomp commands, only one of them is executed
	// in the following order:
	//	- seccomp.drop list
	//	- seccomp list
	//	- seccomp
	if (cfg.seccomp_list_drop == NULL) {
		// default seccomp if error action is not changed
		if ((cfg.seccomp_list == NULL || cfg.seccomp_list[0] == '\0')
		    && arg_seccomp_error_action == DEFAULT_SECCOMP_ERROR_ACTION) {
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
			int rv;

			if (arg_seccomp_block_secondary) {
				if (arg_seccomp_error_action != DEFAULT_SECCOMP_ERROR_ACTION) {
					if (arg_debug)
						printf("Rebuild secondary block seccomp filter\n");
					rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 4,
						      PATH_FSECCOMP, "secondary", "block", RUN_SECCOMP_BLOCK_SECONDARY);
					if (rv)
						exit(rv);
				}
				seccomp_filter_block_secondary();
			} else {
#if defined(__x86_64__)
#if defined(__LP64__)
				if (arg_seccomp_error_action != DEFAULT_SECCOMP_ERROR_ACTION) {
					if (arg_debug)
						printf("Rebuild 32 bit seccomp filter\n");
					rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 4,
						      PATH_FSECCOMP, "secondary", "32", RUN_SECCOMP_32);
					if (rv)
						exit(rv);
				}
				seccomp_filter_32();
#endif
#endif
			}
			if (arg_debug)
				printf("Build default+drop seccomp filter\n");

			const char *command, *list;
			if (native) {
				command = "default";
				list = cfg.seccomp_list;
			} else {
				command = "default32";
				list = cfg.seccomp_list32;
			}

			// build the seccomp filter as a regular user
			if (list && list[0])
				if (arg_allow_debuggers)
					rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 7,
						      PATH_FSECCOMP, command, "drop", filter, postexec_filter, list, "allow-debuggers");
				else
					rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 6,
						      PATH_FSECCOMP, command, "drop", filter, postexec_filter, list);
			else
				if (arg_allow_debuggers)
					rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 4,
						      PATH_FSECCOMP, command, filter, "allow-debuggers");
				else
					rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 3,
						      PATH_FSECCOMP, command, filter);

			if (rv)
				exit(rv);

			// optimize the new filter
			rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2, PATH_FSEC_OPTIMIZE, filter);
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

		const char *command, *list;
		if (native) {
			command = "drop";
			list = cfg.seccomp_list_drop;
		} else {
			command = "drop32";
			list = cfg.seccomp_list_drop32;
		}

		// build the seccomp filter as a regular user
		int rv;
		if (arg_allow_debuggers)
			rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 6,
				      PATH_FSECCOMP, command, filter, postexec_filter, list,  "allow-debuggers");
		else
			rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 5,
				      PATH_FSECCOMP, command, filter, postexec_filter, list);

		if (rv)
			exit(rv);

		// optimize the drop filter
		rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2, PATH_FSEC_OPTIMIZE, filter);
		if (rv)
			exit(rv);
	}

	// load the filter
	if (seccomp_load(filter) == 0) {
		if (arg_debug)
			printf("seccomp filter configured\n");
	}

	if (arg_debug && access(PATH_FSEC_PRINT, X_OK) == 0) {
		struct stat st;
		if (stat(postexec_filter, &st) != -1 && st.st_size != 0) {
			printf("configuring postexec seccomp filter in %s\n", postexec_filter);
			sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2,
				  PATH_FSEC_PRINT, postexec_filter);
		}
	}

	return 0;
}

// keep filter for seccomp option
int seccomp_filter_keep(bool native) {
	// secondary filters are not installed except when secondary
	// architectures are explicitly blocked
	if (arg_seccomp_block_secondary)
		seccomp_filter_block_secondary();

	if (arg_debug)
		printf("Build keep seccomp filter\n");

	const char *filter, *postexec_filter, *list;
	if (native) {
		filter = RUN_SECCOMP_CFG;
		postexec_filter = RUN_SECCOMP_POSTEXEC;
		list = cfg.seccomp_list_keep;
	} else {
		filter = RUN_SECCOMP_32;
		postexec_filter = RUN_SECCOMP_POSTEXEC_32;
		list = cfg.seccomp_list_keep32;
	}

	// build the seccomp filter as a regular user
	int rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 5,
		 PATH_FSECCOMP, "keep", filter, postexec_filter, list);

	if (rv) {
		fprintf(stderr, "Error: cannot configure seccomp filter\n");
		exit(rv);
	}

	if (arg_debug)
		printf("seccomp filter configured\n");

	// load the filter
	if (seccomp_load(filter) == 0) {
		if (arg_debug)
			printf("seccomp filter configured\n");
	}

	if (arg_debug && access(PATH_FSEC_PRINT, X_OK) == 0) {
		struct stat st;
		if (stat(postexec_filter, &st) != -1 && st.st_size != 0) {
			printf("configuring postexec seccomp filter in %s\n", postexec_filter);
			sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2,
				  PATH_FSEC_PRINT, postexec_filter);
		}
	}

	return 0;
}

// create mdwx filter for non-default error action
int seccomp_filter_mdwx(bool native) {
	if (arg_debug)
		printf("Build memory-deny-write-execute filter\n");

	const char *command, *filter;
	if (native) {
		command = "memory-deny-write-execute";
		filter = RUN_SECCOMP_MDWX;
	} else {
		command = "memory-deny-write-execute.32";
		filter = RUN_SECCOMP_MDWX_32;
	}

	// build the seccomp filter as a regular user
	int rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 3,
		PATH_FSECCOMP, command, filter);

	if (rv) {
		fprintf(stderr, "Error: cannot build memory-deny-write-execute filter\n");
		exit(rv);
	}

	if (arg_debug)
		printf("Memory-deny-write-execute filter configured\n");

	return 0;
}

// create namespaces filter
int seccomp_filter_namespaces(bool native, const char *list) {
	if (arg_debug)
		printf("Build restrict-namespaces filter\n");

	const char *command, *filter;
	if (native) {
		command = "restrict-namespaces";
		filter = RUN_SECCOMP_NS;
	} else {
		command = "restrict-namespaces.32";
		filter = RUN_SECCOMP_NS_32;
	}

	// build the seccomp filter as a regular user
	int rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 4,
		PATH_FSECCOMP, command, filter, list);

	if (rv) {
		fprintf(stderr, "Error: cannot build restrict-namespaces filter\n");
		exit(rv);
	}

	if (arg_debug)
		printf("restrict-namespaces filter configured\n");

	return 0;
}

void seccomp_print_filter(pid_t pid) {
	EUID_ASSERT();

	ProcessHandle sandbox = pin_sandbox_process(pid);

	// chroot in the sandbox
	process_rootfs_chroot(sandbox);
	unpin_process(sandbox);

	drop_privs(0);

	// find the seccomp list file
	FILE *fp = fopen(RUN_SECCOMP_LIST, "re");
	if (!fp) {
		printf("Cannot access seccomp filter.\n");
		exit(1);
	}

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		// clean '\n'
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';

		printf("FILE: %s\n", buf); fflush(0);

		// read and print the filter
		pid_t child = fork();
		if (child < 0)
			errExit("fork");
		if (child == 0) {
			execl(PATH_FSEC_PRINT, PATH_FSEC_PRINT, buf, NULL);
			errExit("execl");
		}
		waitpid(child, NULL, 0);

		printf("\n"); fflush(0);
	}
	fclose(fp);

	exit(0);
}
