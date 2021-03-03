/*
 * Copyright (C) 2014-2021 Firejail Authors
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
#include <errno.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

// spoof /etc/machine_id
void fs_machineid(void) {
	union machineid_t {
		uint8_t u8[16];
		uint32_t u32[4];
	} mid;

	// if --machine-id flag is inactive, do nothing
	if (arg_machineid == 0)
		return;
	if (arg_debug)
		printf("Generating a new machine-id\n");

	// init random number generator
	srand(time(NULL));

	// generate random id
	mid.u32[0] = rand();
	mid.u32[1] = rand();
	mid.u32[2] = rand();
	mid.u32[3] = rand();

	// UUID version 4 and DCE variant
	mid.u8[6] = (mid.u8[6] & 0x0F) | 0x40;
	mid.u8[8] = (mid.u8[8] & 0x3F) | 0x80;

	// write it in a file
	FILE *fp = fopen(RUN_MACHINEID, "w");
	if (!fp)
		errExit("fopen");
	fprintf(fp, "%08x%08x%08x%08x\n", mid.u32[0], mid.u32[1], mid.u32[2], mid.u32[3]);
	fclose(fp);
	if (set_perms(RUN_MACHINEID, 0, 0, 0444))
		errExit("set_perms");

	selinux_relabel_path(RUN_MACHINEID, "/etc/machine-id");

	struct stat s;
	if (stat("/etc/machine-id", &s) == 0) {
		if (arg_debug)
			printf("installing a new /etc/machine-id\n");

		if (mount(RUN_MACHINEID, "/etc/machine-id", "none", MS_BIND, "mode=444,gid=0"))
			errExit("mount");
	}
	if (stat("/var/lib/dbus/machine-id", &s) == 0) {
		if (mount(RUN_MACHINEID, "/var/lib/dbus/machine-id", "none", MS_BIND, "mode=444,gid=0"))
			errExit("mount");
	}
}

// return 0 if file not found, 1 if found
static int check_dir_or_file(const char *fname) {
	assert(fname);

	struct stat s;
	if (stat(fname, &s) == -1) {
		if (arg_debug)
			fwarning("file %s not found.\n", fname);
		return 0;
	}

	// read access
	if (access(fname, R_OK) == -1)
		goto errexit;

	// dir or regular file
	if (S_ISDIR(s.st_mode) || S_ISREG(s.st_mode) || !is_link(fname))
		return 1;	// normal exit

errexit:
	fprintf(stderr, "Error: invalid file type, %s.\n", fname);
	exit(1);
}

static void duplicate(const char *fname, const char *private_dir, const char *private_run_dir) {
	assert(fname);

	if (*fname == '~' || strchr(fname, '/') || strcmp(fname, "..") == 0) {
		fprintf(stderr, "Error: \"%s\" is an invalid filename\n", fname);
		exit(1);
	}
	invalid_filename(fname, 0); // no globbing

	char *src;
	if (asprintf(&src,  "%s/%s", private_dir, fname) == -1)
		errExit("asprintf");
	if (check_dir_or_file(src) == 0) {
		fwarning("skipping %s for private %s\n", fname, private_dir);
		free(src);
		return;
	}

	if (arg_debug)
		printf("copying %s to private %s\n", src, private_dir);

	struct stat s;
	if (stat(src, &s) == 0 && S_ISDIR(s.st_mode)) {
		// create the directory in RUN_ETC_DIR
		char *dirname;
		if (asprintf(&dirname, "%s/%s", private_run_dir, fname) == -1)
			errExit("asprintf");
		create_empty_dir_as_root(dirname, s.st_mode);
		sbox_run(SBOX_ROOT| SBOX_SECCOMP, 3, PATH_FCOPY, src, dirname);
		free(dirname);
	}
	else
		sbox_run(SBOX_ROOT| SBOX_SECCOMP, 3, PATH_FCOPY, src, private_run_dir);

	fs_logger2("clone", src);
	free(src);
}


void fs_private_dir_copy(const char *private_dir, const char *private_run_dir, const char *private_list) {
	assert(private_dir);
	assert(private_run_dir);
	assert(private_list);

	// nothing to do if directory does not exist
	struct stat s;
	if (stat(private_dir, &s) == -1) {
		if (arg_debug)
			printf("Cannot find %s: %s\n", private_dir, strerror(errno));
		return;
	}

	timetrace_start();

	// create /run/firejail/mnt/etc directory
	mkdir_attr(private_run_dir, 0755, 0, 0);
	selinux_relabel_path(private_run_dir, private_dir);
	fs_logger2("tmpfs", private_dir);

	fs_logger_print();	// save the current log


	// copy the list of files in the new etc directory
	// using a new child process with root privileges
	if (*private_list != '\0') {
		if (arg_debug)
			printf("Copying files in the new %s directory:\n", private_dir);

		// copy the list of files in the new home directory
		char *dlist = strdup(private_list);
		if (!dlist)
			errExit("strdup");


		char *ptr = strtok(dlist, ",");
		if (!ptr) {
			fprintf(stderr, "Error: invalid private %s argument\n", private_dir);
			exit(1);
		}
		duplicate(ptr, private_dir, private_run_dir);

		while ((ptr = strtok(NULL, ",")) != NULL)
			duplicate(ptr, private_dir, private_run_dir);
		free(dlist);
		fs_logger_print();
	}
}

void fs_private_dir_mount(const char *private_dir, const char *private_run_dir) {
	assert(private_dir);
	assert(private_run_dir);

	if (arg_debug)
		printf("Mount-bind %s on top of %s\n", private_run_dir, private_dir);

	// nothing to do if directory does not exist
	struct stat s;
	if (stat(private_dir, &s) == -1) {
		if (arg_debug)
			printf("Cannot find %s: %s\n", private_dir, strerror(errno));
		return;
	}

	if (mount(private_run_dir, private_dir, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger2("mount", private_dir);

	// mask private_run_dir (who knows if there are writable paths, and it is mounted exec)
	if (mount("tmpfs", private_run_dir, "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
		errExit("mounting tmpfs");
	fs_logger2("tmpfs", private_run_dir);

	fmessage("Private %s installed in %0.2f ms\n", private_dir, timetrace_end());
}

void fs_private_dir_list(const char *private_dir, const char *private_run_dir, const char *private_list) {
	fs_private_dir_copy(private_dir, private_run_dir, private_list);
	fs_private_dir_mount(private_dir, private_run_dir);
}
