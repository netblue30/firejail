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

#define MAX_BUF 4096
static char mbuf[MAX_BUF];
static MountData mdata;

// Convert octal escape sequence to decimal value
static int read_oct(const char *path) {
	int decimal = 0;
	int digit, i;
	// there are always three octal digits
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

// Get info regarding the last kernel mount operation.
// The return value points to a static area, and will be overwritten by subsequent calls.
// The function does an exit(1) if anything goes wrong.
MountData *get_last_mount(void) {
	// open /proc/self/mountinfo
	FILE *fp = fopen("/proc/self/mountinfo", "r");
	if (!fp)
		goto errexit;

	mbuf[0] = '\0';
	while (fgets(mbuf, MAX_BUF, fp));
	fclose(fp);
	if (arg_debug)
		printf("%s", mbuf);

	// extract filesystem name, directory and filesystem type
	// examples:
	//	587 543 8:1 /tmp /etc rw,relatime master:1 - ext4 /dev/sda1 rw,errors=remount-ro,data=ordered
	//		mdata.fsname: /tmp
	//		mdata.dir: /etc
	//		mdata.fstype: ext4
	//	585 564 0:76 / /home/netblue/.cache rw,nosuid,nodev - tmpfs tmpfs rw
	//		mdata.fsname: /
	//		mdata.dir: /home/netblue/.cache
	//		mdata.fstype: tmpfs
	memset(&mdata, 0, sizeof(mdata));
	char *ptr = strtok(mbuf, " ");
	if (!ptr)
		goto errexit;

	int cnt = 1;
	while ((ptr = strtok(NULL, " ")) != NULL) {
		cnt++;
		if (cnt == 4)
			mdata.fsname = ptr;
		else if (cnt == 5) {
			mdata.dir = ptr;
			break;
		}
	}

	ptr = strtok(NULL, "-");
	if (!ptr)
		goto errexit;

	ptr = strtok(NULL, " ");
	if (!ptr)
		goto errexit;
	mdata.fstype = ptr++;

	if (mdata.fsname == NULL ||
	    mdata.dir == NULL ||
	    mdata.fstype == NULL)
		goto errexit;

	unmangle_path(mdata.fsname);
	unmangle_path(mdata.dir);

	if (arg_debug)
		printf("fsname=%s dir=%s fstype=%s\n", mdata.fsname, mdata.dir, mdata.fstype);
	return &mdata;

errexit:
	fprintf(stderr, "Error: cannot read /proc/self/mountinfo\n");
	exit(1);
}
