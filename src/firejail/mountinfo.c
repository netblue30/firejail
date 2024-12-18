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
#include <errno.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#define MAX_BUF 4096

static char mbuf[MAX_BUF];
static MountData mdata;


// Convert octal escape sequence to decimal value
static unsigned read_oct(char *s) {
	assert(s[0] == '\\');
	s++;

	int i;
	for (i = 0; i < 3; i++)
		assert(s[i] >= '0' && s[i] <= '7');

	return ((s[0] - '0') << 6 |
	        (s[1] - '0') << 3 |
	        (s[2] - '0') << 0);
}

// Restore empty spaces in pathnames extracted from /proc/self/mountinfo
static void unmangle_path(char *path) {
	char *r = strchr(path, '\\');
	if (!r)
		return;

	char *w = r;
	do {
		while (*r == '\\') {
			*w++ = read_oct(r);
			r += 4;
		}
		*w++ = *r;
	} while (*r++);
}

// Parse a line from /proc/self/mountinfo,
// the function does an exit(1) if anything goes wrong.
static void parse_line(char *line, MountData *output) {
	memset(output, 0, sizeof(*output));
	// extract mount id, filesystem name, directory and filesystem types
	// examples:
	//	587 543 8:1 /tmp /etc rw,relatime master:1 - ext4 /dev/sda1 rw,errors=remount-ro,data=ordered
	//		output.mountid: 587
	//		output.fsname: /tmp
	//		output.dir: /etc
	//		output.fstype: ext4
	//	585 564 0:76 / /home/netblue/.cache rw,nosuid,nodev - tmpfs tmpfs rw
	//		output.mountid: 585
	//		output.fsname: /
	//		output.dir: /home/netblue/.cache
	//		output.fstype: tmpfs

	char *ptr = strtok(line, " ");
	if (!ptr)
		goto errexit;
	output->mountid = atoi(ptr);
	int cnt = 1;

	while ((ptr = strtok(NULL, " ")) != NULL) {
		cnt++;
		if (cnt == 4)
			output->fsname = ptr;
		else if (cnt == 5) {
			output->dir = ptr;
			break;
		}
	}

	ptr = strtok(NULL, "-");
	if (!ptr)
		goto errexit;

	ptr = strtok(NULL, " ");
	if (!ptr)
		goto errexit;
	output->fstype = ptr;

	if (output->mountid < 0 ||
	    output->fsname == NULL ||
	    output->dir == NULL ||
	    output->fstype == NULL)
		goto errexit;

	// restore empty spaces
	unmangle_path(output->fsname);
	unmangle_path(output->dir);

	return;

errexit:
	fprintf(stderr, "Error: cannot read /proc/self/mountinfo\n");
	exit(1);
}

// The return value points to a static area, and will be overwritten by subsequent calls.
MountData *get_last_mount(void) {
	// open /proc/self/mountinfo
	FILE *fp = fopen("/proc/self/mountinfo", "re");
	if (!fp) {
		fprintf(stderr, "Error: cannot read /proc/self/mountinfo\n");
		exit(1);
	}

	mbuf[0] = '\0';
	// go to the last line
	while (fgets(mbuf, MAX_BUF, fp));
	fclose(fp);
	if (arg_debug)
		printf("%s", mbuf);

	parse_line(mbuf, &mdata);

	if (arg_debug)
		printf("mountid=%d fsname=%s dir=%s fstype=%s\n", mdata.mountid, mdata.fsname, mdata.dir, mdata.fstype);
	return &mdata;
}

// Returns mount id, or -1 if fd refers to a procfs or sysfs file
static int get_mount_id_from_handle(int fd) {
	char *proc;
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");

	struct file_handle *fh = malloc(sizeof *fh);
	if (!fh)
		errExit("malloc");
	fh->handle_bytes = 0;

	int rv = -1;
	int tmp;
	if (name_to_handle_at(-1, proc, fh, &tmp, AT_SYMLINK_FOLLOW) != -1) {
		fprintf(stderr, "Error: unexpected result from name_to_handle_at\n");
		exit(1);
	}
	if (errno == EOVERFLOW && fh->handle_bytes)
		rv = tmp;

	free(proc);
	free(fh);
	return rv;
}

// Returns mount id, or -1 on kernels < 3.15
static int get_mount_id_from_fdinfo(int fd) {
	char *proc;
	if (asprintf(&proc, "/proc/self/fdinfo/%d", fd) == -1)
		errExit("asprintf");

	int called_as_root = 0;
	if (geteuid() == 0)
		called_as_root = 1;

	if (called_as_root == 0)
		EUID_ROOT();

	FILE *fp = fopen(proc, "re");
	if (!fp) {
		fprintf(stderr, "Error: cannot read proc file\n");
		exit(1);
	}

	if (called_as_root == 0)
		EUID_USER();

	int rv = -1;
	char buf[MAX_BUF];
	while (fgets(buf, MAX_BUF, fp)) {
		if (sscanf(buf, "mnt_id: %d", &rv) == 1)
				break;
	}

	free(proc);
	fclose(fp);
	return rv;
}

int get_mount_id(int fd) {
	int rv = get_mount_id_from_handle(fd);
	if (rv < 0)
		rv = get_mount_id_from_fdinfo(fd);
	return rv;
}

// Check /proc/self/mountinfo if path contains any mounts points.
// Returns an array that can be iterated over for recursive remounting.
char **build_mount_array(const int mountid, const char *path) {
	assert(path);

	FILE *fp = fopen("/proc/self/mountinfo", "re");
	if (!fp) {
		fprintf(stderr, "Error: cannot read /proc/self/mountinfo\n");
		exit(1);
	}

	// try to find line with mount id
	int found = 0;
	MountData mntp;
	char line[MAX_BUF];
	while (fgets(line, MAX_BUF, fp)) {
		parse_line(line, &mntp);
		if (mntp.mountid == mountid) {
			found = 1;
			break;
		}
	}

	if (!found) {
		fclose(fp);
		return NULL;
	}

	// allocate array
	size_t size = 32;
	char **rv = malloc(size * sizeof(*rv));
	if (!rv)
		errExit("malloc");

	// add directory itself
	size_t cnt = 0;
	rv[cnt] = strdup(path);
	if (rv[cnt] == NULL)
		errExit("strdup");

	// and add all following mountpoints contained in this directory
	size_t pathlen = strlen(path);
	while (fgets(line, MAX_BUF, fp)) {
		parse_line(line, &mntp);
		if (strncmp(mntp.dir, path, pathlen) == 0 && mntp.dir[pathlen] == '/') {
			if (++cnt == size) {
				size *= 2;
				rv = realloc(rv, size * sizeof(*rv));
				if (!rv)
					errExit("realloc");
			}
			rv[cnt] = strdup(mntp.dir);
			if (rv[cnt] == NULL)
				errExit("strdup");
		}
	}
	fclose(fp);

	// end of array
	if (++cnt == size) {
		++size;
		rv = realloc(rv, size * sizeof(*rv));
		if (!rv)
			errExit("realloc");
	}
	rv[cnt] = NULL;
	return rv;
}
