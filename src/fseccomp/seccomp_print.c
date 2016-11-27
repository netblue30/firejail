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
#include "../include/seccomp.h"
#include <sys/syscall.h>

static struct sock_filter *filter = NULL;
static int filter_cnt = 0;

static void load_seccomp(const char *fname) {
	assert(fname);
	
	// open filter file
	int fd = open(fname, O_RDONLY);
	if (fd == -1)
		goto errexit;

	// calculate the number of entries
	int size = lseek(fd, 0, SEEK_END);
	if (size == -1)
		goto errexit;
	if (lseek(fd, 0 , SEEK_SET) == -1)
		goto errexit;
	unsigned short entries = (unsigned short) size / (unsigned short) sizeof(struct sock_filter);
	filter_cnt = entries;
	
	// read filter
	filter = malloc(size);
	if (filter == NULL)
		goto errexit;
	memset(filter, 0, size);
	int rd = 0;
	while (rd < size) {
		int rv = read(fd, (unsigned char *) filter + rd, size - rd);
		if (rv == -1)
			goto errexit;
		rd += rv;
	}
	
	// close file
	close(fd);
	return;

errexit:
	fprintf(stderr, "Error fseccomp: cannot read %s\n", fname);
	exit(1);
}

// debug filter
void filter_print(const char *fname) {
	assert(fname);
	load_seccomp(fname);
	
	// start filter
	struct sock_filter start[] = {
		VALIDATE_ARCHITECTURE,
		EXAMINE_SYSCALL
	};

	// print sizes
	printf("SECCOMP Filter:\n");

	// test the start of the filter
	if (memcmp(&start[0], filter, sizeof(start)) == 0) {
		printf("  VALIDATE_ARCHITECTURE\n");
		printf("  EXAMINE_SYSCAL\n");
	}
	else {
		printf("Invalid seccomp filter %s\n", fname);
		return;
	}
	
	// loop trough blacklists
	int i = 4;
	while (i < filter_cnt) {
		// minimal parsing!
		unsigned char *ptr = (unsigned char *) &filter[i];
		int *nr = (int *) (ptr + 4);
		if (*ptr	== 0x15 && *(ptr +14) == 0xff && *(ptr + 15) == 0x7f ) {
			printf("  WHITELIST %d %s\n", *nr, syscall_find_nr(*nr));
			i += 2;
		}
		else if (*ptr	== 0x15 && *(ptr +14) == 0 && *(ptr + 15) == 0) {
			printf("  BLACKLIST %d %s\n", *nr, syscall_find_nr(*nr));
			i += 2;
		}
		else if (*ptr	== 0x15 && *(ptr +14) == 0x5 && *(ptr + 15) == 0) {
			int err = *(ptr + 13) << 8 | *(ptr + 12);
			printf("  ERRNO %d %s %d %s\n", *nr, syscall_find_nr(*nr), err, errno_find_nr(err));
			i += 2;
		}
		else if (*ptr == 0x06 && *(ptr +6) == 0 && *(ptr + 7) == 0 ) {
			printf("  KILL_PROCESS\n");
			i++;
		}
		else if (*ptr == 0x06 && *(ptr +6) == 0xff && *(ptr + 7) == 0x7f ) {
			printf("  RETURN_ALLOW\n");
			i++;
		}
		else {
			printf("  UNKNOWN ENTRY!!!\n");
			i++;
		}
	}
}
