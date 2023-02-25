/*
 * Copyright (C) 2014-2023 Firejail Authors
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
#include <sys/mount.h>
#include <sys/stat.h>
#include <glob.h>
#include <dirent.h>
#include <fcntl.h>

void fs_hostname(const char *hostname) {
	struct stat s;

	// create a new /etc/hostname
	if (stat("/etc/hostname", &s) == 0) {
		if (arg_debug)
			printf("Creating a new /etc/hostname file\n");

		create_empty_file_as_root(RUN_HOSTNAME_FILE, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);

		// bind-mount the file on top of /etc/hostname
		if (mount(RUN_HOSTNAME_FILE, "/etc/hostname", NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind /etc/hostname");
		fs_logger("create /etc/hostname");
	}

	// create a new /etc/hosts
	if (cfg.hosts_file == NULL && stat("/etc/hosts", &s) == 0) {
		if (arg_debug)
			printf("Creating a new /etc/hosts file\n");
		// copy /etc/host into our new file, and modify it on the fly
		/* coverity[toctou] */
		FILE *fp1 = fopen("/etc/hosts", "re");
		if (!fp1)
			goto errexit;

		FILE *fp2 = fopen(RUN_HOSTS_FILE, "we");
		if (!fp2) {
			fclose(fp1);
			goto errexit;
		}

		char buf[4096];
		int done = 0;
		while (fgets(buf, sizeof(buf), fp1)) {
			// remove '\n'
			char *ptr = strchr(buf, '\n');
			if (ptr)
				*ptr = '\0';

			// copy line
			if (strstr(buf, "127.0.0.1") && done == 0) {
				done = 1;
				fprintf(fp2, "%s %s\n", buf, hostname);
			}
			else
				fprintf(fp2, "%s\n", buf);
		}
		fclose(fp1);
		// mode and owner
		SET_PERMS_STREAM(fp2, 0, 0, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
		fclose(fp2);

		// bind-mount the file on top of /etc/hostname
		fs_mount_hosts_file();
	}
	return;

errexit:
	fprintf(stderr, "Error: cannot create hostname file\n");
	exit(1);
}

char *fs_check_hosts_file(const char *fname) {
	assert(fname);
	invalid_filename(fname, 0); // no globbing
	char *rv = expand_macros(fname);

	// the user has read access to the file
	if (access(rv, R_OK))
		goto errexit;

	return rv;
errexit:
	fprintf(stderr, "Error: invalid file %s\n", fname);
	exit(1);
}

void fs_store_hosts_file(void) {
	copy_file_from_user_to_root(cfg.hosts_file, RUN_HOSTS_FILE, 0, 0, 0644); // root needed
}

void fs_mount_hosts_file(void) {
	if (arg_debug)
		printf("Loading user hosts file\n");

	// check /etc/hosts file
	struct stat s;
	if (stat("/etc/hosts", &s) == -1)
		goto errexit;
	// owned by root
	if (s.st_uid != 0)
		goto errexit;

	// bind-mount the file on top of /etc/hostname
	if (mount(RUN_HOSTS_FILE, "/etc/hosts", NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind /etc/hosts");
	fs_logger("create /etc/hosts");
	return;

errexit:
	fprintf(stderr, "Error: invalid /etc/hosts file\n");
	exit(1);
}
