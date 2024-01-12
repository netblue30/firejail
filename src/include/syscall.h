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
#ifndef SYSCALL_H
#define SYSCALL_H

#include <stdbool.h>

// main.c
extern int arg_quiet;

// seccomp_file.c or dummy versions in firejail/main.c and fsec-print/main.c
void filter_add_errno(int fd, int syscall, int arg, void *ptrarg, bool native);
void filter_add_blacklist_override(int fd, int syscall, int arg, void *ptrarg, bool native);

// errno.c
void errno_print(void);
int errno_find_name(const char *name);
const char *errno_find_nr(int nr);

// syscall.c
void syscall_print(void);
void syscall_print_32(void);
typedef void (filter_fn)(int fd, int syscall, int arg, void *ptrarg, bool native);
int syscall_check_list(const char *slist, filter_fn *callback, int fd, int arg, void *ptrarg, bool native);
const char *syscall_find_nr(int nr);
void syscalls_in_list(const char *list, const char *slist, int fd, char **prelist, char **postlist, bool native);

#endif
