/*
 * Copyright (C) 2014-2021 Firejail Authors
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

//*************************************************************
// Small utility program to convert profiles from blacklist/whitelist to deny/allow
// Compile:
//       gcc -o profcleaner profcleaner.c
// Usage:
//       profcleaner *.profile
//*************************************************************

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#define MAXBUF 4096

int main(int argc, char **argv) {
	printf("Usage: profcleaner files\n");
	int i;

	for (i = 1; i < argc; i++) {
		FILE *fp = fopen(argv[i], "r");
		if (!fp) {
			fprintf(stderr, "Error: cannot open %s\n", argv[i]);
			return 1;
		}

		FILE *fpout = fopen("profcleaner-tmp", "w");
		if (!fpout) {
			fprintf(stderr, "Error: cannot open output file\n");
			return 1;
		}

		char buf[MAXBUF];
		while (fgets(buf, MAXBUF, fp)) {
			if (strncmp(buf, "blacklist-nolog", 15) == 0)
				fprintf(fpout, "deny-nolog %s", buf + 15);
			else if (strncmp(buf, "blacklist", 9) == 0)
				fprintf(fpout, "deny %s", buf + 9);
			else if (strncmp(buf, "noblacklist", 11) == 0)
				fprintf(fpout, "nodeny %s", buf + 11);
			else if (strncmp(buf, "whitelist", 9) == 0)
				fprintf(fpout, "allow %s", buf + 9);
			else if (strncmp(buf, "nowhitelist", 11) == 0)
				fprintf(fpout, "noallow %s", buf + 11);
			else
				fprintf(fpout, "%s", buf);
		}

		fclose(fp);
		fclose(fpout);
		unlink(argv[i]);
		rename("profcleaner-tmp", argv[i]);
	}

	return 0;
}