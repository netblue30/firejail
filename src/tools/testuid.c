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

// compile: gcc -o testuid testuid.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>


static void print_status(void) {
	FILE *fp = fopen("/proc/self/status", "r");
	if (!fp) {
		fprintf(stderr, "Error, cannot open status file\n");
		exit(1);
	}

	char buf[4096];
	while (fgets(buf, 4096, fp)) {
		if (strncmp(buf, "Uid", 3) == 0 || strncmp(buf, "Gid", 3) == 0)
			printf("%s", buf);
	}

	fclose(fp);
}

int main(void) {
	print_status();
	return 0;
}
