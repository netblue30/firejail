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

#ifdef HAVE_SECCOMP
#include "firejail.h"
#include "../include/seccomp.h"

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
void protocol_print_filter(pid_t pid) {
	EUID_ASSERT();

	(void) pid;
#ifdef SYS_socket
	// in case the pid is that of a firejail process, use the pid of the first child process
	pid = switch_to_child(pid);

	// now check if the pid belongs to a firejail sandbox
	if (invalid_sandbox(pid)) {
		fprintf(stderr, "Error: no valid sandbox\n");
		exit(1);
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
	fwarning("--protocol not supported on this platform\n");
	return;
#endif
}


#endif // HAVE_SECCOMP
