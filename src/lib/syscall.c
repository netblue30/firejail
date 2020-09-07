/*
 * Copyright (C) 2014-2020 Firejail Authors
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
#include "../include/syscall.h"
#include <assert.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <sys/syscall.h>
#include "../include/common.h"
#include "../include/seccomp.h"

#define SYSCALL_ERROR INT_MAX
#define ERRNO_KILL -2

typedef struct {
	const char * const name;
	int nr;
} SyscallEntry;

typedef struct {
	const char * const name;
	const char * const list;
} SyscallGroupList;

typedef struct {
	const char *slist;
	char *prelist, *postlist;
	bool found;
	int syscall;
} SyscallCheckList;

// Native syscalls (64 bit versions for 64 bit arch etc)
static const SyscallEntry syslist[] = {
#if defined(__x86_64__)
// code generated using
// awk '/__NR_/ { print "{ \"" gensub("__NR_", "", "g", $2) "\", " $3 " },"; }' < /usr/include/x86_64-linux-gnu/asm/unistd_64.h
#include "../include/syscall_x86_64.h"
#elif defined(__i386__)
// awk '/__NR_/ { print "{ \"" gensub("__NR_", "", "g", $2) "\", " $3 " },"; }' < /usr/include/x86_64-linux-gnu/asm/unistd_32.h
#include "../include/syscall_i386.h"
#elif defined(__arm__)
#include "../include/syscall_armeabi.h"
#else
#warning "Please submit a syscall table for your architecture"
#endif
};

// 32 bit syscalls for 64 bit arch
static const SyscallEntry syslist32[] = {
#if defined(__x86_64__)
#include "../include/syscall_i386.h"
// TODO for other 64 bit archs
#elif defined(__i386__) || defined(__arm__) || defined(__powerpc__)
// no secondary arch for 32 bit archs
#endif
};

#include "syscall_groups.c"

// return SYSCALL_ERROR if error, or syscall number
static int syscall_find_name(const char *name) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		if (strcmp(name, syslist[i].name) == 0)
			return syslist[i].nr;
	}

	return SYSCALL_ERROR;
}

static int syscall_find_name_32(const char *name) {
	int i;
	int elems = sizeof(syslist32) / sizeof(syslist32[0]);
	for (i = 0; i < elems; i++) {
		if (strcmp(name, syslist32[i].name) == 0)
			return syslist32[i].nr;
	}

	return SYSCALL_ERROR;
}

const char *syscall_find_nr(int nr) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		if (nr == syslist[i].nr)
			return syslist[i].name;
	}

	return "unknown";
}

const char *syscall_find_nr_32(int nr) {
	int i;
	int elems = sizeof(syslist32) / sizeof(syslist32[0]);
	for (i = 0; i < elems; i++) {
		if (nr == syslist32[i].nr)
			return syslist32[i].name;
	}

	return "unknown";
}

void syscall_print(void) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		printf("%d\t- %s\n", syslist[i].nr, syslist[i].name);
	}
	printf("\n");
}

void syscall_print_32(void) {
	int i;
	int elems = sizeof(syslist32) / sizeof(syslist32[0]);
	for (i = 0; i < elems; i++) {
		printf("%d\t- %s\n", syslist32[i].nr, syslist32[i].name);
	}
	printf("\n");
}

static const char *syscall_find_group(const char *name) {
	int i;
	int elems = sizeof(sysgroups) / sizeof(sysgroups[0]);
	for (i = 0; i < elems; i++) {
		if (strcmp(name, sysgroups[i].name) == 0)
			return sysgroups[i].list;
	}

	return NULL;
}

// allowed input:
// - syscall
// - syscall(error)
static void syscall_process_name(const char *name, int *syscall_nr, int *error_nr, bool native) {
	assert(name);
	if (strlen(name) == 0)
		goto error;
	*error_nr = -1;

	// syntax check
	char *str = strdup(name);
	if (!str)
		errExit("strdup");

	char *syscall_name = str;
	char *error_name = strchr(str, ':');
	if (error_name) {
		*error_name = '\0';
		error_name++;
	}
	if (strlen(syscall_name) == 0) {
		free(str);
		goto error;
	}

	if (*syscall_name == '$')
		*syscall_nr = strtol(syscall_name + 1, NULL, 0);
	else {
		if (native)
			*syscall_nr = syscall_find_name(syscall_name);
		else
			*syscall_nr = syscall_find_name_32(syscall_name);
	}
	if (error_name) {
		if (strcmp(error_name, "kill") == 0)
			*error_nr = ERRNO_KILL;
		else {
			*error_nr = errno_find_name(error_name);
			if (*error_nr == -1)
				*syscall_nr = SYSCALL_ERROR;
		}
	}

	free(str);
	return;

error:
	fprintf(stderr, "Error fseccomp: invalid syscall list entry %s\n", name);
	exit(1);
}

// return 1 if error, 0 if OK
int syscall_check_list(const char *slist, filter_fn *callback, int fd, int arg, void *ptrarg, bool native) {
	// don't allow empty lists
	if (slist == NULL || *slist == '\0') {
		fprintf(stderr, "Error fseccomp: empty syscall lists are not allowed\n");
		exit(1);
	}

	// work on a copy of the string
	char *str = strdup(slist);
	if (!str)
		errExit("strdup");

	char *saveptr;
	char *ptr = strtok_r(str, ",", &saveptr);
	if (ptr == NULL) {
		fprintf(stderr, "Error fseccomp: empty syscall lists are not allowed\n");
		exit(1);
	}

	while (ptr) {
		int syscall_nr;
		int error_nr;
		if (*ptr == '@') {
			const char *new_list = syscall_find_group(ptr);
			if (!new_list) {
				fprintf(stderr, "Error fseccomp: unknown syscall group %s\n", ptr);
				exit(1);
			}
			syscall_check_list(new_list, callback, fd, arg, ptrarg, native);
		}
		else {
			bool negate = false;
			if (*ptr == '!') {
				negate = true;
				ptr++;
			}
			syscall_process_name(ptr, &syscall_nr, &error_nr, native);
			if (syscall_nr != SYSCALL_ERROR && callback != NULL) {
				if (negate) {
					syscall_nr = -syscall_nr;
				}
				if (error_nr >= 0 && fd > 0)
					filter_add_errno(fd, syscall_nr, error_nr, ptrarg, native);
				else if (error_nr == ERRNO_KILL && fd > 0)
					filter_add_blacklist_override(fd, syscall_nr, 0, ptrarg, native);
				else if (error_nr >= 0 && fd == 0) {
					callback(fd, syscall_nr, error_nr, ptrarg, native);
				}
				else {
					callback(fd, syscall_nr, arg, ptrarg, native);
				}
			}
		}
		ptr = strtok_r(NULL, ",", &saveptr);
	}

	free(str);
	return 0;
}

static void find_syscall(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void)fd;
	(void) arg;
	(void)native;
	SyscallCheckList *ptr = ptrarg;
	if (abs(syscall) == ptr->syscall)
		ptr->found = true;
}

// go through list2 and find matches for problem syscall
static void syscall_in_list(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void) fd;
	(void)arg;
	SyscallCheckList *ptr = ptrarg;
	SyscallCheckList sl;
	const char *name;

	sl.found = false;
	sl.syscall = syscall;
	syscall_check_list(ptr->slist, find_syscall, fd, 0, &sl, native);

	if (native)
		name = syscall_find_nr(syscall);
	else
		name = syscall_find_nr_32(syscall);

	// if found in the problem list, add to post-exec list
	if (sl.found) {
		if (ptr->postlist) {
			if (asprintf(&ptr->postlist, "%s,%s", ptr->postlist, name) == -1)
				errExit("asprintf");
		}
		else
			ptr->postlist = strdup(name);
	}
	else { // no problem, add to pre-exec list
		// build syscall:error_no
		char *newcall = NULL;
		if (arg != 0) {
			if (asprintf(&newcall, "%s:%s", name, errno_find_nr(arg)) == -1)
				errExit("asprintf");
		}
		else {
			newcall = strdup(name);
			if (!newcall)
				errExit("strdup");
		}

		if (ptr->prelist) {
			if (asprintf(&ptr->prelist, "%s,%s", ptr->prelist, newcall) == -1)
				errExit("asprintf");
			free(newcall);
		}
		else
			ptr->prelist = newcall;
	}
}

// go through list and find matches for syscalls in list @default-keep
void syscalls_in_list(const char *list, const char *slist, int fd, char **prelist, char **postlist, bool native) {
	(void) fd;
	SyscallCheckList sl;
	// these syscalls are used by firejail after the seccomp filter is initialized
	sl.slist = slist;
	sl.prelist = NULL;
	sl.postlist = NULL;
	syscall_check_list(list, syscall_in_list, 0, 0, &sl, native);
	if (!arg_quiet) {
		printf("Seccomp list in: %s,", list);
		if (sl.slist)
			printf(" check list: %s,", sl.slist);
		if (sl.prelist)
			printf(" prelist: %s,", sl.prelist);
		if (sl.postlist)
			printf(" postlist: %s", sl.postlist);
		printf("\n");
	}
	*prelist = sl.prelist;
	*postlist = sl.postlist;
}
