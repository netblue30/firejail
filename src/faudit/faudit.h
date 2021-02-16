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

#ifndef FAUDIT_H
#define FAUDIT_H
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <assert.h>

#define errExit(msg)    do { char msgout[500]; snprintf(msgout, 500, "Error %s:%s(%d)", msg, __FUNCTION__, __LINE__); perror(msgout); exit(1);} while (0)

// main.c
extern char *prog;

// pid.c
void pid_test(void);

// caps.c
void caps_test(void);

// seccomp.c
void seccomp_test(void);

// syscall.c
void syscall_helper(int argc, char **argv);
void syscall_run(const char *name);

// files.c
void files_test(void);

// network.c
void network_test(void);

// dbus.c
int check_unix(const char *sockfile);
void dbus_test(void);

// dev.c
void dev_test(void);

// x11.c
void x11_test(void);

#endif
