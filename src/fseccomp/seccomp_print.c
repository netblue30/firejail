/*
 * Copyright (C) 2014-2017 Firejail Authors
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

static int detect_filter_type(void) {
	// the filter ishould already be load in filter variable
	assert(filter);

	printf("SECCOMP Filter\n");

	// testing for main seccomp filter, protocol, mdwe - platform architecture
	const struct sock_filter start_main[] = {
		VALIDATE_ARCHITECTURE,
#if defined(__x86_64__)
		EXAMINE_SYSCALL,
		HANDLE_X32
#else
		EXAMINE_SYSCALL
#endif
	};

	if (memcmp(&start_main[0], filter, sizeof(start_main)) == 0) {
		printf("  VALIDATE_ARCHITECTURE\n");
		printf("  EXAMINE_SYSCALL\n");
#if defined(__x86_64__)
		printf("  HANDLE_X32\n");
#endif
		return sizeof(start_main) / sizeof(struct sock_filter);
	}


	// testing for secondary 64 bit filter
	const struct sock_filter start_secondary_64[] = {
		VALIDATE_ARCHITECTURE_64,
		EXAMINE_SYSCALL,
	};

	if (memcmp(&start_secondary_64[0], filter, sizeof(start_secondary_64)) == 0) {
		printf("  VALIDATE_ARCHITECTURE_64\n");
		printf("  EXAMINE_SYSCALL\n");
		return sizeof(start_secondary_64) / sizeof(struct sock_filter);
	}

	// testing for secondary 32 bit filter
	const struct sock_filter start_secondary_32[] = {
		VALIDATE_ARCHITECTURE_32,
		EXAMINE_SYSCALL,
	};

	if (memcmp(&start_secondary_32[0], filter, sizeof(start_secondary_32)) == 0) {
		printf("  VALIDATE_ARCHITECTURE_32\n");
		printf("  EXAMINE_SYSCALL\n");
		return sizeof(start_secondary_32) / sizeof(struct sock_filter);
	}

	const struct sock_filter start_secondary_block[] = {
		VALIDATE_ARCHITECTURE_KILL,
#if defined(__x86_64__)
		EXAMINE_SYSCALL,
		HANDLE_X32_KILL,
#else
		EXAMINE_SYSCALL
#endif
	};

	if (memcmp(&start_secondary_block[0], filter, sizeof(start_secondary_block)) == 0) {
		printf("  VALIDATE_ARCHITECTURE_KILL\n");
		printf("  EXAMINE_SYSCALL\n");
#if defined(__x86_64__)
		printf("  HANDLE_X32_KILL\n");
#endif
		return sizeof(start_secondary_block) / sizeof(struct sock_filter);
	}

	return 0; // filter unrecognized
}

// debug filter
void filter_print(const char *fname) {
	assert(fname);
	load_seccomp(fname);

	int i = detect_filter_type();
	if (i == 0) {
		printf("Invalid seccomp filter %s\n", fname);
		return;
	}

	// loop trough the rest of commands
	while (i < filter_cnt) {
		// minimal parsing!
		struct sock_filter *s = (struct sock_filter *) &filter[i];
		if (s->code == BPF_JMP+BPF_JEQ+BPF_K && (s + 1)->code == BPF_RET+BPF_K && (s + 1)->k == SECCOMP_RET_ALLOW ) {
			printf("  WHITELIST %d %s\n", s->k, syscall_find_nr(s->k));
			i += 2;
		}
		else if (s->code == BPF_JMP+BPF_JEQ+BPF_K && (s + 1)->code == BPF_RET+BPF_K && (s + 1)->k == SECCOMP_RET_KILL ) {
			printf("  BLACKLIST %d %s\n", s->k, syscall_find_nr(s->k));
			i += 2;
		}
		else if (s->code == BPF_JMP+BPF_JEQ+BPF_K && (s + 1)->code == BPF_RET+BPF_K && ((s + 1)->k & ~SECCOMP_RET_DATA) == SECCOMP_RET_ERRNO) {
			printf("  BLACKLIST_ERRNO %d %s %d %s\n", s->k, syscall_find_nr(s->k), (s + 1)->k & SECCOMP_RET_DATA, errno_find_nr((s + 1)->k & SECCOMP_RET_DATA));
			i += 2;
		}
		else if (s->code == BPF_RET+BPF_K && (s->k & ~SECCOMP_RET_DATA) == SECCOMP_RET_ERRNO) {
			printf("  RETURN_ERRNO %d %s\n", s->k & SECCOMP_RET_DATA, errno_find_nr(s->k & SECCOMP_RET_DATA));
			i++;
		}
		else if (s->code == BPF_RET+BPF_K && s->k == SECCOMP_RET_KILL) {
			printf("  KILL_PROCESS\n");
			i++;
		}
		else if (s->code == BPF_RET+BPF_K && s->k == SECCOMP_RET_ALLOW) {
			printf("  RETURN_ALLOW\n");
			i++;
		}
		else {
			printf("  UNKNOWN ENTRY %x!\n", s->code);
			i++;
		}
	}
}
