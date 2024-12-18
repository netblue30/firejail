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
#ifndef FIREMON_H
#define FIREMON_H
#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
#include <stdint.h>
#include "../include/pid.h"
#include "../include/common.h"

// main.c
extern int arg_debug;

// clear screen
static inline void firemon_clrscr(void) {
	printf("\033[2J\033[1;1H");
	fflush(0);
}

// firemon.c
extern pid_t skip_process;
extern int arg_wrap;
int find_child(int id);
void firemon_sleep(int st);


// procevent.c
void procevent(pid_t pid) __attribute__((noreturn));

// usage.c
void print_version(void);
void usage(void);

// top.c
void top(void) __attribute__((noreturn));

// list.c
void list(void);

// arp.c
void arp(pid_t pid, int print_procs);

// route.c
void route(pid_t pid, int print_procs);

// caps.c
void caps(pid_t pid, int print_procs);

// seccomp.c
void seccomp(pid_t pid, int print_procs);

// cpu.c
void cpu(pid_t pid, int print_procs);

// tree.c
void tree(pid_t pid);

// netstats.c
void netstats(void) __attribute__((noreturn));

// x11.c
void x11(pid_t pid, int print_procs);

//apparmor.c
void apparmor(pid_t pid, int print_procs);

#endif
