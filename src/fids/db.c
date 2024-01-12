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
#include"fids.h"

typedef struct db_t {
	struct db_t *next;
	char *fname;
	char *checksum;
	char *mode;
	int checked;
} DB;

#define MAXBUF 4096
static DB *database[HASH_MAX] = {NULL};

// djb2 hash function by Dan Bernstein
static unsigned hash(const char *str) {
	unsigned long hash = 5381;
	int c;

	while ((c = *str++) != '\0')
		hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

	return hash & (HASH_MAX - 1);
}

#if 0
// for testing the hash table
static void db_print(void) {
	int i;
	for (i = 0; i < HASH_MAX; i++) {
		int cnt = 0;
		DB *ptr = database[i];
		while (ptr) {
			cnt++;
			ptr = ptr->next;
		}
		printf("%d ", cnt);
		fflush(0);
	}
	printf("\n");
}
#endif

static void db_add(const char *fname, const char *checksum, const char *mode) {
	DB *ptr = malloc(sizeof(DB));
	if (!ptr)
		errExit("malloc");
	ptr->fname = strdup(fname);
	ptr->checksum = strdup(checksum);
	ptr->mode = strdup(mode);
	ptr->checked = 0;
	if (!ptr->fname || !ptr->checksum || !ptr->mode)
		errExit("strdup");

	unsigned h = hash(fname);
	ptr->next = database[h];
	database[h] = ptr;
}

void db_check(const char *fname, const char *checksum, const char *mode) {
	assert(fname);
	assert(checksum);
	assert(mode);

	unsigned h =hash(fname);
	DB *ptr = database[h];
	while (ptr) {
		if (strcmp(fname, ptr->fname) == 0) {
			ptr->checked = 1;
			break;
		}
		ptr = ptr->next;
	}

	if (ptr ) {
		if (strcmp(checksum, ptr->checksum)) {
			f_modified++;
			fprintf(stderr, "\nWarning: modified %s\n", fname);
		}
		if (strcmp(mode, ptr->mode)) {
			f_permissions++;
			fprintf(stderr, "\nWarning: permissions %s: old %s, new %s\n",
				fname, ptr->mode, mode);
		}
	}
	else {
		f_new++;
		fprintf(stderr, "\nWarning: new file %s\n", fname);
	}
}

void db_missing(void) {
	int i;
	for (i = 0; i < HASH_MAX; i++) {
		DB *ptr = database[i];
		while (ptr) {
			if (!ptr->checked) {
				f_removed++;
				fprintf(stderr, "Warning: removed %s\n", ptr->fname);
			}
			ptr = ptr->next;
		}
	}
}

// return 0 if ok, 1 if error
int db_init(void) {
	char buf[MAXBUF];
	while(fgets(buf, MAXBUF, stdin)) {
		// split - tab separated

		char *mode = buf;
		char *ptr = strchr(buf, '\t');
		if (!ptr)
			goto errexit;
		*ptr = '\0';

		char *checksum = ptr + 1;
		ptr = strchr(checksum, '\t');
		if (!ptr)
			goto errexit;
		*ptr = '\0';

		char *fname = ptr + 1;
		ptr = strchr(fname, '\n');
		if (!ptr)
			goto errexit;
		*ptr = '\0';

		db_add(fname, checksum, mode);
	}
//	db_print();

	return 0;

errexit:
	fprintf(stderr, "Error fids: database corrupted\n");
	exit(1);
}
