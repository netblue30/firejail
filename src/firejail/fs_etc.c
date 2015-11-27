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
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static void check_dir_or_file(const char *name) {
	assert(name);
	invalid_filename(name);
	
	struct stat s;
	char *fname;
	if (asprintf(&fname, "/etc/%s", name) == -1)
		errExit("asprintf");
	if (arg_debug)
		printf("Checking %s\n", fname);		
	if (stat(fname, &s) == -1) {
		fprintf(stderr, "Error: file %s not found.\n", fname);
		exit(1);
	}
	
	// dir or regular file
	if (S_ISDIR(s.st_mode) || S_ISREG(s.st_mode)) {
		free(fname);
		return;
	}

	if (!is_link(fname)) {
		free(fname);
		return;
	}
	
	fprintf(stderr, "Error: invalid file type, %s.\n", fname);
	exit(1);
}

void fs_check_etc_list(void) {
	if (strstr(cfg.etc_private_keep, "..")) {
		fprintf(stderr, "Error: invalid private etc list\n");
		exit(1);
	}
	
	char *dlist = strdup(cfg.etc_private_keep);
	if (!dlist)
		errExit("strdup");

	char *ptr = strtok(dlist, ",");
	check_dir_or_file(ptr);
	while ((ptr = strtok(NULL, ",")) != NULL)
		check_dir_or_file(ptr);
	
	free(dlist);
}

static void duplicate(char *fname) {
	char *cmd;

	// copy the file - this code assumes ETC_DIR is actually MNT_DIR/etc
	if (asprintf(&cmd, "%s -a --parents /etc/%s %s", RUN_CP_COMMAND, fname, RUN_MNT_DIR) == -1)
		errExit("asprintf");
	if (arg_debug)
		printf("%s\n", cmd);
	if (system(cmd))
		errExit("system cp -a --parents");
	free(cmd);
	fs_logger2("clone", fname);
}


void fs_private_etc_list(void) {
	char *private_list = cfg.etc_private_keep;
	assert(private_list);
	
	struct stat s;
	if (stat("/etc", &s) == -1) {
		fprintf(stderr, "Error: cannot find user /etc directory\n");
		exit(1);
	}

	// create /tmp/firejail/mnt/etc directory
	fs_build_mnt_dir();
	int rv = mkdir(RUN_ETC_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
	if (rv == -1)
		errExit("mkdir");
	if (chown(RUN_ETC_DIR, 0, 0) < 0)
		errExit("chown");
	if (chmod(RUN_ETC_DIR, 0755) < 0)
		errExit("chmod");
	
	// copy the list of files in the new etc directory
	// using a new child process without root privileges
	fs_logger_print();	// save the current log
	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		if (arg_debug)
			printf("Copying files in the new etc directory:\n");

		// elevate privileges - files in the new /etc directory belong to root
		if (setreuid(0, 0) < 0)
			errExit("setreuid");
		if (setregid(0, 0) < 0)
			errExit("setregid");
		
		// copy the list of files in the new home directory
		char *dlist = strdup(private_list);
		if (!dlist)
			errExit("strdup");
	

		char *ptr = strtok(dlist, ",");
		duplicate(ptr);
	
		while ((ptr = strtok(NULL, ",")) != NULL)
			duplicate(ptr);
		free(dlist);	
		fs_logger_print();
		exit(0);
	}
	// wait for the child to finish
	waitpid(child, NULL, 0);

	if (arg_debug)
		printf("Mount-bind %s on top of /etc\n", RUN_ETC_DIR);
	if (mount(RUN_ETC_DIR, "/etc", NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger("mount /etc");
}

