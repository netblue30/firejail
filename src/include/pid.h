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
#ifndef PID_H
#define PID_H
extern int max_pids;


#define _GNU_SOURCE
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
typedef struct {
	short level;  // -1 not a firejail process, 0 not investigated yet, 1 firejail process, > 1 firejail child
	unsigned char zombie;
	pid_t parent;
	uid_t uid;

	union {
		struct event_t {
			char *user;
			char *cmd;
		} event;

		struct top_t {
			unsigned utime;
			unsigned stime;
		} top;

		struct netstats_t {
			unsigned long long rx;	// network rx, bytes
			unsigned long long tx;	// networking tx, bytes
		} netstats;
	} option;
} Process;
//extern Process pids[max_pids];
extern Process *pids;

// pid functions
void pid_getmem(unsigned pid, unsigned *rss, unsigned *shared);
void pid_get_cpu_time(unsigned pid, unsigned *utime, unsigned *stime);
unsigned long long pid_get_start_time(unsigned pid);
uid_t pid_get_uid(pid_t pid);
char *pid_get_user_name(uid_t uid);
// print functions
void pid_print_tree(unsigned index, unsigned parent, int nowrap);
void pid_print_list(unsigned index, int nowrap);
void pid_read(pid_t mon_pid);

#endif
