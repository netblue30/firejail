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
#include "fseccomp.h"
#include <sys/syscall.h>

typedef struct {
	char *name;
	int nr;
} SyscallEntry;

static SyscallEntry syslist[] = {
//
// code generated using tools/extract-syscall
//
#include "../include/syscall.h"
//
// end of generated code
//
}; // end of syslist

// return -1 if error, or syscall number
int syscall_find_name(const char *name) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		if (strcmp(name, syslist[i].name) == 0)
			return syslist[i].nr;
	}
	
	return -1;
}

char *syscall_find_nr(int nr) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		if (nr == syslist[i].nr)
			return syslist[i].name;
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

// allowed input:
// - syscall
// - syscall(error)
static void syscall_process_name(const char *name, int *syscall_nr, int *error_nr) {
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

	*syscall_nr = syscall_find_name(syscall_name);
	if (error_name) {
		*error_nr = errno_find_name(error_name);
		if (*error_nr == -1)
			*syscall_nr = -1;
	}

	free(str);
	return;
	
error:
	fprintf(stderr, "Error fseccomp: invalid syscall list entry %s\n", name);
	exit(1);
}

// return 1 if error, 0 if OK
int syscall_check_list(const char *slist, void (*callback)(int fd, int syscall, int arg), int fd, int arg) {
	// don't allow empty lists
	if (slist == NULL || *slist == '\0') {
		fprintf(stderr, "Error fseccomp: empty syscall lists are not allowed\n");
		exit(1);
	}

	// work on a copy of the string
	char *str = strdup(slist);
	if (!str)
		errExit("strdup");

	char *ptr =strtok(str, ",");
	if (ptr == NULL) {
		fprintf(stderr, "Error fseccomp: empty syscall lists are not allowed\n");
		exit(1);
	}

	while (ptr) {
		int syscall_nr;
		int error_nr;
		syscall_process_name(ptr, &syscall_nr, &error_nr);
		if (syscall_nr == -1)
			fprintf(stderr, "Warning fseccomp: syscall %s not found\n", ptr);
		else if (callback != NULL) {
			if (error_nr != -1)
				filter_add_errno(fd, syscall_nr, error_nr);
			else
				callback(fd, syscall_nr, arg);
		}
		ptr = strtok(NULL, ",");
	}
	
	free(str);
	return 0;
}
