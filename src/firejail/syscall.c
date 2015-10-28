/*
 * Copyright (C) 2014, 2015 Firejail Authors
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
#include <sys/syscall.h>

typedef struct {
	char *name;
	int nr;
} SyscallEntry;

static SyscallEntry syslist[] = {
//
// code generated using tools/extract-syscall
//
#include "syscall.h"
//
// end of generated code
//
}; // end of syslist

const char *syscall_find_nr(int nr) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		if (nr == syslist[i].nr)
			return syslist[i].name;
	}
	
	return "unknown";
}

// return -1 if error, or syscall number
static int syscall_find_name(const char *name) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		if (strcmp(name, syslist[i].name) == 0)
			return syslist[i].nr;
	}
	
	return -1;
}

// return 1 if error, 0 if OK
int syscall_check_list(const char *slist, void (*callback)(int syscall, int arg), int arg) {
	// don't allow empty lists
	if (slist == NULL || *slist == '\0') {
		fprintf(stderr, "Error: empty syscall lists are not allowed\n");
		return -1;
	}

	// work on a copy of the string
	char *str = strdup(slist);
	if (!str)
		errExit("strdup");

	char *ptr = str;
	char *start = str;
	while (*ptr != '\0') {
		if (islower(*ptr) || isdigit(*ptr) || *ptr == '_')
			;
		else if (*ptr == ',') {
			*ptr = '\0';
			int nr = syscall_find_name(start);
			if (nr == -1)
				fprintf(stderr, "Warning: syscall %s not found\n", start);
			else if (callback != NULL)
				callback(nr, arg);
				
			start = ptr + 1;
		}
		ptr++;
	}
	if (*start != '\0') {
		int nr = syscall_find_name(start);
		if (nr == -1)
			fprintf(stderr, "Warning: syscall %s not found\n", start);
		else if (callback != NULL)
			callback(nr, arg);
	}
	
	free(str);
	return 0;
}

void syscall_print(void) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		printf("%d\t- %s\n", syslist[i].nr, syslist[i].name);
	}
	printf("\n");
}

#endif // HAVE_SECCOMP
