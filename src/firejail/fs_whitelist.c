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
#include <fnmatch.h>
#include <glob.h>
#include <dirent.h>
#include <fcntl.h>
#include <errno.h>

static int mkpath(const char* path, mode_t mode) {
	assert(path && *path);
	
	// work on a copy of the path
	char *file_path = strdup(path);
	if (!file_path)
		errExit("strdup");
	
	char* p;
	for (p=strchr(file_path+1, '/'); p; p=strchr(p+1, '/')) {
		*p='\0';
		if (mkdir(file_path, mode)==-1) {
			if (errno != EEXIST) {
				*p='/';
				free(file_path);
				return -1;
			}
		}
		else {
// TODO: set correct directory mode and properties
		}			

		*p='/';
	}
	
	free(file_path);
	return 0;
}

static void whitelist_path(const char *path) {
	assert(path);
	
	// fname needs to start with /home/username
	if (strncmp(path, cfg.homedir, strlen(cfg.homedir))) {
		fprintf(stderr, "Error: file %s is not in user home directory, exiting...\n", path);
		exit(1);
	}

	const char *fname = path + strlen(cfg.homedir);
	if (*fname == '\0') {
		fprintf(stderr, "Error: file %s is not in user home directory, exiting...\n", path);
		exit(1);
	}
	
	char *wfile;
	if (asprintf(&wfile, "%s/%s", WHITELIST_HOME_DIR, fname) == -1)
		errExit("asprintf");

	// check if the file exists
	struct stat s;
	if (stat(wfile, &s) == 0) {
		if (arg_debug)
			printf("Whitelisting %s\n", path);
	}
	else {
		if (arg_debug) {
			fprintf(stderr, "Warning: %s is an invalid file, skipping...\n", path);
		}
		return;
	}
	
	// create the path if necessary
	mkpath(path, 0755);

	// process directory
	if (S_ISDIR(s.st_mode)) {	
		// create directory
		int rv = mkdir(path, 0755);
		if (rv == -1)
			errExit("mkdir");
		
	}
	
	// process regular file
	else {
		// create an empty file
		FILE *fp = fopen(path, "w");
		if (!fp) {
			fprintf(stderr, "Error: cannot create empty file in home directory\n");
			exit(1);
		}
		fclose(fp);
	}
	
	// set file properties
	if (chown(path, s.st_uid, s.st_gid) < 0)
		errExit("chown");
	if (chmod(path, s.st_mode) < 0)
		errExit("chmod");

	// mount
	if (mount(wfile, path, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");

	free(wfile);
}


// whitelist for /home/user directory
void fs_whitelist(void) {
	char *homedir = cfg.homedir;
	assert(homedir);
	ProfileEntry *entry = cfg.profile;
	if (!entry)
		return;
	
	// realpath function will fail with ENOENT if the file is not found
	// we need to expand the path before installing a new, empty home directory
	while (entry) {
		// handle only whitelist commands
		if (strncmp(entry->data, "whitelist ", 10)) {
			entry = entry->next;
			continue;
		}

		char *new_name = expand_home(entry->data + 10, cfg.homedir);

		assert(new_name);
		char *fname = realpath(new_name, NULL);

		// mark symbolic links
		if (is_link(new_name))
			entry->link = new_name;
		else
			free(new_name);

		if (fname) {
			// change file name in entry->data
			if (strcmp(fname, entry->data + 10) != 0) {
				char *newdata;
				if (asprintf(&newdata, "whitelist %s", fname) == -1)
					errExit("asprintf");
				entry->data = newdata;
				if (arg_debug)
					printf("Replaced whitelist path: %s\n", entry->data);
			}
						
			free(fname);
		}
		else {
			// file not found, blank the entry in the list
			if (arg_debug)
				printf("Removed whitelist path: %s\n", entry->data);
			*entry->data = '\0';
		}
		entry = entry->next;
	}
		
	// create /tmp/firejail/mnt/whome directory
	fs_build_mnt_dir();
	int rv = mkdir(WHITELIST_HOME_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
	if (rv == -1)
		errExit("mkdir");
	if (chown(WHITELIST_HOME_DIR, getuid(), getgid()) < 0)
		errExit("chown");
	if (chmod(WHITELIST_HOME_DIR, 0755) < 0)
		errExit("chmod");

	// keep a copy of real home dir in /tmp/firejail/mnt/whome
	if (mount(cfg.homedir, WHITELIST_HOME_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");

	// start building the new home directory by mounting a tmpfs fielsystem
	 fs_private();

	// go through profile rules again, and interpret whitelist commands
	entry = cfg.profile;
	while (entry) {
		// handle only whitelist commands
		if (strncmp(entry->data, "whitelist ", 10)) {
			entry = entry->next;
			continue;
		}

		// whitelist the real file
		whitelist_path(entry->data + 10);

		// create the link if any
		if (entry->link) {
			// if the link is already there, do not bother
			struct stat s;
			if (stat(entry->link, &s) != 0) {
				int rv = symlink(entry->data + 10, entry->link);
				if (rv)
					fprintf(stderr, "Warning cannot create symbolic link %s\n", entry->link);
				else if (arg_debug)
					printf("Created symbolic link %s -> %s\n", entry->link, entry->data + 10);
			}
		}

		entry = entry->next;
	}

	// mask the real home directory, currently mounted on /tmp/firejail/mnt/whome
	if (mount("tmpfs", WHITELIST_HOME_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
		errExit("mount tmpfs");
}
