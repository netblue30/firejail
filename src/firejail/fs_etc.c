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
#include "firejail.h"
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

// return 0 if file not found, 1 if found
static int check_dir_or_file(const char *fname) {
	assert(fname);

	struct stat s;
	if (stat(fname, &s) == -1) {
		if (arg_debug)
			printf("Warning: file %s not found.\n", fname);
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
	if (*fname == '~' || *fname == '/' || strstr(fname, "..")) {
		fprintf(stderr, "Error: \"%s\" is an invalid filename\n", fname);
		exit(1);
	}
	invalid_filename(fname);

	char *src;
	if (asprintf(&src,  "%s/%s", private_dir, fname) == -1)
		errExit("asprintf");
	if (check_dir_or_file(src) == 0) {
		if (!arg_quiet)
			fprintf(stderr, "Warning: skipping %s for private %s\n", fname, private_dir);
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


void fs_private_dir_list(const char *private_dir, const char *private_run_dir, const char *private_list) {
	assert(private_dir);
	assert(private_run_dir);
	assert(private_list);
	
	// create /run/firejail/mnt/etc directory
	mkdir_attr(private_run_dir, 0755, 0, 0);
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
		duplicate(ptr, private_dir, private_run_dir);
	
		while ((ptr = strtok(NULL, ",")) != NULL)
			duplicate(ptr, private_dir, private_run_dir);
		free(dlist);	
		fs_logger_print();
	}
	
	if (arg_debug)
		printf("Mount-bind %s on top of %s\n", private_run_dir, private_dir);
	if (mount(private_run_dir, private_dir, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger2("mount", private_dir);
}

