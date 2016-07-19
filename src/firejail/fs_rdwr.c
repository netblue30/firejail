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
#if 0
#include "firejail.h"
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

typedef struct rdwr_t {
	struct rdwr_t *next;
	const char *path;
} RDWR;

RDWR *rdwr = NULL;

void fs_rdwr_add(const char *path) {
	// verify path
	if (*path != '/') {
		fprintf(stderr, "Error: invalid path for read-write command\n");
		exit(1);
	}
	invalid_filename(path);
	if (is_link(path)) {
		fprintf(stderr, "Error: invalid symbolic link for read-write command\n");
		exit(1);
	}
	if (strstr(path, "..")) {
		fprintf(stderr, "Error: invalid path for read-write command\n");
		exit(1);
	}
	
	// print warning if the file doesn't exist
	struct stat s;
	if (stat(path, &s) == -1) {
		fprintf(stderr, "Warning: %s not found, skipping read-write command\n", path);
		return;
	}
	
	// build list entry
	RDWR *r = malloc(sizeof(RDWR));
	if (!r)
		errExit("malloc");
	memset(r, 0, sizeof(RDWR));
	r->path = path;
	
	// add
	r->next = rdwr;
	rdwr = r;
}

static void mount_rdwr(const char *path) {
	assert(path);
	// check directory exists
	struct stat s;
	int rv = stat(path, &s);
	if (rv == 0) {
		// mount --bind /bin /bin
		if (mount(path, path, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount read-write");
		// mount --bind -o remount,rw /bin
		if (mount(NULL, path, NULL, MS_BIND|MS_REMOUNT|MS_REC, NULL) < 0)
			errExit("mount read-write");
		fs_logger2("read-write", path);
	}
}

void fs_rdwr(void) {
	RDWR *ptr = rdwr;
	
	while (ptr) {
		mount_rdwr(ptr->path);
		ptr = ptr->next;
	}
}

#endif

