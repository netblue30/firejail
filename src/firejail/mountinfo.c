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

#include "firejail.h"
#include <fcntl.h>

#define MAX_BUF 4096

static char mbuf[MAX_BUF];
static MountData mdata;


// Convert octal escape sequence to decimal value
static int read_oct(const char *path) {
	int decimal = 0;
	int digit, i;
	// there are always exactly three octal digits
	for (i = 1; i < 4; i++) {
		digit = *(path + i);
		if (digit < '0' || digit > '7') {
			fprintf(stderr, "Error: cannot read /proc/self/mountinfo\n");
			exit(1);
		}
		decimal = (decimal + digit - '0') * 8;
	}
	decimal /= 8;
	return decimal;
}

// Restore empty spaces in pathnames extracted from /proc/self/mountinfo
static void unmangle_path(char *path) {
	char *p = strchr(path, '\\');
	if (p) {
		if (read_oct(p) == ' ') {
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
}

// Parse a line from /proc/self/mountinfo,
// the function does an exit(1) if anything goes wrong.
static void parse_line(char *line, MountData *output) {
	assert(line && output);
	memset(output, 0, sizeof(*output));
	// extract filesystem name, directory and filesystem types
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
		perror("fopen");
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

// Extract the mount id from /proc/self/fdinfo and return it.
int get_mount_id(const char *path) {
	EUID_ASSERT();
	int fd = open(path, O_PATH|O_CLOEXEC);
	if (fd == -1)
		return -1;

	char *fdinfo;
	if (asprintf(&fdinfo, "/proc/self/fdinfo/%d", fd) == -1)
		errExit("asprintf");
	EUID_ROOT();
	FILE *fp = fopen(fdinfo, "re");
	EUID_USER();
	if (!fp)
		goto errexit;

	// read the file
	char buf[MAX_BUF];
	while (fgets(buf, MAX_BUF, fp)) {
		if (strncmp(buf, "mnt_id:", 7) == 0) {
			char *ptr = buf + 7;
			while (*ptr != '\0' && (*ptr == ' ' || *ptr == '\t')) {
				ptr++;
			}
			if (*ptr == '\0')
				goto errexit;
			fclose(fp);
			close(fd);
			free(fdinfo);
			return atoi(ptr);
		}
	}

errexit:
	fprintf(stderr, "Error: cannot read %s\n", fdinfo);
	exit(1);
}

// Return array with all paths that might need a remount.
char **build_mount_array(const int mountid, const char *path) {
	// open /proc/self/mountinfo
	FILE *fp = fopen("/proc/self/mountinfo", "re");
	if (!fp) {
		perror("fopen");
		fprintf(stderr, "Error: cannot read /proc/self/mountinfo\n");
		exit(1);
	}

	size_t size = 32;
	size_t cnt = 0;
	char **rv = malloc(size * sizeof(*rv));
	if (!rv)
		errExit("malloc");

	// read /proc/self/mountinfo
	size_t pathlen = strlen(path);
	int found = 0;
	while (fgets(mbuf, MAX_BUF, fp)) {
		// find mount point with mount id
		if (!found) {
			parse_line(mbuf, &mdata);
			if (mdata.mountid == mountid) {
			    // don't remount blacklisted paths,
			    // give up if mount id has been reassigned
			    if (strstr(mdata.fsname, "firejail.ro.dir") ||
			        strstr(mdata.fsname, "firejail.ro.file") ||
			        strncmp(mdata.dir, path, strlen(mdata.dir)))
			        break;

				*rv = strdup(path);
				if (*rv == NULL)
					errExit("strdup");
				cnt++;
				found = 1;
				continue;
			}
			else
				continue;
		}
		// from here on add all mount points below path
		parse_line(mbuf, &mdata);
		if (strncmp(mdata.dir, path, pathlen) == 0 &&
		    mdata.dir[pathlen] == '/' &&
		    strstr(mdata.fsname, "firejail.ro.dir") == NULL &&
		    strstr(mdata.fsname, "firejail.ro.file") == NULL) {

			if (cnt >= size) {
				size *= 2;
				rv = realloc(rv, size * sizeof(*rv));
				if (!rv)
					errExit("realloc");
			}
			rv[cnt] = strdup(mdata.dir);
			if (rv[cnt] == NULL)
				errExit("strdup");
			cnt++;
		}
	}
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
