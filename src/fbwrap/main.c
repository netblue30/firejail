/*
 * Copyright (C) 2014-2026 Firejail Authors
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
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>
#include <linux/prctl.h>
#include <sys/prctl.h>
#include <signal.h>

// enable debug messages
//#define DEBUG

// checking the file is in the regular executable path or in /usr/lib*
// fname: full path required!!!
static int check_env_path(const char *fname) {
#ifdef DEBUG
	printf("%s:%s():%d %s\n", __FILE__, __PRETTY_FUNCTION__, __LINE__, fname);
#endif
	if (strncmp(fname, "/usr/lib", 8) == 0)
		return 0;

	const char *path1 = secure_getenv("PATH");
	if (path1) {
		char *path2 = strdup(path1);
		if (!path2) {
			fprintf(stderr, "Error: strdup failed in fbwrap\n");
			return 1;
		}

		// use path2 to count the entries
		char *ptr = strtok(path2, ":");
		while (ptr) {
			if (strncmp(fname, ptr, strlen(ptr)) == 0) {
				free(path2);
				printf("Info: full path provided for %s\n", fname);
				return 0;
			}
			ptr = strtok(NULL, ":");
		}
		free(path2);
	}

	return 1;
}

// fname: full path required!!!
static int ok_to_run(const char *fname) {
#ifdef DEBUG
	printf("%s:%s():%d %s\n", __FILE__, __PRETTY_FUNCTION__, __LINE__, fname);
#endif
	if (check_env_path(fname))
		return 0;

	struct stat s;
	int rv = stat(fname, &s);
	if (rv == 0 && S_ISREG(s.st_mode) && access(fname, X_OK) == 0)
		return 1;

	return 0;
}

static void usage(void) {
	printf("fbwrap - bwrap replacement for Firejail sandbox.\n"
	       "This program does nothing! It just starts the application\n"
	       "bwrap was supposed to sandbox, without any sandboxing features.\n"
	       "\n"
	       "fbwrap is installed automatically inside Firejail sandbox\n"
	       "replacing the real bwrap. The real bwrap is still available\n"
	       "outside the sandbox.\n\n");
}


int main(int argc, char **argv) {
	int i;
#ifdef DEBUG
	printf("%s:%s():%d\n", __FILE__, __PRETTY_FUNCTION__, __LINE__);
#endif
	if (argc == 1) {
		usage();
		return 1;
	}

	if (strcmp(argv[1], "-h") == 0 ||
	    strcmp(argv[1], "-?") == 0 ||
	    strcmp(argv[1], "-v") == 0 ||
	    strcmp(argv[1], "--help") == 0 ||
	    strcmp(argv[1], "--version") == 0) {
		usage();
		return 0;
	}

	for (i = 1; i < argc; i++) {
#ifdef DEBUG
		printf("%s:%s():%d %s\n", __FILE__, __PRETTY_FUNCTION__, __LINE__, argv[i]);
#endif
		if (*argv[i] != '/') // enforcing $(PATH) for our target
			continue;
		if (ok_to_run(argv[i])) {
			fprintf(stderr, "Info: fbwrap target program %s found\n", argv[i]);
			break;
		}
	}

	if (i == argc) {
		fprintf(stderr, "Error: fbwrap target program not found. Please use a full path for your target.\n");
		usage();
		exit(1);
	}

	#define MAX_ARGLIST 64
	char *arglist[MAX_ARGLIST] = {NULL};
	int j;
	for (j = 0; i < argc && j < MAX_ARGLIST; i++, j++)
		arglist[j] = argv[i];
	if (j >= (MAX_ARGLIST - 1)) {
		fprintf(stderr, "Error: fbwrap target program has an argument list larger than %d\n", MAX_ARGLIST - 1);
		exit(1);
	}

	pid_t child = fork();
	if (child == -1) {
		fprintf(stderr, "Error: fbwrap cannot fork\n");
		exit(1);
	}
	if (child == 0) {
		// kill the target if the parent dies
		prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
		execvp(arglist[0], arglist);
		return 0;
	}

	// wait child to finish
	//int status;
	//waitpid(child, &status, 0);

	// don't bother waiting
	sleep(2);

	return 0;
}
