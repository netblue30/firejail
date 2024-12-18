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
#include "firejail.h"
#include <errno.h>
#include <signal.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#include <sys/syscall.h>
#ifndef __NR_pidfd_send_signal
#define __NR_pidfd_send_signal 424
#endif

#define BUFLEN 4096

struct processhandle_instance_t {
	pid_t pid;
	int fd;  // file descriptor referring to /proc/[PID]
};


ProcessHandle pin_process(pid_t pid) {
	EUID_ASSERT();

	ProcessHandle rv = malloc(sizeof(struct processhandle_instance_t));
	if (!rv)
		errExit("malloc");
	rv->pid = pid;

	char proc[64];
	snprintf(proc, sizeof(proc), "/proc/%d", pid);

	EUID_ROOT();
	int fd = open(proc, O_RDONLY|O_CLOEXEC);
	EUID_USER();
	if (fd < 0) {
		if (errno == ENOENT)
			fprintf(stderr, "Error: cannot find process with pid %d\n", pid);
		else
			fprintf(stderr, "Error: cannot open %s: %s\n", proc, strerror(errno));
		exit(1);
	}
	rv->fd = fd;

	return rv;
}

void unpin_process(ProcessHandle process) {
	close(process->fd);
	free(process);
}

pid_t process_get_pid(ProcessHandle process) {
	return process->pid;
}

int process_get_fd(ProcessHandle process) {
	return process->fd;
}

/*********************************************
 * access path in proc filesystem
 *********************************************/

int process_stat_nofail(ProcessHandle process, const char *fname, struct stat *s) {
	EUID_ASSERT();
	assert(fname[0] != '/');

	EUID_ROOT();
	int rv = fstatat(process_get_fd(process), fname, s, 0);
	EUID_USER();

	return rv;
}

int process_stat(ProcessHandle process, const char *fname, struct stat *s) {
	int rv = process_stat_nofail(process, fname, s);
	if (rv) {
		fprintf(stderr, "Error: cannot stat /proc/%d/%s: %s\n", process_get_pid(process), fname, strerror(errno));
		exit(1);
	}

	return rv;
}

int process_open_nofail(ProcessHandle process, const char *fname) {
	EUID_ASSERT();
	assert(fname[0] != '/');

	EUID_ROOT();
	int rv = openat(process_get_fd(process), fname, O_RDONLY|O_CLOEXEC);
	EUID_USER();

	return rv;
}

int process_open(ProcessHandle process, const char *fname) {
	int rv = process_open_nofail(process, fname);
	if (rv < 0) {
		fprintf(stderr, "Error: cannot open /proc/%d/%s: %s\n", process_get_pid(process), fname, strerror(errno));
		exit(1);
	}

	return rv;
}

FILE *process_fopen(ProcessHandle process, const char *fname) {
	int fd = process_open(process, fname);
	FILE *rv = fdopen(fd, "r");
	if (!rv)
		errExit("fdopen");

	return rv;
}

int process_join_namespace(ProcessHandle process, char *type) {
	return join_namespace_by_fd(process_get_fd(process), type);
}

/*********************************************
 * sending a signal
 *********************************************/

void process_send_signal(ProcessHandle process, int signum) {
	fmessage("Sending signal %d to pid %d\n", signum, process_get_pid(process));

	if (syscall(__NR_pidfd_send_signal, process_get_fd(process), signum, NULL, 0) == -1 && errno == ENOSYS)
		kill(process_get_pid(process), signum);
}

/*********************************************
 * parent and child process
 *********************************************/

static pid_t process_parent_pid(ProcessHandle process) {
	pid_t rv = 0;

	FILE *fp = process_fopen(process, "status");
	char buf[BUFLEN];
	while (fgets(buf, BUFLEN, fp)) {
		if (sscanf(buf, "PPid: %d", &rv) == 1)
			break;
	}
	fclose(fp);

	return rv;
}

static ProcessHandle pin_process_relative_to(ProcessHandle process, pid_t pid) {
	ProcessHandle rv = malloc(sizeof(struct processhandle_instance_t));
	if (!rv)
		errExit("malloc");
	rv->pid = pid;

	char proc[64];
	snprintf(proc, sizeof(proc), "../%d", pid);

	rv->fd = process_open(process, proc);

	return rv;
}

ProcessHandle pin_parent_process(ProcessHandle process) {
	ProcessHandle parent = pin_process_relative_to(process, process_parent_pid(process));
	return parent;
}

ProcessHandle pin_child_process(ProcessHandle process, pid_t child_pid) {
	ProcessHandle child = pin_process_relative_to(process, child_pid);

	// verify parent/child relationship
	if (process_parent_pid(child) != process_get_pid(process)) {
		fprintf(stderr, "Error: cannot find child process of pid %d\n", process_get_pid(process));
		exit(1);
	}

	return child;
}

/*********************************************
 * access process rootfs
 *********************************************/

void process_rootfs_chroot(ProcessHandle process) {
	if (fchdir(process_get_fd(process)) < 0)
		errExit("fchdir");

	int called_as_root = 0;
	if (geteuid() == 0)
		called_as_root = 1;
	if (called_as_root == 0)
		EUID_ROOT();

	if (chroot("root") < 0)
		errExit("chroot");

	if (called_as_root == 0)
		EUID_USER();

	if (chdir("/") < 0)
		errExit("chdir");
}

int process_rootfs_stat(ProcessHandle process, const char *fname, struct stat *s) {
	char *proc;
	if (asprintf(&proc, "root%s", fname) < 0)
		errExit("asprintf");

	int rv = process_stat_nofail(process, proc, s);

	free(proc);
	return rv;
}

int process_rootfs_open(ProcessHandle process, const char *fname) {
	char *proc;
	if (asprintf(&proc, "root%s", fname) < 0)
		errExit("asprintf");

	int rv = process_open_nofail(process, proc);

	free(proc);
	return rv;
}
