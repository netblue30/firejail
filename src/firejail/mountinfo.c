/*
 * Copyright (C) 2014-2021 Firejail Authors
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

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#define MAX_BUF 4096

static char mbuf[MAX_BUF];
static MountData mdata;


// Convert octal escape sequence to decimal value
static int read_oct(const char *path) {
	int dec = 0;
	int digit, i;
	// there are always exactly three octal digits
	for (i = 1; i < 4; i++) {
		digit = *(path + i);
		if (digit < '0' || digit > '7') {
			fprintf(stderr, "Error: cannot read /proc/self/mountinfo\n");
			exit(1);
		}
		dec = (dec << 3) + (digit - '0');
	}
	return dec;
}

// Restore empty spaces in pathnames extracted from /proc/self/mountinfo
static void unmangle_path(char *path) {
	char *p = strchr(path, '\\');
	if (p && read_oct(p) == ' ') {
		*p = ' ';
		int i = 3;
		do {
			p++;
			if (*(p + i) == '\\' && read_oct(p + i) == ' ') {
				*p = ' ';
				i += 3;
			}
			else
				*p = *(p + i);
		} while (*p);
	}
}

// Parse a line from /proc/self/mountinfo,
// the function does an exit(1) if anything goes wrong.
static void parse_line(char *line, MountData *output) {
	assert(line && output);
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
	if (ptr != line)
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
	output->fstype = ptr++;


	if (output->mountid == 0 ||
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

// Needs kernel 3.15 or better
int get_mount_id(int fd) {
	int rv = -1;

	char *proc;
	if (asprintf(&proc, "/proc/self/fdinfo/%d", fd) == -1)
		errExit("asprintf");
	EUID_ROOT();
	FILE *fp = fopen(proc, "re");
	EUID_USER();
	if (!fp)
		goto errexit;

	char buf[MAX_BUF];
	while (fgets(buf, MAX_BUF, fp)) {
		if (strncmp(buf, "mnt_id:", 7) == 0) {
			if (sscanf(buf + 7, "%d", &rv) != 1)
				goto errexit;
			break;
		}
	}

	free(proc);
	fclose(fp);
	return rv;

errexit:
	fprintf(stderr, "Error: cannot read proc file\n");
	exit(1);
}

// Check /proc/self/mountinfo if path contains any mounts points.
// Returns an array that can be iterated over for recursive remounting.
char **build_mount_array(const int mount_id, const char *path) {
	assert(path);

	// open /proc/self/mountinfo
	FILE *fp = fopen("/proc/self/mountinfo", "re");
	if (!fp) {
		fprintf(stderr, "Error: cannot read /proc/self/mountinfo\n");
		exit(1);
	}

	// array to be returned
	size_t cnt = 0;
	size_t size = 32;
	char **rv = malloc(size * sizeof(*rv));
	if (!rv)
		errExit("malloc");

	// read /proc/self/mountinfo
	size_t pathlen = strlen(path);
	char buf[MAX_BUF];
	MountData mntp;
	int found = 0;

	if (fgets(buf, MAX_BUF, fp) == NULL) {
		fprintf(stderr, "Error: cannot read /proc/self/mountinfo\n");
		exit(1);
	}
	do {
		parse_line(buf, &mntp);
		// find mount point with mount id
		if (!found) {
			if (mntp.mountid == mount_id) {
				// give up if mount id has been reassigned,
				// don't remount blacklisted path
				if (strncmp(mntp.dir, path, strlen(mntp.dir)) ||
				    strstr(mntp.fsname, "firejail.ro.dir") ||
				    strstr(mntp.fsname, "firejail.ro.file"))
					    break;

				rv[cnt] = strdup(path);
				if (rv[cnt] == NULL)
					errExit("strdup");
				cnt++;
				found = 1;
				continue;
			}
			continue;
		}
		// from here on add all mount points below path,
		// don't remount blacklisted paths
		if (strncmp(mntp.dir, path, pathlen) == 0 &&
		    mntp.dir[pathlen] == '/' &&
		    strstr(mntp.fsname, "firejail.ro.dir") == NULL &&
		    strstr(mntp.fsname, "firejail.ro.file") == NULL) {

			if (cnt == size) {
				size *= 2;
				rv = realloc(rv, size * sizeof(*rv));
				if (!rv)
					errExit("realloc");
			}
			rv[cnt] = strdup(mntp.dir);
			if (rv[cnt] == NULL)
				errExit("strdup");
			cnt++;
		}
	} while (fgets(buf, MAX_BUF, fp));

	if (cnt == size) {
		size++;
		rv = realloc(rv, size * sizeof(*rv));
		if (!rv)
			errExit("realloc");
	}
	rv[cnt] = NULL; // end of the array

	fclose(fp);
	return rv;
}
