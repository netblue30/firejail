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

// find exact name or an exact name in a parent directory
FileDB *filedb_find(FileDB *head, const char *fname) {
	assert(fname);
	FileDB *ptr = head;
	int found = 0;

	while (ptr) {
		// ptr->fname can be a pattern, like .mutter-Xwaylandauth.*
		// check if fname is a match
		if (fnmatch(ptr->fname, fname, FNM_PATHNAME) == 0) {
			found = 1;
			break;
		}

		// parent directory in the list
		if (strlen(fname) > ptr->len &&
		    fname[ptr->len] == '/' &&
		    strncmp(ptr->fname, fname, ptr->len) == 0) {
			found = 1;
			break;
		}

		ptr = ptr->next;
	}

	if (found)
		return ptr;

	return NULL;
}

FileDB *filedb_add(FileDB *head, const char *fname) {
	assert(fname);

	// don't add it if it is already there or if the parent directory is already in the list
	if (filedb_find(head, fname))
		return head;

	// add a new entry
	FileDB *entry = malloc(sizeof(FileDB));
	if (!entry)
		errExit("malloc");
	memset(entry, 0, sizeof(FileDB));
	entry->fname = strdup(fname);
	if (!entry->fname)
		errExit("strdup");
	entry->len = strlen(entry->fname);
	entry->next = head;
	return entry;
};

void filedb_print(FileDB *head, const char *prefix, FILE *fp) {
	assert(head);
	assert(prefix);

	FileDB *ptr = head;
	while (ptr) {
		if (fp)
			fprintf(fp, "%s%s\n", prefix, ptr->fname);
		else
			printf("%s%s\n", prefix, ptr->fname);
		ptr = ptr->next;
	}
}

FileDB *filedb_load_whitelist(FileDB *head, const char *fname, const char *prefix) {
	assert(fname);
	assert(prefix);
	int len = strlen(prefix);
	char *f;
	if (asprintf(&f, "%s/%s", SYSCONFDIR, fname) == -1)
		errExit("asprintf");
	FILE *fp = fopen(f, "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot open %s\n", f);
		free(f);
		exit(1);
	}

	char buf[MAX_BUF];
	while (fgets(buf, MAX_BUF, fp)) {
		if (strncmp(buf, prefix, len) != 0)
			continue;

		char *fn = buf + len;
		char *ptr = strchr(buf, '\n');
		if (!ptr)
			continue;
		*ptr = '\0';

		// add the file to skip list
		head = filedb_add(head, fn);
	}

	fclose(fp);
	free(f);
//printf("***************************************************\n");
//filedb_print(head, prefix, NULL);
//printf("***************************************************\n");
	return head;
}
