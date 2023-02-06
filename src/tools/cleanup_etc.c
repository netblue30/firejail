/*
 * Copyright (C) 2014-2022 Firejail Authors
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
#include <stdarg.h>
#include <assert.h>
#include "../include/etc_groups.h"
#define errExit(msg)    do { char msgout[500]; sprintf(msgout, "Error %s:%s(%d)", msg, __FUNCTION__, __LINE__); perror(msgout); exit(1);} while (0)



#define MAX_BUF 4098
#define MAX_ARR 1024
char *arr[MAX_ARR] = {NULL};
int arr_cnt = 0;

static int arr_tls_ca = 0;
static int arr_x11 = 0;
static int arr_games = 0;
static char outbuf[256 * 1024];
static char *outptr;

void outprintf(char* fmt, ...) {
	va_list args;
	va_start(args,fmt);
	outptr += vsprintf(outptr, fmt, args);
	va_end(args);
}



static int arr_check(const char *fname, char **pptr) {
	assert(fname);
	assert(pptr);

	while (*pptr != NULL) {
		if (strcmp(fname, *pptr) == 0)
			return 1;
		pptr++;
	}

	return 0;
}



static void arr_add(const char *fname) {
	assert(fname);
	assert(arr_cnt < MAX_ARR);

	int i;
	for (i = 0; i < arr_cnt; i++)
		if (strcmp(arr[i], fname) == 0)
			return;

	arr[arr_cnt] = strdup(fname);
	if (!arr[arr_cnt])
		errExit("strdup");
	arr_cnt++;
}

static void arr_clean(void) {
	int i;
	for (i = 0; i < arr_cnt; i++) {
		free(arr[i]);
		arr[i] = NULL;
	}

	arr_cnt = 0;
	arr_games = 0;
	arr_tls_ca = 0;
	arr_x11 = 0;
}

static void arr_print(void) {
	printf("private-etc ");
	outprintf("private-etc ");

	if (arr_games) {
		printf("@games,");
		outprintf("@games,");
	}
	if (arr_tls_ca) {
		printf("@tls-ca,");
		outprintf("@tls-ca,");
	}
	if (arr_x11) {
		printf("@x11,");
		outprintf("@x11,");
	}
	int i;
	for (i = 0; i < arr_cnt; i++) {
		printf("%s,", arr[i]);
		outprintf("%s,", arr[i]);
	}
	printf("\n");
	outprintf("\n");
}

static void process_file(const char *fname) {
	assert(fname);

	FILE *fp = fopen(fname, "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot open profile file\n");
		exit(1);
	}

	outptr = outbuf;
	*outptr = '\0';

	char line[MAX_BUF];
	char orig_line[MAX_BUF];
	int cnt = 0;
	int print = 0;
	while (fgets(line, MAX_BUF, fp)) {
		cnt++;
		if (strncmp(line, "private-etc ", 12) != 0)  {
			sprintf(outptr, "%s", line);
			outptr += strlen(outptr);
			continue;
		}
		char *ptr = strchr(line, '\n');
		if (ptr)
			*ptr = '\0';

		print = 1;
		strcpy(orig_line,line);

		ptr = line + 12;
		while (*ptr == ' ' || *ptr == '\t')
			ptr++;

		// check for blanks and tabs
		char *ptr2 = ptr;
		while (*ptr2 != '\0') {
			if (*ptr2 == ' ' || *ptr2 == '\t') {
				fprintf(stderr, "Error: invlid private-etc line %s:%d\n", fname, cnt);
				exit(1);
			}
			ptr2++;
		}

		ptr = strtok(ptr, ",");
		while (ptr) {
			if (arr_check(ptr, &etc_list[0]));
			else if (arr_check(ptr, &etc_group_sound[0]));
			else if (arr_check(ptr, &etc_group_network[0]));
			else if (strcmp(ptr, "@games") == 0)
				arr_games = 1;
			else if (strcmp(ptr, "@tls-ca") == 0)
				arr_tls_ca = 1;
			else if (strcmp(ptr, "@x11") == 0)
				arr_x11 = 1;
			else if (arr_check(ptr, &etc_group_games[0]))
				arr_games = 1;
			else if (arr_check(ptr, &etc_group_tls_ca[0]))
				arr_tls_ca = 1;
			else if (arr_check(ptr, &etc_group_x11[0]))
				arr_x11 = 1;
			else
				arr_add(ptr);

			ptr = strtok(NULL, ",");
		}

		printf("\n%s: %s\n%s: ", fname, orig_line, fname);
		arr_print();
		arr_clean();
	}

	fclose(fp);

	if (print) {
		printf("Replace %s file? (Y/N): ", fname);
		fgets(line, MAX_BUF, stdin);
		if (*line == 'y' || *line == 'Y') {
			fp = fopen(fname, "w");
			if (!fp) {
				fprintf(stderr, "Error: cannot open profile file\n");
				exit(1);
			}
			fprintf(fp, "%s", outbuf);
			fclose(fp);
		}
	}
}

static void usage(void) {
	printf("usage: cleanup-etc file.profile\n");
}

int main(int argc, char **argv) {
	if (argc < 2) {
		fprintf(stderr, "Error: invalid number of parameters\n");
		usage();
		return 1;
	}

	int i;
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "-h") == 0) {
			usage();
			return 0;
		}
	}

	for (i = 1; i < argc; i++)
		process_file(argv[i]);

	return 0;
}