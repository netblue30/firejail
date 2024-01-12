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
#ifndef FSECCOMP_H
#define FSECCOMP_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "../include/common.h"
#include "../include/syscall.h"

// main.c
extern int arg_quiet;

// protocol.c
void protocol_print(void);
void protocol_build_filter(const char *prlist, const char *fname);

// seccomp_secondary.c
void seccomp_secondary_64(const char *fname);
void seccomp_secondary_32(const char *fname);
void seccomp_secondary_block(const char *fname);

// seccomp_file.c
void write_to_file(int fd, const void *data, size_t size);
void filter_init(int fd, bool native);
void filter_add_whitelist(int fd, int syscall, int arg, void *ptrarg, bool native);
void filter_add_whitelist_for_excluded(int fd, int syscall, int arg, void *ptrarg, bool native);
void filter_add_blacklist(int fd, int syscall, int arg, void *ptrarg, bool native);
void filter_add_blacklist_for_excluded(int fd, int syscall, int arg, void *ptrarg, bool native);
void filter_end_blacklist(int fd);
void filter_end_whitelist(int fd);

// seccomp.c
// default list
void seccomp_default(const char *fname, int allow_debuggers, bool native);
// drop list
void seccomp_drop(const char *fname1, const char *fname2, char *list, int allow_debuggers, bool native);
// default+drop list
void seccomp_default_drop(const char *fname1, const char *fname2, char *list, int allow_debuggers, bool native);
// whitelisted filter
void seccomp_keep(const char *fname1, const char *fname2, char *list, bool native);
// block writable and executable memory
void memory_deny_write_execute(const char *fname);
void memory_deny_write_execute_32(const char *fname);

// namespaces.c
void deny_ns(const char *fname, const char *list);
void deny_ns_32(const char *fname, const char *list);

// seccomp_print
void filter_print(const char *fname);

#endif
