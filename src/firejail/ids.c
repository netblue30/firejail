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
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


static void ids_init(void) {
	// store checksums as root in /var/lib/firejail/${USERNAME}.ids
	char *fname;
	if (asprintf(&fname, VARDIR"/%s.ids", cfg.username) == -1)
		errExit("asprintf");

	int rv = unlink(fname);
	(void) rv;
	int fd = open(fname, O_CREAT | O_TRUNC | O_WRONLY, 0600);
	if (fd < 0) {
		fprintf(stderr, "Error: cannot create %s\n", fname);
		exit(1);
	}

	// redirect output
	close(STDOUT_FILENO);
	if (dup(fd) != STDOUT_FILENO)
		errExit("dup");
	close(fd);

	sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 3, PATH_FIDS, "--init", cfg.homedir);
}

static void ids_check(void) {
	// store checksums as root in /var/lib/firejail/${USERNAME}.ids
	char *fname;
	if (asprintf(&fname, VARDIR"/%s.ids", cfg.username) == -1)
		errExit("asprintf");

	int fd = open(fname, O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "Error: cannot open %s\n", fname);
		exit(1);
	}

	// redirect input
	close(STDIN_FILENO);
	if (dup(fd) != STDIN_FILENO)
		errExit("dup");
	close(fd);

	sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP| SBOX_ALLOW_STDIN, 3, PATH_FIDS, "--check", cfg.homedir);
}

void run_ids(int argc, char **argv) {
	if (argc != 2) {
		fprintf(stderr, "Error: only one IDS command expected\n");
		exit(1);
	}

	EUID_ROOT();
	struct stat s;
	if (stat(VARDIR, &s)) // /var/lib/firejail
		create_empty_dir_as_root(VARDIR, 0700);

	if (strcmp(argv[1], "--ids-init") == 0)
		ids_init();
	else if (strcmp(argv[1], "--ids-check") == 0)
		ids_check();
	else
		fprintf(stderr, "Error: unrecognized IDS command\n");

	exit(0);
}
