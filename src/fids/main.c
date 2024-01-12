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
#include "fids.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <dirent.h>
#include <glob.h>

#define MAXBUF 4096

static int dir_level = 1;
static int include_level = 0;
int arg_init = 0;
int arg_check = 0;
char *arg_homedir = NULL;
char *arg_dbfile = NULL;

int f_scanned = 0;
int f_modified = 0;
int f_new = 0;
int f_removed = 0;
int f_permissions = 0;



static inline int is_dir(const char *fname) {
	assert(fname);

	struct stat s;
	if (stat(fname, &s) == 0) {
		if (S_ISDIR(s.st_mode))
			return 1;
	}
	return 0;
}

static inline int is_link(const char *fname) {
	assert(fname);

	char c;
	ssize_t rv = readlink(fname, &c, 1);
	return (rv != -1);
}

// mode is an array of 10 chars or more
static inline void file_mode(const char *fname, char *mode) {
	assert(fname);
	assert(mode);

	struct stat s;
	if (stat(fname, &s)) {
		*mode = '\0';
		return;
	}

	sprintf(mode, (s.st_mode & S_IRUSR) ? "r" : "-");
	sprintf(mode + 1, (s.st_mode & S_IWUSR) ? "w" : "-");
	sprintf(mode + 2, (s.st_mode & S_IXUSR) ? "x" : "-");
	sprintf(mode + 3, (s.st_mode & S_IRGRP) ? "r" : "-");
	sprintf(mode + 4, (s.st_mode & S_IWGRP) ? "w" : "-");
	sprintf(mode + 5, (s.st_mode & S_IXGRP) ? "x" : "-");
	sprintf(mode + 6, (s.st_mode & S_IROTH) ? "r" : "-");
	sprintf(mode + 7, (s.st_mode & S_IWOTH) ? "w" : "-");
	sprintf(mode + 8, (s.st_mode & S_IXOTH) ? "x" : "-");
}


static void file_checksum(const char *fname) {
	assert(fname);

	int fd = open(fname, O_RDONLY);
	if (fd == -1)
		return;

	off_t size = lseek(fd, 0, SEEK_END);
	if (size < 0) {
		close(fd);
		return;
	}

	char *content = "empty";
	int mmapped = 0;
	if (size == 0) {
		// empty files don't mmap - use "empty" string as the file content
		size = 6; // strlen("empty") + 1
	}
	else {
		content = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
		close(fd);
		mmapped = 1;
	}

	unsigned char checksum[KEY_SIZE / 8];
	blake2b(checksum, sizeof(checksum), content, size);
	if (mmapped)
		munmap(content, size);

	// calculate blake2 checksum
	char str_checksum[(KEY_SIZE / 8) * 2 + 1];
	int long unsigned i;
	char *ptr = str_checksum;
	for (i = 0; i < sizeof(checksum); i++, ptr += 2)
		sprintf(ptr, "%02x", (unsigned char ) checksum[i]);

	// build permissions string
	char mode[10];
	file_mode(fname, mode);

	if (arg_init)
		printf("%s\t%s\t%s\n", mode, str_checksum, fname);
	else if (arg_check)
		db_check(fname, str_checksum, mode);
	else
		assert(0);

	f_scanned++;
	if (f_scanned % 500 == 0)
		fprintf(stderr, "%d ", f_scanned);
	fflush(0);
}

void list_directory(const char *fname) {
	assert(fname);
	if (dir_level > MAX_DIR_LEVEL) {
		fprintf(stderr, "Warning fids: maximum depth level exceeded for %s\n", fname);
		return;
	}

	if (db_exclude_check(fname))
		return;

	if (is_link(fname))
		return;

	if (!is_dir(fname)) {
		file_checksum(fname);
		return;
	}

	DIR *dir;
	struct dirent *entry;

	if (!(dir = opendir(fname)))
		return;

	dir_level++;
	while ((entry = readdir(dir)) != NULL) {
		if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
			continue;
		char *path;
		if (asprintf(&path, "%s/%s", fname, entry->d_name) == -1)
			errExit("asprintf");
		list_directory(path);
		free(path);
	}
	closedir(dir);
	dir_level--;
}

void globbing(const char *fname) {
	assert(fname);

	// filter top directory
	if (strcmp(fname, "/") == 0)
		return;

	glob_t globbuf;
	int globerr = glob(fname, GLOB_NOCHECK | GLOB_NOSORT | GLOB_PERIOD, NULL, &globbuf);
	if (globerr) {
		fprintf(stderr, "Error fids: failed to glob pattern %s\n", fname);
		exit(1);
	}

	long unsigned i;
	for (i = 0; i < globbuf.gl_pathc; i++) {
		char *path = globbuf.gl_pathv[i];
		assert(path);

		list_directory(path);
	}

	globfree(&globbuf);
}

