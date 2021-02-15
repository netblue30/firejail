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

#include "fbuilder.h"

FileDB *filedb_find(FileDB *head, const char *fname) {
	FileDB *ptr = head;
	int found = 0;
	int len = strlen(fname);

	while (ptr) {
		// exact name
		if (strcmp(fname, ptr->fname) == 0) {
			found = 1;
			break;
		}

		// parent directory in the list
		if (len > ptr->len &&
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
	FileDB *ptr = head;
	while (ptr) {
		fprintf(fp, "%s%s\n", prefix, ptr->fname);
		ptr = ptr->next;
	}
}
