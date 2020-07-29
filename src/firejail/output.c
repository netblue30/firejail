/*
 * Copyright (C) 2014-2020 Firejail Authors
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

void check_output(int argc, char **argv) {
	EUID_ASSERT();

	int i;
	int outindex = 0;
	int enable_stderr = 0;

	for (i = 1; i < argc; i++) {
		if (strncmp(argv[i], "--", 2) != 0) {
			return;
		}
		if (strcmp(argv[i], "--") == 0) {
			return;
		}
		if (strncmp(argv[i], "--output=", 9) == 0) {
			outindex = i;
			break;
		}
		if (strncmp(argv[i], "--output-stderr=", 16) == 0) {
			outindex = i;
			enable_stderr = 1;
			break;
		}
	}
	if (!outindex)
		return;


	// check filename
	drop_privs(0);
	char *outfile = argv[outindex];
	outfile += (enable_stderr)? 16:9;
	invalid_filename(outfile, 0); // no globbing

	// do not accept directories, links, and files with ".."
	if (strstr(outfile, "..") || is_link(outfile) || is_dir(outfile)) {
		fprintf(stderr, "Error: invalid output file. Links, directories and files with \"..\" are not allowed.\n");
		exit(1);
	}

	struct stat s;
	if (stat(outfile, &s) == 0) {
		// check permissions
		if (s.st_uid != getuid() || s.st_gid != getgid()) {
			fprintf(stderr, "Error: the output file needs to be owned by the current user.\n");
			exit(1);
		}

		// check hard links
		if (s.st_nlink != 1) {
			fprintf(stderr, "Error: no hard links allowed.\n");
			exit(1);
		}
	}

	// build the new command line
	int len = 0;
	for (i = 0; i < argc; i++) {
		len += strlen(argv[i]) + 1; // + ' '
	}
	len += 100 + strlen(LIBDIR) + strlen(outfile); // tee command

	char *cmd = malloc(len + 1); // + '\0'
	if (!cmd)
		errExit("malloc");

	char *ptr = cmd;
	for (i = 0; i < argc; i++) {
		if (strncmp(argv[i], "--output=", 9) == 0)
			continue;
		if (strncmp(argv[i], "--output-stderr=", 16) == 0)
			continue;
		ptr += sprintf(ptr, "%s ", argv[i]);
	}

	if (enable_stderr)
		sprintf(ptr, "2>&1 | %s/firejail/ftee %s", LIBDIR, outfile);
	else
		sprintf(ptr, " | %s/firejail/ftee %s", LIBDIR, outfile);

	// run command
	char *a[4];
	a[0] = "/bin/bash";
	a[1] = "-c";
	a[2] = cmd;
	a[3] = NULL;
	execvp(a[0], a);

	perror("execvp");
	exit(1);
}
