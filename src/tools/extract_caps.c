/*
 * Copyright (C) 2014, 2015 netblue30 (netblue30@yahoo.com)
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

#define BUFMAX 4096

int main(int argc, char **argv) {
	if (argc != 2) {
		printf("usage: %s /usr/include/linux/capability.h\n", argv[0]);
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
		if (strncmp(start, "#define CAP_", 12) == 0) {
			if (strstr(start, "CAP_LAST_CAP"))
				break;
			
			char *ptr1 = start + 8;
			char *ptr2 = ptr1;
			while (*ptr2 == ' ' || *ptr2 == '\t')
				ptr2++;
			while (*ptr2 != ' ' && *ptr2 != '\t')
				ptr2++;
			*ptr2 = '\0';
			
			ptr2 = strdup(ptr1);
			assert(ptr2);
			ptr2 += 4;
			char *ptr3 = ptr2;
			while (*ptr3 != '\0') {
				*ptr3 = tolower(*ptr3);
				ptr3++;
			}
			
			
			printf("#ifdef %s\n", ptr1);
			printf("\t{\"%s\", %s },\n", ptr2, ptr1);
			printf("#endif\n");
			
		}
		
	}
	fclose(fp);
	return 0;
}
