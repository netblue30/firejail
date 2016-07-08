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
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <grp.h>
 #include <sys/wait.h>
 
void fs_mkdir(const char *name) {
	EUID_ASSERT();
	
	// check directory name
	invalid_filename(name);
	char *expanded = expand_home(name, cfg.homedir);
	if (strncmp(expanded, cfg.homedir, strlen(cfg.homedir)) != 0) {
		fprintf(stderr, "Error: only directories in user home are supported by mkdir\n");
		exit(1);
	}

	struct stat s;
	if (stat(expanded, &s) == 0) {
		// file exists, do nothing
		goto doexit;
	}

	// create directory
	if (mkdir(expanded, 0700) == -1)
		fprintf(stderr, "Warning: cannot create %s directory\n", expanded);

doexit:
	free(expanded);
}	

void fs_mkfile(const char *name) {
	EUID_ASSERT();
	
	// check file name
	invalid_filename(name);
	char *expanded = expand_home(name, cfg.homedir);
	if (strncmp(expanded, cfg.homedir, strlen(cfg.homedir)) != 0) {
		fprintf(stderr, "Error: only files in user home are supported by mkfile\n");
		exit(1);
	}

	struct stat s;
	if (stat(expanded, &s) == 0) {
		// file exists, do nothing
		goto doexit;
	}

	// create file
	FILE *fp = fopen(expanded, "w");
	if (!fp)
		fprintf(stderr, "Warning: cannot create %s file\n", expanded);
	else {
		fclose(fp);
		int rv = chown(expanded, getuid(), getgid());
		(void) rv;
		rv = chmod(expanded, 0600);
		(void) rv;
	}

doexit:
	free(expanded);
}