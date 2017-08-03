/*
 * Copyright (C) 2017 Firejail Authors
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

static void duplicate(const char *fname, const char *private_run_dir) {
	if (arg_debug)
		printf("copying %s to private %s\n", fname, private_run_dir);
	sbox_run(SBOX_ROOT| SBOX_SECCOMP, 4, PATH_FCOPY, "--follow-link", fname, private_run_dir);
}

static void copy_libs(const char *exe, const char *dir, const char *file) {
	// create an empty RUN_LIB_FILE and allow the user to write to it
	unlink(file); // in case is there
	create_empty_file_as_root(file, 0644);
	if (chown(file, getuid(), getgid()))
		errExit("chown");
		
	// run fldd to extact the list of file
	sbox_run(SBOX_USER | SBOX_SECCOMP | SBOX_CAPS_NONE, 3, PATH_FLDD, exe, file);
	
	// open the list of libraries and install them on by one
	FILE *fp = fopen(file, "r");
	if (!fp)
		errExit("fopen");

#define MAXBUF 4096
	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		// remove \n
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';
		duplicate(buf, dir);		
	}
	fclose(fp);
}


void fs_private_lib(void) {
//	char *private_list = cfg.lib_private_keep;

	// create /run/firejail/mnt/lib directory
	mkdir_attr(RUN_LIB_DIR, 0755, 0, 0);

	// copy the libs in the new lib directory for the main exe
	if (cfg.original_program_index > 0)
		copy_libs(cfg.original_argv[cfg.original_program_index], RUN_LIB_DIR, RUN_LIB_FILE);

	// for the shell
	if (!arg_shell_none)
		copy_libs(cfg.shell, RUN_LIB_DIR, RUN_LIB_FILE);

#if 0 // TODO - work in progress
	// for the listed libs
	if (private_list && *private_list != '\0') {
		if (arg_debug)
			printf("Copying extra files (%s) in the new lib directory:\n", private_list);

		char *dlist = strdup(private_list);
		if (!dlist)
			errExit("strdup");

		char *ptr = strtok(dlist, ",");
		copy_libs_for_lib(ptr, RUN_LIB_DIR);

		while ((ptr = strtok(NULL, ",")) != NULL)
			copy_libs_for_lib(ptr, RUN_LIB_DIR);
		free(dlist);
		fs_logger_print();
	}
#endif

	// for our trace and tracelog libs
	if (arg_trace)
		duplicate(LIBDIR "/firejail/libtrace.so", RUN_LIB_DIR);
	else if (arg_tracelog)
		duplicate(LIBDIR "/firejail/libtracelog.so", RUN_LIB_DIR);

	if (arg_debug)
		printf("Mount-bind %s on top of /lib /lib64 /usr/lib\n", RUN_LIB_DIR);

	if (mount(RUN_LIB_DIR, "/lib", NULL, MS_BIND|MS_REC, NULL) < 0 ||
	    mount(NULL, "/lib", NULL, MS_BIND|MS_REMOUNT|MS_NOSUID|MS_NODEV|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger("mount /lib");

	if (mount(RUN_LIB_DIR, "/lib64", NULL, MS_BIND|MS_REC, NULL) < 0 ||
	    mount(NULL, "/lib64", NULL, MS_BIND|MS_REMOUNT|MS_NOSUID|MS_NODEV|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger("mount /lib64");

	if (mount(RUN_LIB_DIR, "/usr/lib", NULL, MS_BIND|MS_REC, NULL) < 0 ||
	    mount(NULL, "/usr/lib", NULL, MS_BIND|MS_REMOUNT|MS_NOSUID|MS_NODEV|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger("mount /usr/lib");
}
