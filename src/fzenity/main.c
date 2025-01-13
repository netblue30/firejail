/*
 * Copyright (C) 2014-2025 Firejail Authors
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
#include "../include/common.h"
#include <sys/ioctl.h>

static char *arg_title = NULL;
static char *arg_text = NULL;
static int arg_info = 0;
static int arg_question = 0;

static inline void ansi_topleft(void) {
	char str[] = {0x1b, '[', '1', ';',  '1', 'H', '\0'};
	printf("%s", str);
	fflush(0);
}

static inline void ansi_clrscr(void) {
	ansi_topleft();
	char str[] = {0x1b, '[', '0', 'J', '\0'};
	printf("%s", str);
	fflush(0);
}

char *remove_markup(char *in) {
	char *out = malloc(strlen(in) + 1);
	if (!out)
		errExit("malloc");
	memset(out, 0, strlen(in) + 1);

	char *ptr = in;
	char *outptr = out;
	while (*ptr != '\0') {
		// skip <> markup
		if (*ptr == '<') {
			while (*ptr != '\0' && *ptr != '>')
				ptr++;
			if (*ptr == '\0') {
				fprintf(stderr, "Error: invalid markup\n");
				exit(0);
			}
			ptr++;
		}
		// replace literal \n with char '\n'
		else if (*ptr == '\\' && *(ptr + 1) == 'n') {
			ptr += 2;
			*outptr++ = '\n';
			continue;
		}
		// replace '/n' with ' '
		else if (*ptr == '\n') {
			if (*(ptr + 1) == '\n') {
				*outptr++ = '\n';
				*outptr++ = '\n';
				ptr += 2;
			}
			else {
				*outptr++ = ' ';
				ptr++;
			}
		}
		else
			*outptr++ = *ptr++;
	}

	return out;
}

char *print_line(char *in, int col) {
	char *ptr = in;
	int i = 0;
	while (*ptr !=  '\n' && *ptr != '\0' && i < col) {
		ptr++;
		i++;
	}

	if (*ptr == '\n') {
		*ptr++ = '\0';
		printf("%s\n", in);
		return ptr;
	}
	else if (i == col) {
		while (*ptr != ' ' && ptr != in)
			ptr--;
		*ptr++ = '\0';
		printf("%s\n", in);
		return ptr;
	}
	assert(0);
	return NULL;
}

void paginate(char *in) {
	struct winsize w;
	unsigned col = 80;
	if (ioctl(0, TIOCGWINSZ, &w) == 0)
		col = w.ws_col;

	char *ptr = in;
	while (*ptr != '\0') {
		if (strlen(ptr) < col) {
			printf("%s", ptr);
			return;
		}
		ptr =print_line(ptr, col);
	}

	return;
}

static void info(void) {
	ansi_clrscr();
	if (arg_text == NULL) {
		fprintf(stderr, "Error: --text argument required\n");
		exit(1);
	}

	if (arg_title)
		printf("%s\n\n", arg_title);

	char *ptr = strstr(arg_text, "Press OK to continue");
	if (ptr)
		*ptr = '\0';
	char *out = remove_markup(arg_text);
	paginate(out);
	free(out);

	printf("\nContinue? (Y/N): ");

	int c = getchar();
	if (c == 'y' || c == 'Y')
		exit(0);
	exit(1);
}

static void question(void) {
	ansi_clrscr();
	if (arg_text == NULL) {
		fprintf(stderr, "Error: --text argument required\n");
		exit(1);
	}

	if (arg_title)
		printf("%s\n\n", arg_title);

	char *ptr = strstr(arg_text, "Press OK to continue");
	if (ptr)
		*ptr = '\0';
	char *out = remove_markup(arg_text);
	paginate(out);
	free(out);

	printf("\n\n(Y/N): ");

	int c = getchar();
	if (c == 'y' || c == 'Y')
		exit(0);
	exit(1);
}

int main(int argc, char **argv) {
	int i;
	for (i = 1; i < argc; i++) {
//printf("argv %d: #%s#\n", i, argv[i]);
		if (strcmp(argv[i], "--info") == 0)
			arg_info = 1;
		else if (strcmp(argv[i], "--question") == 0)
			arg_question = 1;
		else if (strncmp(argv[i], "--text=", 7) == 0)
			arg_text = argv[i] + 7;
	}

	if (arg_question)
		question();
	else if (arg_info)
		info();

	return 0;
}
