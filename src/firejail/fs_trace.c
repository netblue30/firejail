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
#include "firejail.h"
#include <sys/mount.h>
#include <sys/stat.h>
#include <linux/limits.h>
#include <glob.h>
#include <dirent.h>
#include <fcntl.h>
#include <pwd.h>

void fs_trace_preload(void) {
	struct stat s;

	// create an empty /etc/ld.so.preload
	if (stat("/etc/ld.so.preload", &s)) {
		if (arg_debug)
			printf("Creating an empty /etc/ld.so.preload file\n");
		/* coverity[toctou] */
		FILE *fp = fopen("/etc/ld.so.preload", "w");
		if (!fp)
			errExit("fopen");
		fclose(fp);
		if (chown("/etc/ld.so.preload", 0, 0) < 0)
			errExit("chown");
		if (chmod("/etc/ld.so.preload", S_IRUSR | S_IWRITE | S_IRGRP | S_IROTH ) < 0)
			errExit("chmod");
	}
}

void fs_trace(void) {
	// create /tmp/firejail/mnt directory
	fs_build_mnt_dir();
	
	// create the new ld.so.preload file and mount-bind it
	if (arg_debug)
		printf("Create the new ld.so.preload file\n");

	FILE *fp = fopen(LDPRELOAD_FILE, "w");
	if (!fp)
		errExit("fopen");
	fprintf(fp, "%s/firejail/libtrace.so\n", LIBDIR);
	fclose(fp);
	if (chown(LDPRELOAD_FILE, 0, 0) < 0)
		errExit("chown");
	if (chmod(LDPRELOAD_FILE, S_IRUSR | S_IWRITE | S_IRGRP | S_IROTH ) < 0)
		errExit("chmod");
	
	// mount the new preload file
	if (arg_debug)
		printf("Mount the new ld.so.preload file\n");
	if (mount(LDPRELOAD_FILE, "/etc/ld.so.preload", NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind ls.so.preload");
}

		
	