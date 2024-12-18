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
#include "ftee.h"
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#define MAXBUF 512

static unsigned char buf[MAXBUF];

static FILE *out_fp = NULL;
static int out_cnt = 0;
static int out_max = 500 * 1024;

static void log_close(void) {
	if (out_fp) {
		fclose(out_fp);
		out_fp = NULL;
	}
}

static void log_rotate(const char *fname) {
	struct stat s;
	int index = strlen(fname);
	char *name1 = malloc(index + 2 + 1);
	char *name2 = malloc(index + 2 + 1);
	if (!name1 || !name2)
		errExit("malloc");
	strcpy(name1, fname);
	strcpy(name2, fname);
	fflush(0);

	// delete filename.5
	sprintf(name1 + index, ".5");
	if (stat(name1, &s) == 0) {
		int rv = unlink(name1);
		if (rv == -1)
			perror("unlink");
	}

	// move files 1 to 4 down one position
	sprintf(name2 + index, ".4");
	if (stat(name2, &s) == 0) {
		int rv = rename(name2, name1);
		if (rv == -1)
			perror("rename");
	}

	sprintf(name1 + index, ".3");
	if (stat(name1, &s) == 0) {
		int rv = rename(name1, name2);
		if (rv == -1)
			perror("rename");
	}

	sprintf(name2 + index, ".2");
	if (stat(name2, &s) == 0) {
		/* coverity[toctou] */
		int rv = rename(name2, name1);
		if (rv == -1)
			perror("rename");
	}

	sprintf(name1 + index, ".1");
	if (stat(name1, &s) == 0) {
		int rv = rename(name1, name2);
		if (rv == -1)
			perror("rename");
	}

	// move the first file
	if (out_fp)
		fclose(out_fp);

	out_fp = NULL;
	if (stat(fname, &s) == 0) {
		int rv = rename(fname, name1);
		if (rv == -1)
			perror("rename");
	}

	free(name1);
	free(name2);
}

static void log_write(const unsigned char *str, int len, const char *fname) {
	assert(fname);

	if (out_fp == NULL) {
		out_fp = fopen(fname, "w");
		if (!out_fp) {
			fprintf(stderr, "Error: cannot open log file %s\n", fname);
			exit(1);
		}
		out_cnt = 0;
	}

	// rotate files
	out_cnt += len;
	if (out_cnt >= out_max) {
		log_rotate(fname);

		// reopen the first file
		if (out_fp)
			fclose(out_fp);
		out_fp = fopen(fname, "w");
		if (!out_fp) {
			fprintf(stderr, "Error: cannot open log file %s\n", fname);
			exit(1);
		}
		out_cnt = len;
	}

	int rv = fwrite(str, len, 1, out_fp);
	(void) rv;
	fflush(0);
}


// return 1 if the file is a directory
static int is_dir(const char *fname) {
	assert(fname);
	if (*fname == '\0')
		return 0;

	// if fname doesn't end in '/', add one
	int rv;
	struct stat s;
	if (fname[strlen(fname) - 1] == '/')
		rv = stat(fname, &s);
	else {
		char *tmp;
		if (asprintf(&tmp, "%s/", fname) == -1)
			errExit("asprintf");
		rv = stat(tmp, &s);
		free(tmp);
	}

	if (rv == -1)
		return 0;

	if (S_ISDIR(s.st_mode))
		return 1;

	return 0;
}

// return 1 if the file is a link
static int is_link(const char *fname) {
	assert(fname);
	if (*fname == '\0')
		return 0;

	struct stat s;
	if (lstat(fname, &s) == 0) {
		if (S_ISLNK(s.st_mode))
			return 1;
	}

	return 0;
}

static const char *const usage_str =
	"Usage: ftee filename\n";

static void usage(void) {
	puts(usage_str);
}

int main(int argc, char **argv) {
	if (argc < 2) {
		fprintf(stderr, "Error: please provide a filename to store the program output\n");
		usage();
		exit(1);
	}
	if (strcmp(argv[1], "--help") == 0) {
		usage();
		return 0;
	}
	char *fname = argv[1];


	// do not accept directories, links, and files with ".."
	if (strstr(fname, "..") || is_link(fname) || is_dir(fname))
		goto errexit;

	struct stat s;
	if (stat(fname, &s) == 0) {
		// check permissions
		if (s.st_uid != getuid() || s.st_gid != getgid())
			goto errexit;

		// check hard links
		if (s.st_nlink != 1)
			goto errexit;
	}

	// check if we can append to this file
	/* coverity[toctou] */
	FILE *fp = fopen(fname, "a");
	if (!fp)
		goto errexit;
	fclose(fp);


	// preserve the last log file
	log_rotate(fname);

	setvbuf (stdout, NULL, _IONBF, 0);
	while(1) {
		int n = read(0, buf, sizeof(buf));
		if (n < 0 && errno == EINTR)
			continue;
		if (n <= 0)
			break;

		int rv = fwrite(buf, n, 1, stdout);
		(void) rv;
		log_write(buf, n, fname);
	}

	log_close();
	return 0;

errexit:
	fprintf(stderr, "Error ftee: invalid output file.\n");
	return 1;
}
