/*
 * Copyright (C) 2014-2024 Firejail Authors
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
#include "../include/seccomp.h"

void protocol_filter_save(void) {
	// save protocol filter configuration in PROTOCOL_CFG
	FILE *fp = fopen(RUN_PROTOCOL_CFG, "wxe");
	if (!fp)
		errExit("fopen");
	fprintf(fp, "%s\n", cfg.protocol);
	SET_PERMS_STREAM(fp, 0, 0, 0600);
	fclose(fp);
}

void protocol_filter_load(const char *fname) {
	assert(fname);

	// read protocol filter configuration from PROTOCOL_CFG
	FILE *fp = fopen(fname, "re");
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
	ProcessHandle sandbox = pin_sandbox_process(pid);

	// chroot in the sandbox
	process_rootfs_chroot(sandbox);
	unpin_process(sandbox);

	// find the seccomp filter
	struct stat s;
	if (stat(RUN_PROTOCOL_CFG, &s) != 0) {
		printf("Cannot access seccomp filter.\n");
		exit(1);
	}

	// read and print the filter
	EUID_ROOT();
	protocol_filter_load(RUN_PROTOCOL_CFG);

	if (cfg.protocol)
		printf("%s\n", cfg.protocol);
	exit(0);
#else
	fwarning("--protocol not supported on this platform\n");
	exit(1);
#endif
}
