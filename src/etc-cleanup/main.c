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

#include "../include/etc_groups.h"
#include "../include/common.h"
#include <stdarg.h>

#define MAX_BUF 4098
#define MAX_ARR 1024
char *arr[MAX_ARR] = {NULL};
int arr_cnt = 0;

static int arr_tls_ca = 0;
static int arr_x11 = 0;
static int arr_games = 0;
static char outbuf[256 * 1024];
static char *outptr;
static int arg_replace = 0;
static int arg_debug = 0;

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

int arr_cmp(const void *p1, const void *p2) {
	char **ptr1 = (char **) p1;
	char **ptr2 = (char **) p2;

	return strcmp(*ptr1, *ptr2);
}

static void arr_sort(void) {
	qsort(&arr[0], arr_cnt, sizeof(char *), arr_cmp);
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

static char *arr_print(void) {
	char *last_line = outptr;
	outprintf("private-etc ");

	if (arr_games)
		outprintf("@games,");
	if (arr_tls_ca)
		outprintf("@tls-ca,");
	if (arr_x11)
		outprintf("@x11,");

	int i;
	for (i = 0; i < arr_cnt; i++)
		outprintf("%s,", arr[i]);
	if (*(outptr - 1) == ' ' || *(outptr - 1) == ',') {
		outptr--;
		*outptr = '\0';
	}
	outprintf("\n");

	return last_line;
}

static void process_file(const char *fname) {
	assert(fname);

	FILE *fp = fopen(fname, "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot open %s file\n", fname);
		exit(1);
	}

	outptr = outbuf;
	*outptr = '\0';
	arr_clean();

	char line[MAX_BUF];
	char orig_line[MAX_BUF];
	int cnt = 0;
	int print = 0;
	while (fgets(line, MAX_BUF, fp)) {
		cnt++;
		if (strncmp(line, "private-etc", 11) != 0)  {
			outprintf("%s", line);
			continue;
		}

		strcpy(orig_line,line);
		char *ptr = strchr(line, '\n');
		if (ptr)
			*ptr = '\0';

		ptr = line + 12;
		while (*ptr == ' ' || *ptr == '\t')
			ptr++;

		// check for blanks and tabs
		char *ptr2 = ptr;
		while (*ptr2 != '\0') {
			if (*ptr2 == ' ' || *ptr2 == '\t') {
				fprintf(stderr, "Error: invalid private-etc line %s:%d\n", fname, cnt);
				exit(1);
			}
			ptr2++;
		}

		ptr = strtok(ptr, ",");
		while (ptr) {
			if (arg_debug)
				printf("%s\n", ptr);
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

		arr_sort();
		char *last_line = arr_print();
		if (strcmp(last_line, orig_line) == 0) {
			fclose(fp);
			return;
		}
		printf("\n********************\nfile: %s\n\nold: %s\nnew: %s\n", fname, orig_line, last_line);
		print = 1;
	}

	fclose(fp);

	if (print && arg_replace) {
		fp = fopen(fname, "w");
		if (!fp) {
			fprintf(stderr, "Error: cannot open profile file\n");
			exit(1);
		}
		fprintf(fp, "%s", outbuf);
		fclose(fp);
	}
}

static const char *const usage_str =
	"usage: cleanup-etc [options] file.profile [file.profile]\n"
	"Group and clean private-etc entries in one or more profile files.\n"
	"Options:\n"
	"   --debug - print debug messages\n"
	"   -h, -?, --help - this help screen\n"
	"   --replace - replace profile file\n";

static void usage(void) {
	puts(usage_str);
}

int main(int argc, char **argv) {
	if (argc < 2) {
		fprintf(stderr, "Error: invalid number of parameters\n");
		usage();
		return 1;
	}

	int i;
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "-h") == 0 ||
		    strcmp(argv[i], "-?") == 0 ||
		    strcmp(argv[i], "--help") == 0) {
			usage();
			return 0;
		}
		else if (strcmp(argv[i], "--debug") == 0)
			arg_debug = 1;
		else if (strcmp(argv[i], "--replace") == 0)
			arg_replace = 1;
		else if (*argv[i] == '-') {
			fprintf(stderr, "Error: invalid program option %s\n", argv[i]);
			return 1;
		}
		else
			break;
	}

	for (; i < argc; i++)
		process_file(argv[i]);

	return 0;
}
