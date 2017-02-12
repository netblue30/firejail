/*
 * Copyright (C) 2014-2017 Firejail Authors
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
	"/usr/local/bin",
	"/usr/bin",
	"/bin",
	"/usr/games",
	"/usr/local/games",
	"/usr/local/sbin",
	"/usr/sbin",
	"/sbin",
	NULL
};

// return 1 if found, 0 if not found
static char *check_dir_or_file(const char *name) {
	assert(name);
	
	struct stat s;
	char *fname = NULL;
	
	int i = 0;
	while (paths[i]) {
		// private-bin-no-local can be disabled in /etc/firejail/firejail.config
		if (checkcfg(CFG_PRIVATE_BIN_NO_LOCAL) && strstr(paths[i], "local/")) {
			i++;
			continue;
		}
		
		// check file		
		if (asprintf(&fname, "%s/%s", paths[i], name) == -1)
			errExit("asprintf");
		if (arg_debug)
			printf("Checking %s/%s\n", paths[i], name);		
		if (stat(fname, &s) == 0 && !S_ISDIR(s.st_mode)) { // do not allow directories
			// check symlink to firejail executable in /usr/local/bin
			if (strcmp(paths[i], "/usr/local/bin") == 0 && is_link(fname)) {
				/* coverity[toctou] */
				char *actual_path = realpath(fname, NULL);
				if (actual_path) {
					char *ptr = strstr(actual_path, "/firejail");
					if (ptr && strlen(ptr) == strlen("/firejail")) {
						if (arg_debug)
							printf("firejail exec symlink detected\n");
						free(actual_path);
						free(fname);
						fname = NULL;
						i++;
						continue;
					}
					free(actual_path);
				}
				
			}		
			break; // file found
		}
		
		free(fname);
		fname = NULL;
		i++;
	}

	if (!fname) {
		if (arg_debug)
			fprintf(stderr, "Warning: file %s not found\n", name);
		return NULL;
	}
	
	free(fname);
	return paths[i];
}

static void duplicate(char *fname) {
	if (*fname == '~' || *fname == '/' || strstr(fname, "..")) {
		fprintf(stderr, "Error: \"%s\" is an invalid filename\n", fname);
		exit(1);
	}
	invalid_filename(fname);

	char *path = check_dir_or_file(fname);
	if (!path)
		return;

	// expand path, just in case this is a symbolic link
	char *full_path;
	if (asprintf(&full_path, "%s/%s", path, fname) == -1)
		errExit("asprintf");
	
	// copy the file
	sbox_run(SBOX_ROOT| SBOX_SECCOMP, 4, PATH_FCOPY, "--follow-link", full_path, RUN_BIN_DIR);
	fs_logger2("clone", fname);
	free(full_path);
}


void fs_private_bin_list(void) {
	char *private_list = cfg.bin_private_keep;
	assert(private_list);
	
	// create /run/firejail/mnt/bin directory
	mkdir_attr(RUN_BIN_DIR, 0755, 0, 0);
	
	if (arg_debug)
		printf("Copying files in the new bin directory\n");

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

	// mount-bind
	int i = 0;
	while (paths[i]) {
		struct stat s;
		if (stat(paths[i], &s) == 0) {
			if (arg_debug)
				printf("Mount-bind %s on top of %s\n", RUN_BIN_DIR, paths[i]);
			if (mount(RUN_BIN_DIR, paths[i], NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");
			fs_logger2("tmpfs", paths[i]);
			fs_logger2("mount", paths[i]);
		}
		i++;
	}
}

