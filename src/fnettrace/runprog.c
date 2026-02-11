/*
 * Copyright (C) 2014-2026 Firejail Authors
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
#include "fnettrace.h"
#include <signal.h>

typedef struct pidlist_t {
	struct pidlist_t *next;
	pid_t pid;
} PidList;

static PidList *pidlist = NULL;

static void add(pid_t pid) {
	assert(pid);

	PidList *p = malloc(sizeof(PidList));
	if (!p)
		errExit("malloc");
	p->pid = pid;
	p->next = pidlist;
	pidlist = p;
}


int runprog(const char *program) {
	int fd[2]; // child tx on fd[1], parent rx on fd[0]
	if (pipe(fd))
		errExit("pipe");

	pid_t pid = fork();
	if(pid == -1)
		errExit("fork");
	else if (pid == 0) {
		close(fd[0]);
		dup2(fd[1], 1); // connect child stdout to fd[1]
		execl(program, program, NULL);
		exit(0);
	}
	else {
		close(fd[1]);
		add(pid);
        }

	return fd[0];
}

void killprogs(void) {
	PidList *p = pidlist;
	while (p) {
		assert(p->pid);
		kill(p->pid, SIGKILL);
		p = p->next;
	}
}
		
