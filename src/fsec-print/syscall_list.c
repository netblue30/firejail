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
#include "fsec_print.h"
#include <sys/syscall.h>

typedef struct {
	const char * const name;
	int nr;
} SyscallEntry;

static const SyscallEntry syslist[] = {
//
// code generated using tools/extract-syscall
//
#include "../include/syscall.h"
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

	return NULL;
}
