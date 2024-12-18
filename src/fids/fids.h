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
#ifndef FIDS_H
#define FIDS_H

#include "../include/common.h"

// main.c
#define MAX_DIR_LEVEL 20	// max directory tree depth
#define MAX_INCLUDE_LEVEL 10	// max include level for config files
extern int f_scanned;
extern int f_modified;
extern int f_new;
extern int f_removed;
extern int f_permissions;

// db.c
#define HASH_MAX 2048	// power of 2
int db_init(void);
void db_check(const char *fname, const char *checksum, const char *mode);
void db_missing(void);

// db_exclude.c
void db_exclude_add(const char *fname);
int db_exclude_check(const char *fname);


// blake2b.c
//#define KEY_SIZE 128 // key size in bytes
#define KEY_SIZE 256
//#define KEY_SIZE 512
int blake2b(void *out, size_t outlen, const void *in, size_t inlen);

#endif
