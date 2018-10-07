/*
 * Copyright (C) 2014-2018Firejail Authors
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

/*
	struct sock_filter filter[] = {
		VALIDATE_ARCHITECTURE,
		EXAMINE_SYSCALL,
		ONLY(SYS_socket),
		EXAMINE_ARGUMENT(0), // allow only AF_INET and AF_INET6, drop everything else
		WHITELIST(AF_INET),
		WHITELIST(AF_INET6),
		WHITELIST(AF_PACKET),
		RETURN_ERRNO(ENOTSUP)
	};
	struct sock_fprog prog = {
		.len = (unsigned short)(sizeof(filter) / sizeof(filter[0])),
		.filter = filter,
	};


	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
		perror("prctl(NO_NEW_PRIVS)");
		return 1;
	}
	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog)) {
		perror("prctl");
		return 1;
	}
*/

#include "fseccomp.h"
#include "../include/seccomp.h"
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/socket.h>

static char *protocol[] = {
	"unix",
	"inet",
	"inet6",
	"netlink",
	"packet",
	NULL
};

#ifdef SYS_socket
static struct sock_filter protocol_filter_command[] = {
	WHITELIST(AF_UNIX),
	WHITELIST(AF_INET),
	WHITELIST(AF_INET6),
	WHITELIST(AF_NETLINK),
	WHITELIST(AF_PACKET)
};
#endif
// Note: protocol[] and protocol_filter_command are synchronized

// command length
struct sock_filter whitelist[] = {
	WHITELIST(AF_UNIX)
};
unsigned whitelist_len = sizeof(whitelist) / sizeof(struct sock_filter);

#ifdef SYS_socket
static struct sock_filter *find_protocol_domain(const char *p) {
	int i = 0;
	while (protocol[i] != NULL) {
		if (strcmp(protocol[i], p) == 0)
			return &protocol_filter_command[i * whitelist_len];
		i++;
	}

	return NULL;
}
#endif

void protocol_print(void) {
#ifndef SYS_socket
	if (!arg_quiet)
		fprintf(stderr, "Warning fseccomp: firejail --protocol not supported on this platform\n");
	return;
#endif

	int i = 0;
	while (protocol[i] != NULL) {
		printf("%s, ", protocol[i]);
		i++;
	}
	printf("\n");
}

// install protocol filter
void protocol_build_filter(const char *prlist, const char *fname) {
	assert(prlist);
	assert(fname);

#ifndef SYS_socket
	if (!arg_quiet)
		fprintf(stderr, "Warning fseccomp: --protocol not supported on this platform\n");
	return;
#else
	// build the filter
	struct sock_filter filter[32];	// big enough
	memset(&filter[0], 0, sizeof(filter));
	uint8_t *ptr = (uint8_t *) &filter[0];

	// header
	struct sock_filter filter_start[] = {
		VALIDATE_ARCHITECTURE,
		EXAMINE_SYSCALL,
		ONLY(SYS_socket),
		EXAMINE_ARGUMENT(0)
	};
	memcpy(ptr, &filter_start[0], sizeof(filter_start));
	ptr += sizeof(filter_start);

#if 0
printf("entries %u\n", (unsigned) (sizeof(filter_start) / sizeof(struct sock_filter)));
{
	unsigned j;
	unsigned char *ptr2 = (unsigned char *) &filter[0];
	for (j = 0; j < sizeof(filter); j++, ptr2++) {
		if ((j % (sizeof(struct sock_filter))) == 0)
			printf("\n%u: ", 1 + (unsigned) (j / (sizeof(struct sock_filter))));
		printf("%02x, ", (*ptr2) & 0xff);
	}
	printf("\n");
}
printf("whitelist_len %u, struct sock_filter len %u\n", whitelist_len, (unsigned) sizeof(struct sock_filter));
#endif


	// parse list and add commands
	char *tmplist = strdup(prlist);
	if (!tmplist)
		errExit("strdup");
	char *token = strtok(tmplist, ",");
	if (!token)
		errExit("strtok");

	while (token) {
		struct sock_filter *domain = find_protocol_domain(token);
		if (domain == NULL) {
			fprintf(stderr, "Error fseccomp: %s is not a valid protocol\n", token);
			exit(1);
		}
		memcpy(ptr, domain, whitelist_len * sizeof(struct sock_filter));
		ptr += whitelist_len * sizeof(struct sock_filter);
		token = strtok(NULL, ",");

#if 0
printf("entries %u\n",  (unsigned) ((uint64_t) ptr - (uint64_t) (filter)) / (unsigned) sizeof(struct sock_filter));
{
	unsigned j;
	unsigned char *ptr2 = (unsigned char *) &filter[0];
	for (j = 0; j < sizeof(filter); j++, ptr2++) {
		if ((j % (sizeof(struct sock_filter))) == 0)
			printf("\n%u: ", 1 + (unsigned) (j / (sizeof(struct sock_filter))));
		printf("%02x, ", (*ptr2) & 0xff);
	}
	printf("\n");
}
#endif


	}
	free(tmplist);

	// add end of filter
	struct sock_filter filter_end[] = {
		RETURN_ERRNO(ENOTSUP)
	};
	memcpy(ptr, &filter_end[0], sizeof(filter_end));
	ptr += sizeof(filter_end);

#if 0
printf("entries %u\n",  (unsigned) ((uint64_t) ptr - (uint64_t) (filter)) / (unsigned) sizeof(struct sock_filter));
{
	unsigned j;
	unsigned char *ptr2 = (unsigned char *) &filter[0];
	for (j = 0; j < sizeof(filter); j++, ptr2++) {
		if ((j % (sizeof(struct sock_filter))) == 0)
			printf("\n%u: ", 1 + (unsigned) (j / (sizeof(struct sock_filter))));
		printf("%02x, ", (*ptr2) & 0xff);
	}
	printf("\n");
}
#endif
	// save filter to file
	int dst = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (dst < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	int size = (int) ((uintptr_t) ptr - (uintptr_t) (filter));
	int written = 0;
	while (written < size) {
		int rv = write(dst, (unsigned char *) filter + written, size - written);
		if (rv == -1) {
			fprintf(stderr, "Error fseccomp: cannot write %s file\n", fname);
			exit(1);
		}
		written += rv;
	}
	close(dst);
#endif // SYS_socket
}