static void process_config(const char *fname) {
	assert(fname);

	if (++include_level >= MAX_INCLUDE_LEVEL) {
		fprintf(stderr, "Error ids: maximum include level for config files exceeded\n");
		exit(1);
	}

	fprintf(stderr, "Opening config file %s\n", fname);
	int fd = open(fname, O_RDONLY|O_CLOEXEC);
	if (fd < 0) {
		if (include_level == 1) {
			fprintf(stderr, "Error ids: cannot open config file %s\n", fname);
			exit(1);
		}
		return;
	}

	// make sure the file is owned by root
	struct stat s;
	if (fstat(fd, &s)) {
		fprintf(stderr, "Error ids: cannot stat config file %s\n", fname);
		exit(1);
	}
	if (s.st_uid || s.st_gid) {
		fprintf(stderr, "Error ids: config file not owned by root\n");
		exit(1);
	}

	fprintf(stderr, "Loading config file %s\n", fname);
	FILE *fp = fdopen(fd, "r");
	if (!fp) {
		fprintf(stderr, "Error fids: cannot open config file %s\n", fname);
		exit(1);
	}

	char buf[MAXBUF];
	int line = 0;
	while (fgets(buf, MAXBUF, fp)) {
		line++;

		// trim \n
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';

		// comments
		ptr = strchr(buf, '#');
		if (ptr)
			*ptr = '\0';

		// empty space
		ptr = buf;
		while (*ptr == ' ' || *ptr == '\t')
			ptr++;
		char *start = ptr;

		// empty line
		if (*start == '\0')
			continue;

		// trailing spaces
		ptr = start + strlen(start);
		ptr--;
		while (*ptr == ' ' || *ptr == '\t')
			*ptr-- = '\0';

		// replace ${HOME}
		if (strncmp(start, "include", 7) == 0) {
			ptr = start + 7;
			if ((*ptr != ' ' && *ptr != '\t') || *ptr == '\0') {
				fprintf(stderr, "Error fids: invalid line %d in %s\n", line, fname);
				exit(1);
			}
			while (*ptr == ' ' || *ptr == '\t')
				ptr++;

			if (*ptr == '/')
				process_config(ptr);
			else {
				// assume the file is in /etc/firejail
				char *tmp;
				if (asprintf(&tmp, "/etc/firejail/%s", ptr) == -1)
					errExit("asprintf");
				process_config(tmp);
				free(tmp);
			}
		}
		else if (*start == '!') {
			// exclude file or dir
			start++;
			if (strncmp(start, "${HOME}", 7))
				db_exclude_add(start);
			else {
				char *fname;
				if (asprintf(&fname, "%s%s", arg_homedir, start + 7) == -1)
					errExit("asprintf");
				db_exclude_add(fname);
				free(fname);
			}
		}
		else if (strncmp(start, "${HOME}", 7))
			globbing(start);
		else {
			char *fname;
			if (asprintf(&fname, "%s%s", arg_homedir, start + 7) == -1)
				errExit("asprintf");
			globbing(fname);
			free(fname);
		}
	}

	fclose(fp);
	include_level--;
}

static const char *const usage_str =
	"Usage: fids [--help|-h|-?] --init|--check homedir\n";

void usage(void) {
	puts(usage_str);
}

int main(int argc, char **argv) {
	int i;
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "-h") == 0 ||
		    strcmp(argv[i], "-?") == 0 ||
		    strcmp(argv[i], "--help") == 0) {
			usage();
			return 0;
		}
		else if (strcmp(argv[i], "--init") == 0)
			arg_init = 1;
		else if (strcmp(argv[i], "--check") == 0)
			arg_check = 1;
		else if (strncmp(argv[i], "--", 2) == 0) {
			fprintf(stderr, "Error fids: invalid argument %s\n", argv[i]);
			exit(1);
		}
	}

	if (argc != 3) {
		fprintf(stderr, "Error fids: invalid number of arguments\n");
		exit(1);
	}
	arg_homedir = argv[2];

	int op = arg_check + arg_init;
	if (op == 0 || op == 2) {
		fprintf(stderr, "Error fids: use either --init or --check\n");
		exit(1);
	}

	if (arg_init) {
		process_config(SYSCONFDIR"/ids.config");
		fprintf(stderr, "\n%d files scanned\n", f_scanned);
		fprintf(stderr, "IDS database initialized\n");
	}
	else if (arg_check) {
		if (db_init()) {
			fprintf(stderr, "Error: IDS database not initialized, please run \"firejail --ids-init\"\n");
			exit(1);
		}

		process_config(SYSCONFDIR"/ids.config");
		fprintf(stderr, "\n%d files scanned: modified %d, permissions %d, new %d, removed %d\n",
			f_scanned, f_modified, f_permissions, f_new, f_removed);
		db_missing();
	}
	else
		assert(0);

	return 0;
}
