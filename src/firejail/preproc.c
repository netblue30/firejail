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

static int tmpfs_mounted = 0;

// build /run/firejail directory
void preproc_build_firejail_dir(void) {
	struct stat s;

	// CentOS 6 doesn't have /run directory
	if (stat(RUN_FIREJAIL_BASEDIR, &s)) {
		create_empty_dir_as_root(RUN_FIREJAIL_BASEDIR, 0755);
	}

	if (stat(RUN_FIREJAIL_DIR, &s)) {
		create_empty_dir_as_root(RUN_FIREJAIL_DIR, 0755);
	}
	
	if (stat(RUN_FIREJAIL_NETWORK_DIR, &s)) {
		create_empty_dir_as_root(RUN_FIREJAIL_NETWORK_DIR, 0755);
	}
	
	if (stat(RUN_FIREJAIL_BANDWIDTH_DIR, &s)) {
		create_empty_dir_as_root(RUN_FIREJAIL_BANDWIDTH_DIR, 0755);
	}
		
	if (stat(RUN_FIREJAIL_NAME_DIR, &s)) {
		create_empty_dir_as_root(RUN_FIREJAIL_NAME_DIR, 0755);
	}
	
	if (stat(RUN_FIREJAIL_X11_DIR, &s)) {
		create_empty_dir_as_root(RUN_FIREJAIL_X11_DIR, 0755);
	}
	
	if (stat(RUN_FIREJAIL_APPIMAGE_DIR, &s)) {
		create_empty_dir_as_root(RUN_FIREJAIL_APPIMAGE_DIR, 0755);
	}
	
	create_empty_file_as_root(RUN_RO_FILE, S_IRUSR);
	create_empty_dir_as_root(RUN_RO_DIR, S_IRUSR);
}

// build /run/firejail/mnt directory
void preproc_mount_mnt_dir(void) {
	struct stat s;
	
	// mount tmpfs on top of /run/firejail/mnt
	if (!tmpfs_mounted) {
		if (arg_debug)
			printf("Mounting tmpfs on %s directory\n", RUN_MNT_DIR);
		if (mount("tmpfs", RUN_MNT_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting /run/firejail/mnt");
		tmpfs_mounted = 1;
		fs_logger2("tmpfs", RUN_MNT_DIR);
	}
}

// grab a copy of cp command
void preproc_build_cp_command(void) {
	struct stat s;
	preproc_mount_mnt_dir();
	if (stat(RUN_CP_COMMAND, &s)) {
		char* fname = realpath("/bin/cp", NULL);
		if (fname == NULL) {
			fprintf(stderr, "Error: /bin/cp not found\n");
			exit(1);
		}
		if (stat(fname, &s)) {
			fprintf(stderr, "Error: /bin/cp not found\n");
			exit(1);
		}
		if (is_link(fname)) {
			fprintf(stderr, "Error: invalid /bin/cp file\n");
			exit(1);
		}
		int rv = copy_file(fname, RUN_CP_COMMAND, 0, 0, 0755);
		if (rv) {
			fprintf(stderr, "Error: cannot access /bin/cp\n");
			exit(1);
		}
		ASSERT_PERMS(RUN_CP_COMMAND, 0, 0, 0755);
			
		free(fname);
	}
}

// delete the temporary cp command
void preproc_delete_cp_command(void) {
	unlink(RUN_CP_COMMAND);
}
