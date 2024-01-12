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
#include "fbuilder.h"

static FileDB *bin_out = NULL;

static void process_bin(const char *fname) {
	assert(fname);

	// process trace file
	FILE *fp = fopen(fname, "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot open %s\n", fname);
		exit(1);
	}

	char buf[MAX_BUF];
	while (fgets(buf, MAX_BUF, fp)) {
		// remove \n
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';

		// parse line: 4:galculator:access /etc/fonts/conf.d:0
		// number followed by :
		ptr = buf;
		if (!isdigit(*ptr))
			continue;
		while (isdigit(*ptr))
			ptr++;
		if (*ptr != ':')
			continue;
		ptr++;

		// next :
		ptr = strchr(ptr, ':');
		if (!ptr)
			continue;
		ptr++;
		if (strncmp(ptr, "exec ", 5) == 0)
			ptr +=  5;
		else
			continue;
		if (strncmp(ptr, "/bin/", 5) == 0)
			ptr += 5;
		else if (strncmp(ptr, "/sbin/", 6) == 0)
			ptr += 6;
		else if (strncmp(ptr, "/usr/bin/", 9) == 0)
			ptr += 9;
		else if (strncmp(ptr, "/usr/sbin/", 10) == 0)
			ptr += 10;
		else if (strncmp(ptr, "/usr/local/bin/", 15) == 0)
			ptr += 15;
		else if (strncmp(ptr, "/usr/local/sbin/", 16) == 0)
			ptr += 16;
		else if (strncmp(ptr, "/usr/games/", 11) == 0)
			ptr += 11;
		else if (strncmp(ptr, "/usr/local/games/", 17) == 0)
			ptr += 17;
		else
			continue;

		// end of filename
		char *ptr2 = strchr(ptr, ':');
		if (!ptr2)
			continue;
		*ptr2 = '\0';

		// skip strace and firejail (in case we hit a symlink in /usr/local/bin)
		if (strcmp(ptr, "strace") && strcmp(ptr, "firejail"))
			bin_out = filedb_add(bin_out, ptr);
	}

	fclose(fp);
}


// process fname, fname.1, fname.2, fname.3, fname.4, fname.5
void build_bin(const char *fname, FILE *fp) {
	assert(fname);

	// run fname
	process_bin(fname);

	// run all the rest
	struct stat s;
	int i;
	for (i = 1; i <= 5; i++) {
		char *newname;
		if (asprintf(&newname, "%s.%d", fname, i) == -1)
			errExit("asprintf");
		if (stat(newname, &s) == 0)
			process_bin(newname);
		free(newname);
	}

	if (bin_out) {
		fprintf(fp, "private-bin ");
		FileDB *ptr = bin_out;
		while (ptr) {
			fprintf(fp, "%s,", ptr->fname);
			ptr = ptr->next;
		}
		fprintf(fp, "\n");
	}
}
