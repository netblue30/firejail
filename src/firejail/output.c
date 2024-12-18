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
#include <unistd.h>

#ifdef HAVE_OUTPUT
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

	drop_privs(0);
	char *outfile = argv[outindex];
	outfile += (enable_stderr)? 16:9;

	// check filename
	invalid_filename(outfile, 0); // no globbing

	// expand user home directory
	if (outfile[0] == '~') {
		char *full;
		if (asprintf(&full, "%s%s", cfg.homedir, outfile + 1) == -1)
			errExit("asprintf");
		outfile = full;
	}

	// do not accept directories, links, and files with ".."
	if (strstr(outfile, "..") || is_link(outfile) || is_dir(outfile) || has_cntrl_chars(outfile)) {
		fprintf(stderr, "Error: invalid output file. Links, directories, files with \"..\" and control characters in filenames are not allowed.\n");
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

	int pipefd[2];
	if (pipe(pipefd) == -1) {
		errExit("pipe");
	}

	pid_t pid = fork();
	if (pid == -1) {
		errExit("fork");
	} else if (pid == 0) {
		/* child */
		if (dup2(pipefd[0], STDIN_FILENO) == -1) {
			errExit("dup2");
		}
		close(pipefd[1]);
		if (pipefd[0] != STDIN_FILENO) {
			close(pipefd[0]);
		}

		// restore some environment variables
		env_apply_whitelist_sbox();

		char *args[3];
		args[0] = LIBDIR "/firejail/ftee";
		args[1] = outfile;
		args[2] = NULL;
		execv(args[0], args);
		perror("execvp");
		exit(1);
	}

	/* parent */
	if (dup2(pipefd[1], STDOUT_FILENO) == -1) {
		errExit("dup2");
	}
	if (enable_stderr && dup2(STDOUT_FILENO, STDERR_FILENO) == -1) {
		errExit("dup2");
	}
	close(pipefd[0]);
	if (pipefd[1] != STDOUT_FILENO) {
		close(pipefd[1]);
	}

	char **args = calloc(argc + 1, sizeof(char *));
	if (!args) {
		errExit("calloc");
	}
	bool found_separator = false;
	/* copy argv into args, but drop --output(-stderr) arguments */
	int j;
	for (i = 0, j = 0; i < argc; i++) {
		if (!found_separator && i > 0) {
			if (strncmp(argv[i], "--output=", 9) == 0) {
				continue;
			}
			if (strncmp(argv[i], "--output-stderr=", 16) == 0) {
				continue;
			}
			if (strncmp(argv[i], "--", 2) != 0 || strcmp(argv[i], "--") == 0) {
				found_separator = true;
			}
		}
		args[j++] = argv[i];
	}

	// restore original environment variables
	env_apply_all();

	execvp(args[0], args);

	perror("execvp");
	exit(1);
}
#endif
