/*
 * Copyright (C) 2014-2024 Firejail Authors
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
#include <glob.h>

static int prog_cnt = 0;

static const char * const paths[] = {
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
static const char *check_dir_or_file(const char *name) {
	EUID_ASSERT();
	assert(name);
	struct stat s;

	int i = 0;
	while (paths[i]) {
		// private-bin-no-local can be disabled in /etc/firejail/firejail.config
		if (checkcfg(CFG_PRIVATE_BIN_NO_LOCAL) && strstr(paths[i], "local/")) {
			i++;
			continue;
		}

		// check file
		char *fname;
		if (asprintf(&fname, "%s/%s", paths[i], name) == -1)
			errExit("asprintf");
		if (arg_debug)
			printf("Checking %s/%s\n", paths[i], name);
		if (stat(fname, &s) == 0 &&
		    !S_ISDIR(s.st_mode) &&	// do not allow directories
		    !is_firejail_link(fname)) {	// skip symlinks to firejail executable, as created by firecfg
			free(fname);
			break; // file found
		}

		free(fname);
		i++;
	}

	if (!paths[i]) {
		if (arg_debug)
			fwarning("file %s not found\n", name);
		return NULL;
	}

	return paths[i];
}

// return 1 if the file is in paths[]
static int valid_full_path_file(const char *name) {
	EUID_ASSERT();
	assert(name);

	if (*name != '/')
		return 0;
	if (strstr(name, ".."))
		return 0;

	// do we have a file?
	struct stat s;
	if (stat(name, &s) == -1)
		return 0;
	// directories not allowed
	if (S_ISDIR(s.st_mode))
		return 0;
	// checking access
	if (access(name, X_OK) == -1)
		return 0;

	// check standard paths
	int i = 0;
	while (paths[i]) {
		// private-bin-no-local can be disabled in /etc/firejail/firejail.config
		if (checkcfg(CFG_PRIVATE_BIN_NO_LOCAL) && strstr(paths[i], "local/")) {
			i++;
			continue;
		}

		int len = strlen(paths[i]);
		if (strncmp(name, paths[i], len) == 0 && name[len] == '/' && name[len + 1] != '\0')
			return 1;
		i++;
	}
	if (arg_debug)
		printf("file %s not found\n", name);
	return 0;
}

static void report_duplication(const char *fname) {
	// report the file on all bin paths
	int i = 0;
	while (paths[i]) {
		char *p;
		if (asprintf(&p, "%s/%s", paths[i], fname) == -1)
			errExit("asprintf");
		fs_logger2("clone", p);
		free(p);
		i++;
	}
}

static void duplicate(char *fname) {
	EUID_ASSERT();
	assert(fname);

	if (*fname == '~' || strstr(fname, "..")) {
		fprintf(stderr, "Error: \"%s\" is an invalid filename\n", fname);
		exit(1);
	}
	invalid_filename(fname, 0); // no globbing

	char *full_path;
	if (*fname == '/') {
		// If the absolute filename is indicated, directly use it. This
		// is required for the following cases:
		//  - if user's $PATH order is not the same as the above
		//    paths[] variable order
		if (!valid_full_path_file(fname)) {
			fwarning("invalid private-bin path %s\n", fname);
			return;
		}

		full_path = strdup(fname);
		if (!full_path)
			errExit("strdup");
	}
	else {
		// Find the standard directory (by looping through paths[])
		// where the filename fname is located
		const char *path = check_dir_or_file(fname);
		if (!path)
			return;
		if (asprintf(&full_path, "%s/%s", path, fname) == -1)
			errExit("asprintf");
	}

	// add to private-lib list
	if (cfg.bin_private_lib == NULL) {
		if (asprintf(&cfg.bin_private_lib, "%s,%s",fname, full_path) == -1)
			errExit("asprintf");
	}
	else {
		char *tmp;
		if (asprintf(&tmp, "%s,%s,%s", cfg.bin_private_lib, fname, full_path) == -1)
			errExit("asprintf");
		free(cfg.bin_private_lib);
		cfg.bin_private_lib = tmp;
	}

	// if full_path is symlink, and the link is in our path, copy both the file and the symlink
	if (is_link(full_path)) {
		char *actual_path = realpath(full_path, NULL);
		if (actual_path) {
			if (valid_full_path_file(actual_path)) {
				// solving problems such as /bin/sh -> /bin/dash
				// copy the real file pointed by symlink
				sbox_run(SBOX_ROOT| SBOX_SECCOMP, 3, PATH_FCOPY, actual_path, RUN_BIN_DIR);
				prog_cnt++;
				char *f = strrchr(actual_path, '/');
				if (f && *(++f) !='\0')
					report_duplication(f);
			}
			free(actual_path);
		}
	}

	// copy a file or a symlink
	sbox_run(SBOX_ROOT| SBOX_SECCOMP, 3, PATH_FCOPY, full_path, RUN_BIN_DIR);
	prog_cnt++;
	free(full_path);
	report_duplication(fname);
}

static void globbing(char *fname) {
	EUID_ASSERT();
	assert(fname);

	// go directly to duplicate() if no globbing char is present - see man 7 glob
	if (strrchr(fname, '*') == NULL &&
	    strrchr(fname, '[') == NULL &&
	    strrchr(fname, '?') == NULL)
		return duplicate(fname);

	// loop through paths[]
	int i = 0;
	while (paths[i]) {
		// private-bin-no-local can be disabled in /etc/firejail/firejail.config
		if (checkcfg(CFG_PRIVATE_BIN_NO_LOCAL) && strstr(paths[i], "local/")) {
			i++;
			continue;
		}

		// check file
		char *pattern;
		if (asprintf(&pattern, "%s/%s", paths[i], fname) == -1)
			errExit("asprintf");

		// globbing
		glob_t globbuf;
		int globerr = glob(pattern, GLOB_NOCHECK | GLOB_NOSORT | GLOB_PERIOD, NULL, &globbuf);
		if (globerr) {
			fprintf(stderr, "Error: failed to glob private-bin pattern %s\n", pattern);
			exit(1);
		}

		size_t j;
		for (j = 0; j < globbuf.gl_pathc; j++) {
			assert(globbuf.gl_pathv[j]);
			// testing for GLOB_NOCHECK - no pattern matched returns the original pattern
			if (strcmp(globbuf.gl_pathv[j], pattern) == 0)
				continue;
			// skip symlinks to firejail executable, as created by firecfg
			if (is_firejail_link(globbuf.gl_pathv[j]))
				continue;

			duplicate(globbuf.gl_pathv[j]);
		}

		globfree(&globbuf);
		free(pattern);
		i++;
	}
}

void fs_private_bin_list(void) {
	EUID_ASSERT();
	char *private_list = cfg.bin_private_keep;
	assert(private_list);

	// start timetrace
	timetrace_start();

	// create /run/firejail/mnt/bin directory
	EUID_ROOT();
	mkdir_attr(RUN_BIN_DIR, 0755, 0, 0);
	EUID_USER();

	if (arg_debug)
		printf("Copying files in the new bin directory\n");

	// copy the list of files in the new home directory
	char *dlist = strdup(private_list);
	if (!dlist)
		errExit("strdup");

	char *ptr = strtok(dlist, ",");
	if (!ptr) {
		fprintf(stderr, "Error: invalid private-bin argument\n");
		exit(1);
	}
	globbing(ptr);
	while ((ptr = strtok(NULL, ",")) != NULL)
		globbing(ptr);
	free(dlist);

	// mount-bind
	EUID_ROOT();
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
	fs_logger_print();
	EUID_USER();

	selinux_relabel_path(RUN_BIN_DIR, "/bin");
	fmessage("%d %s installed in %0.2f ms\n", prog_cnt, (prog_cnt == 1)? "program": "programs", timetrace_end());
}
