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
#include "seccomp.h"
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

static struct sock_filter protocol_filter_command[] = {
	WHITELIST(AF_UNIX),
	WHITELIST(AF_INET),
	WHITELIST(AF_INET6),
	WHITELIST(AF_NETLINK),
	WHITELIST(AF_PACKET)
};
// Note: protocol[] and protocol_filter_command are synchronized

// command length
struct sock_filter whitelist[] = {
	WHITELIST(AF_UNIX)
};
unsigned whitelist_len = sizeof(whitelist) / sizeof(struct sock_filter);



static int is_protocol(const char *p) {
	int i = 0;
	while (protocol[i] != NULL) {
		if (strcmp(protocol[i], p) == 0)
			return 1;
		i++;
	}

	return 0;
}	

static struct sock_filter *find_protocol_domain(const char *p) {
	int i = 0;
	while (protocol[i] != NULL) {
		if (strcmp(protocol[i], p) == 0)
			return &protocol_filter_command[i * whitelist_len];
		i++;
	}

	return NULL;
}	

// --debug-protocols
void protocol_list(void) {
	int i = 0;
	while (protocol[i] != NULL) {
		printf("%s, ", protocol[i]);
		i++;
	}
	printf("\n");
}

// --protocol.print
void protocol_print_filter_name(const char *name) {
	(void) name;
#ifdef SYS_socket
//todo
#else
	fprintf(stderr, "Warning: --protocol not supported on this platform\n");
	return;
#endif
}

// --protocol.print
void protocol_print_filter(pid_t pid) {
	(void) pid;
#ifdef SYS_socket
//todo
#else
        fprintf(stderr, "Warning: --protocol not supported on this platform\n");
        return;
#endif  
}

// check protocol list and store it in cfg structure
void protocol_store(const char *prlist) {
	assert(prlist);
	
	// temporary list
	char *tmplist = strdup(prlist);
	if (!tmplist)
		errExit("strdup");
	
	// check list
	char *token = strtok(tmplist, ",");
	if (!token)
		goto errout;
		
	while (token) {
		if (!is_protocol(token))
			goto errout;
		token = strtok(NULL, ",");
	}	
	free(tmplist);
	
	// store list
	cfg.protocol = strdup(prlist);
	if (!cfg.protocol)
		errExit("strdup");
	return;
		
errout:
	fprintf(stderr, "Error: invalid protocol list\n");
	exit(1);
}	

// install protocol filter
void protocol_filter(void) {
	assert(cfg.protocol);

#ifndef SYS_socket
	(void) find_protocol_domain;
        fprintf(stderr, "Warning: --protocol not supported on this platform\n");
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
#endif

printf("whitelist_len %u, struct sock_filter len %u\n", whitelist_len, (unsigned) sizeof(struct sock_filter));

	// parse list and add commands
	char *tmplist = strdup(cfg.protocol);
	if (!tmplist)
		errExit("strdup");
	char *token = strtok(tmplist, ",");
	if (!token)
		errExit("strtok");
		
	while (token) {
		struct sock_filter *domain = find_protocol_domain(token);
		assert(domain);
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

	// install filter
	unsigned short entries = (unsigned short) ((uintptr_t) ptr - (uintptr_t) (filter)) / (unsigned) sizeof(struct sock_filter);
	struct sock_fprog prog = {
		.len = entries,
		.filter = filter,
	};

	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) || prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
		fprintf(stderr, "Warning: seccomp disabled, it requires a Linux kernel version 3.5 or newer.\n");
		return;
	}
	else if (arg_debug) {
		printf("seccomp protocol filter enabled\n");
	}
#endif // SYS_socket	
}

#endif // HAVE_SECCOMP
