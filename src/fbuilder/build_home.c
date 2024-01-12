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

static FileDB *db_skip = NULL;
static FileDB *db_out = NULL;

void process_home(const char *fname, char *home, int home_len) {
	assert(fname);
	assert(home);
	assert(home_len);

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
		if (strncmp(ptr, "access /home", 12) == 0)
			ptr +=  7;
		else if (strncmp(ptr, "fopen /home", 11) == 0)
			ptr += 6;
		else if (strncmp(ptr, "fopen64 /home", 13) == 0)
			ptr += 8;
		else if (strncmp(ptr, "open64 /home", 12) == 0)
			ptr += 7;
		else if (strncmp(ptr, "open /home", 10) == 0)
			ptr += 5;
		else if (strncmp(ptr, "opendir /home", 13) == 0)
			ptr += 8;
		else
			continue;

		// end of filename
		char *ptr2 = strchr(ptr, ':');
		if (!ptr2)
			continue;
		*ptr2 = '\0';

		// check home directory
		if (strncmp(ptr, home, home_len) != 0)
			continue;
		if (strcmp(ptr, home) == 0)
			continue;
		ptr += home_len + 1;

		// skip files handled automatically by firejail
		if (strcmp(ptr, ".Xauthority") == 0 ||
		    strcmp(ptr, ".Xdefaults-debian") == 0 ||
		    strncmp(ptr, ".config/pulse/", 14) == 0 ||
		    strncmp(ptr, ".pulse/", 7) == 0 ||
		    strncmp(ptr, ".bash_hist", 10) == 0 ||
		    strcmp(ptr, ".bashrc") == 0)
			continue;

		// skip flatpak files
		if (strncmp(ptr, ".local/share/flatpak", 20) == 0)
			continue;

		// try to find the relevant directory for this file
		char *dir = extract_dir(ptr);
		char *toadd = (dir)? dir: ptr;

		// skip some dot directories
		if (strcmp(toadd, ".config") == 0 ||
		    strcmp(toadd, ".local") == 0 ||
		    strcmp(toadd, ".local/share") == 0 ||
		    strcmp(toadd, ".cache") == 0) {
			if (dir)
				free(dir);
			continue;
		}

		// clean .cache entries
		if (strncmp(toadd, ".cache/", 7) == 0) {
			char *ptr2 = toadd + 7;
			ptr2 = strchr(ptr2, '/');
			if (ptr2)
				*ptr2 = '\0';
		}

		// skip files and directories in whitelist-common.inc
		if (strlen(toadd) == 0 || filedb_find(db_skip, toadd)) {
			if (dir)
				free(dir);
			continue;
		}

		// add the file to out list
		db_out = filedb_add(db_out, toadd);
		if (dir)
			free(dir);

	}
	fclose(fp);
}


// process fname, fname.1, fname.2, fname.3, fname.4, fname.5
void build_home(const char *fname, FILE *fp) {
	assert(fname);

	// load whitelist common
	db_skip = filedb_load_whitelist(db_skip, "whitelist-common.inc", "whitelist ${HOME}/");

	// find user home directory
	struct passwd *pw = getpwuid(getuid());
	if (!pw)
		errExit("getpwuid");
	char *home = pw->pw_dir;
	if (!home)
		errExit("getpwuid");
	int home_len = strlen(home);

	// run fname
	process_home(fname, home, home_len);

	// run all the rest
	struct stat s;
	int i;
	for (i = 1; i <= 5; i++) {
		char *newname;
		if (asprintf(&newname, "%s.%d", fname, i) == -1)
			errExit("asprintf");
		if (stat(newname, &s) == 0)
			process_home(newname, home, home_len);
		free(newname);
	}

	// print the out list if any
	if (db_out) {
		filedb_print(db_out, "whitelist ${HOME}/", fp);
		fprintf(fp, "include whitelist-common.inc\n");
	}
	else
		fprintf(fp, "private\n");

}
