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
#include <sys/wait.h>
#include <unistd.h>

static char *paths[] = {
	"/bin",
	"/sbin",
	"/usr/bin",
	"/usr/sbin",
	NULL
};

// return 1 if found, 0 if not found
static char *check_dir_or_file(const char *name) {
	assert(name);
	invalid_filename(name);
	
	struct stat s;
	char *fname = NULL;
	
	int i = 0;
	while (paths[i]) {
		if (asprintf(&fname, "%s/%s", paths[i], name) == -1)
			errExit("asprintf");
		if (arg_debug)
			printf("Checking %s/%s\n", paths[i], name);		
		if (stat(fname, &s) == 0 && !S_ISDIR(s.st_mode)) // do not allow directories
			break; // file found
		
		free(fname);
		fname = NULL;
		i++;
	}

	if (!fname) {
//		fprintf(stderr, "Warning: file %s not found\n", name);
		return NULL;
	}
	
	free(fname);
	return paths[i];
}

void fs_check_bin_list(void) {
	if (strstr(cfg.bin_private_keep, "..")) {
		fprintf(stderr, "Error: invalid private bin list\n");
		exit(1);
	}
	
	char *dlist = strdup(cfg.bin_private_keep);
	if (!dlist)
		errExit("strdup");

	// create a new list removing files not found
	char *newlist = malloc(strlen(dlist) + 1 + 1); // +',' + '\0'
	if (!newlist)
		errExit("malloc");
	*newlist = '\0';
	char *newlistptr = newlist;

	// check the first file
	char *ptr = strtok(dlist, ",");
	int notfound = 0;
	if (check_dir_or_file(ptr)) {
		// file found, copy the name in the new list
		strcpy(newlistptr, ptr);
		strcat(newlistptr, ",");
		newlistptr += strlen(newlistptr);
	}
	else
		notfound = 1;

	// check the rest of the list
	while ((ptr = strtok(NULL, ",")) != NULL) {
		if (check_dir_or_file(ptr)) {
			// file found, copy the name in the new list
			strcpy(newlistptr, ptr);
			strcat(newlistptr, ",");
			newlistptr += strlen(newlistptr);
		}
		else
			notfound = 1;
	}
	
	if (*newlist == '\0') {
		fprintf(stderr, "Warning: no --private-bin list executable found, option disabled\n");
		cfg.bin_private_keep = NULL;
		arg_private_bin = 0;
		free(newlist);
	}
	else {
		ptr = strrchr(newlist, ',');
		assert(ptr);
		*ptr = '\0';
		if (notfound)
			fprintf(stderr, "Warning: not all executables from --private-bin list were found. The current list is %s\n", newlist);
		
		cfg.bin_private_keep = newlist;
	}
	
	free(dlist);
}

static void duplicate(char *fname) {
	char *cmd;
	char *path = check_dir_or_file(fname);
	if (!path)
		return;
	
	// expand path, just in case this is a symbolic link
	char *full_path;
	if (asprintf(&full_path, "%s/%s", path, fname) == -1)
		errExit("asprintf");
	
	char *actual_path = realpath(full_path, NULL);
	if (actual_path) {
		// copy the file
		if (asprintf(&cmd, "%s -a %s %s/%s", RUN_CP_COMMAND, actual_path, RUN_BIN_DIR, fname) == -1)
			errExit("asprintf");
		if (arg_debug)
			printf("%s\n", cmd);
		if (system(cmd))
			errExit("system cp -a");
		fs_logger2("clone", fname);
		free(cmd);
		free(actual_path);
	}

	free(full_path);
}


void fs_private_bin_list(void) {
	char *private_list = cfg.bin_private_keep;
	assert(private_list);
	
	// check bin paths
	int i = 0;
	while (paths[i]) {
		struct stat s;
		if (stat(paths[i], &s) == -1) {
			fprintf(stderr, "Error: cannot find %s directory\n", paths[i]);
			exit(1);
		}
		i++;
	}

	// create /tmp/firejail/mnt/bin directory
	fs_build_mnt_dir();
	int rv = mkdir(RUN_BIN_DIR, 0755);
	if (rv == -1)
		errExit("mkdir");
	if (chown(RUN_BIN_DIR, 0, 0) < 0)
		errExit("chown");
	if (chmod(RUN_BIN_DIR, 0755) < 0)
		errExit("chmod");
	
	
	// copy the list of files in the new etc directory
	// using a new child process without root privileges
	fs_logger_print();	// save the current log
	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		if (arg_debug)
			printf("Copying files in the new home:\n");

		// elevate privileges - files in the new /bin directory belong to root
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

	// moun-bind
	i = 0;
	while (paths[i]) {
		if (arg_debug)
			printf("Mount-bind %s on top of %s\n", RUN_BIN_DIR, paths[i]);
		if (mount(RUN_BIN_DIR, paths[i], NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind");
		fs_logger2("mount", paths[i]);
		i++;
	}
}

