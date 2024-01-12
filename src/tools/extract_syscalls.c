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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFMAX 4096

int main(int argc, char **argv) {
	if (argc != 2) {
		printf("usage: %s /usr/include/x86_64-linux-gnu/bits/syscall.h\n", argv[0]);
		return 1;
	}

	//open file
	FILE *fp = fopen(argv[1], "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot open file\n");
		return 1;
	}

	// read file
	char buf[BUFMAX];
	while (fgets(buf, BUFMAX, fp)) {
		// cleanup
		char *start = buf;
		while (*start == ' ' || *start == '\t')
			start++;
		char *end = strchr(start, '\n');
		if (end)
			*end = '\0';

		// parsing
		if (strncmp(start, "# error", 7) == 0)
			continue;
		if (strncmp(start, "#endif", 6) == 0)
			printf("%s\n", start);
		if (strncmp(start, "#endif", 6) == 0)
			printf("%s\n", start);
		else if (strncmp(start, "#if", 3) == 0)
			printf("%s\n", start);
		else if (strncmp(start, "#define", 7) == 0) {
			// extract data
			char *ptr1 = strstr(start, "SYS_");
			char *ptr2 = strstr(start, "__NR_");
			if (!ptr1 || !ptr2) {
				fprintf(stderr, "Error: cannot parse \"%s\"\n", start);
				fclose(fp);
				return 1;
			}
			*(ptr2 - 1) = '\0';

			char *ptr3 = ptr1;
			while (*ptr3 != ' ' && *ptr3 != '\t' && *ptr3 != '\0')
				ptr3++;
			*ptr3 = '\0';
			ptr3 = ptr2;
			while (*ptr3 != ' ' && *ptr3 != '\t' && *ptr3 != '\0')
				ptr3++;
			*ptr3 = '\0';

			ptr3 = ptr1;
			while (*ptr3 != '_')
				ptr3++;
			ptr3++;

			printf("#ifdef %s\n", ptr1);
			printf("#ifdef %s\n", ptr2);
			printf("\t{\"%s\", %s},\n", ptr3, ptr2);
			printf("#endif\n");
			printf("#endif\n");
		}
	}
	fclose(fp);
	return 0;
}
