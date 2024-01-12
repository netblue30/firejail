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

#ifndef FBUILDER_H
#define FBUILDER_H
#include "../include/common.h"
#include <sys/types.h>
#include <pwd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <fnmatch.h>

#define MAX_BUF 4096
// main.c
extern int arg_debug;
extern int arg_appimage;

// build_profile.c
void build_profile(int argc, char **argv, int index, FILE *fp);

// build_seccomp.c
void build_seccomp(const char *fname, FILE *fp);
void build_protocol(const char *fname, FILE *fp);

// build_fs.c
void build_etc(const char *fname, FILE *fp);
void build_var(const char *fname, FILE *fp);
void build_tmp(const char *fname, FILE *fp);
void build_dev(const char *fname, FILE *fp);
void build_share(const char *fname, FILE *fp);
void build_run(const char *fname, FILE *fp);
void build_runuser(const char *fname, FILE *fp);

// build_bin.c
void build_bin(const char *fname, FILE *fp);

// build_home.c
void build_home(const char *fname, FILE *fp);

// utils.c
int is_dir(const char *fname);
char *extract_dir(char *fname);

// filedb.c
typedef struct filedb_t {
	struct filedb_t *next;
	char *fname;	// file name
	unsigned len;	// length of file name
} FileDB;

FileDB *filedb_add(FileDB *head, const char *fname);
FileDB *filedb_find(FileDB *head, const char *fname);
void filedb_print(FileDB *head, const char *prefix, FILE *fp);
FileDB *filedb_load_whitelist(FileDB *head, const char *fname, const char *prefix);

#endif
