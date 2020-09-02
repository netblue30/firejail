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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define MAXBUF 4096
#define MAXMACROS 64
static char *macro[MAXMACROS] = {NULL};

static void add_macro(char *m) {
	assert(m);
	int i;
	for (i = 0; i < MAXMACROS && macro[i]; i++);
	if (i == MAXMACROS) {
		fprintf(stderr, "Error: maximum number of marcros (%d) exceeded\n", MAXMACROS);
		exit(1);
	}

	macro[i] = m;
}

static char *find_macro(char *m) {
	assert(m);
	int i = 0;
	while (i < MAXMACROS && macro[i]) {
		if (strcmp(macro[i], m) == 0)
			return m;
		i++;
	}

	return NULL;
}

static void usage(void) {
	printf("Simple preprocessor for man pages. It supports:\n");
	printf("\t#if 0 ... #endif\n");
	printf("\t#ifdef macro ... #endif\n");
	printf("Usage: preproc [--help] [-Dmacro] manpage.txt\n");
	return;
}


int main(int argc, char **argv) {
	if (argc == 1) {
		fprintf(stderr, "Error: no files/arguments provided\n");
		usage();
		exit(1);
	}

	int i;
	for (i = 1; i < argc; i++) {
		if (strncmp(argv[i], "-D", 2) == 0)
			add_macro(argv[i] + 2);
		else if (strcmp(argv[i], "--help") == 0) {
			usage();
			return 0;
		}
		else if (*argv[i] == '-') {
			fprintf(stderr, "Error: invalid argument %s\n", argv[i]);
			exit(1);
		}
		else
			break;
	}

	char *ptr = strstr(argv[i], ".txt");
	if (!ptr || strlen(ptr) != 4) {
		fprintf(stderr, "Error: input file needs to have a .txt extension\n"),
		exit(1);
	}

	FILE *fp = fopen(argv[i], "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot open %s\n", argv[i]);
		exit(1);
	}
	char *outfile = strdup(argv[i]);
	if (!outfile)
		goto errout;
	ptr = strstr(outfile, ".txt");
	assert(ptr);
	strcpy(ptr, ".man");
	FILE *fpout = fopen(outfile, "w");
	if (!fpout)
		goto errout;

	char buf[MAXBUF];
	int disabled = 0;
	int enabled = 0;
	int line = 0;;
	while (fgets(buf, MAXBUF, fp)) {
		line++;
		if (disabled && strncmp(buf, "#if", 3) == 0) {
			fprintf(stderr, "Error %d: already in a #if block on line %d\n", __LINE__, line);
			exit(1);
		}
		if ((!disabled && !enabled) && strncmp(buf, "#endif", 6) == 0) {
			fprintf(stderr, "Error %d: unmatched #endif on line %d\n", __LINE__, line);
			exit(1);
		}

		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';

		if (strncmp(buf, "#if 0", 5) == 0) {
			disabled = 1;
			continue;
		}
		if (strncmp(buf, "#ifdef", 6) == 0) {
			char *ptr = buf + 6;
			if (*ptr != ' ' && *ptr != '\t') {
				fprintf(stderr, "Error %d: invalid macro on line %d\n", __LINE__, line);
				exit(1);
			}

			while (*ptr == ' ' || *ptr == '\t')
				ptr++;

			if (!find_macro(ptr))
				disabled = 1;
			else
				enabled = 1;
			continue;
		}

		if (strncmp(buf, "#endif", 6) == 0) {
			disabled = 0;
			enabled = 1;
			continue;
		}

		if (!disabled) {
//			printf("%s\n", buf);
			fprintf(fpout, "%s\n", buf);
		}
	}
	fclose(fp);

	return 0;

errout:
	fclose(fp);
	fprintf(stderr, "Error: cannot open output file\n");
	exit(1);
}
