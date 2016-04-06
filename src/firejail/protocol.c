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
	EUID_ASSERT();
	
#ifndef SYS_socket
	fprintf(stderr, "Warning: --protocol not supported on this platform\n");
	return;
#endif

	int i = 0;
	while (protocol[i] != NULL) {
		printf("%s, ", protocol[i]);
		i++;
	}
	printf("\n");
}


// check protocol list and store it in cfg structure
void protocol_store(const char *prlist) {
	EUID_ASSERT();
	assert(prlist);
	
	if (cfg.protocol && !arg_quiet) {
		fprintf(stderr, "Warning: a protocol list is present, the new list \"%s\" will not be installed\n", prlist);
		return;
	}
	
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
	if (arg_debug)
		printf("Set protocol filter: %s\n", cfg.protocol);

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
printf("whitelist_len %u, struct sock_filter len %u\n", whitelist_len, (unsigned) sizeof(struct sock_filter));
#endif


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
#endif // SYS_socket	
}

void protocol_filter_save(void) {
	// save protocol filter configuration in PROTOCOL_CFG
	fs_build_mnt_dir();

	FILE *fp = fopen(RUN_PROTOCOL_CFG, "w");
	if (!fp)
		errExit("fopen");
	fprintf(fp, "%s\n", cfg.protocol);
	fclose(fp);

	if (chmod(RUN_PROTOCOL_CFG, 0600) < 0)
		errExit("chmod");

	if (chown(RUN_PROTOCOL_CFG, 0, 0) < 0)
		errExit("chown");

}

void protocol_filter_load(const char *fname) {
	assert(fname);
	
	// read protocol filter configuration from PROTOCOL_CFG
	FILE *fp = fopen(fname, "r");
	if (!fp)
		return;

	const int MAXBUF = 4098;
	char buf[MAXBUF];
	if (fgets(buf, MAXBUF, fp) == NULL) {
		// empty file
		fclose(fp);
		return;
	}
	fclose(fp);
	
	char *ptr = strchr(buf, '\n');
	if (ptr)
		*ptr = '\0';
	cfg.protocol = strdup(buf);
	if (!cfg.protocol)
		errExit("strdup");
}


// --protocol.print
void protocol_print_filter_name(const char *name) {
	EUID_ASSERT();
	
	(void) name;
#ifdef SYS_socket
	if (!name || strlen(name) == 0) {
		fprintf(stderr, "Error: invalid sandbox name\n");
		exit(1);
	}
	pid_t pid;
	if (name2pid(name, &pid)) {
		fprintf(stderr, "Error: cannot find sandbox %s\n", name);
		exit(1);
	}

	protocol_print_filter(pid);
#else
	fprintf(stderr, "Warning: --protocol not supported on this platform\n");
	return;
#endif
}

// --protocol.print
void protocol_print_filter(pid_t pid) {
	EUID_ASSERT();
	
	(void) pid;
#ifdef SYS_socket
	// if the pid is that of a firejail  process, use the pid of the first child process
	EUID_ROOT();
	char *comm = pid_proc_comm(pid);
	EUID_USER();
	if (comm) {
		if (strcmp(comm, "firejail") == 0) {
			pid_t child;
			if (find_child(pid, &child) == 0) {
				pid = child;
			}
		}
		free(comm);
	}

	// check privileges for non-root users
	uid_t uid = getuid();
	if (uid != 0) {
		uid_t sandbox_uid = pid_get_uid(pid);
		if (uid != sandbox_uid) {
			fprintf(stderr, "Error: permission denied.\n");
			exit(1);
		}
	}

	// find the seccomp filter
	EUID_ROOT();
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, RUN_PROTOCOL_CFG) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(fname, &s) == -1) {
		printf("Cannot access seccomp filter.\n");
		exit(1);
	}

	// read and print the filter
	protocol_filter_load(fname);
	free(fname);
	if (cfg.protocol)
		printf("%s\n", cfg.protocol);
	exit(0);
#else
        fprintf(stderr, "Warning: --protocol not supported on this platform\n");
        return;
#endif  
}


#endif // HAVE_SECCOMP
