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

#ifdef HAVE_SECCOMP
#include "firejail.h"
#include "../include/seccomp.h"

// install protocol filter
void protocol_filter(const char *fname) {
#ifndef SYS_socket
	if (arg_debug)
		printf("No support for --protocol on this platform\n");
	return;
#else
	assert(fname);

	// check file
	struct stat s;
	if (stat(fname, &s) == -1) {
		fprintf(stderr, "Error: cannot read protocol filter file\n");
		exit(1);
	}
	int size = s.st_size;

	// read filter
	struct sock_filter filter[32];	// big enough
	memset(&filter[0], 0, sizeof(filter));
	int src = open(fname, O_RDONLY);
	int rd = 0;
	while (rd < size) {
		int rv = read(src, (unsigned char *) filter + rd, size - rd);
		if (rv == -1) {
			fprintf(stderr, "Error: cannot read %s file\n", fname);
			exit(1);
		}
		rd += rv;
	}
	close(src);

	// install filter
	unsigned short entries = (unsigned short) size / (unsigned short) sizeof(struct sock_filter);
	struct sock_fprog prog = {
		.len = entries,
		.filter = filter,
	};

	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) || prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
		fprintf(stderr, "Warning: seccomp disabled, it requires a Linux kernel version 3.5 or newer.\n");
		return;
	}
#endif	
}

void protocol_filter_save(void) {
	// save protocol filter configuration in PROTOCOL_CFG
	FILE *fp = fopen(RUN_PROTOCOL_CFG, "w");
	if (!fp)
		errExit("fopen");
	fprintf(fp, "%s\n", cfg.protocol);
	SET_PERMS_STREAM(fp, 0, 0, 0600);
	fclose(fp);
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
