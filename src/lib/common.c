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
#define _GNU_SOURCE
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <sys/syscall.h>
#include <errno.h>
#include <unistd.h>
#include <sys/prctl.h>
#include <signal.h>
#include <dirent.h>
#include <string.h>
#include <time.h>
#include "../include/common.h"
#define BUFLEN 4096

int join_namespace(pid_t pid, char *type) {
	char *path;
	if (asprintf(&path, "/proc/%u/ns/%s", pid, type) == -1)
		errExit("asprintf");

	int fd = open(path, O_RDONLY);
	if (fd < 0)
		goto errout;

	if (syscall(__NR_setns, fd, 0) < 0) {
		close(fd);
		goto errout;
	}

	close(fd);
	free(path);
	return 0;

errout:
	free(path);
	fprintf(stderr, "Error: cannot join namespace %s\n", type);
	return -1;

}

// return 1 if error
// this function requires root access - todo: fix it!
int name2pid(const char *name, pid_t *pid) {
	pid_t parent = getpid();

	DIR *dir;
	if (!(dir = opendir("/proc"))) {
		// sleep 2 seconds and try again
		sleep(2);
		if (!(dir = opendir("/proc"))) {
			fprintf(stderr, "Error: cannot open /proc directory\n");
			exit(1);
		}
	}

	struct dirent *entry;
	char *end;
	while ((entry = readdir(dir))) {
		pid_t newpid = strtol(entry->d_name, &end, 10);
		if (end == entry->d_name || *end)
			continue;
		if (newpid == parent)
			continue;

		// check if this is a firejail executable
		char *comm = pid_proc_comm(newpid);
		if (comm) {
			if (strcmp(comm, "firejail")) {
				free(comm);
				continue;
			}
			free(comm);
		}

		// look for the sandbox name in /run/firejail/name/<PID>
		// todo: use RUN_FIREJAIL_NAME_DIR define from src/firejail/firejail.h
		char *fname;
		if (asprintf(&fname, "/run/firejail/name/%d", newpid) == -1)
			errExit("asprintf");
		FILE *fp = fopen(fname, "r");
		if (fp) {
			char buf[BUFLEN];
			if (fgets(buf, BUFLEN, fp)) {
				// remove \n
				char *ptr = strchr(buf, '\n');
				if (ptr) {
					*ptr = '\0';
					if (strcmp(buf, name) == 0) {
						// we found it!
						fclose(fp);
						free(fname);
						*pid = newpid;
						closedir(dir);
						return 0;
					}
				}
				else
					fprintf(stderr, "Error: invalid %s\n", fname);
			}
			fclose(fp);
		}
		free(fname);
	}
	closedir(dir);
	return 1;
}

char *pid_proc_comm(const pid_t pid) {
	// open /proc/pid/cmdline file
	char *fname;
	int fd;
	if (asprintf(&fname, "/proc/%d/comm", pid) == -1)
		return NULL;
	if ((fd = open(fname, O_RDONLY)) < 0) {
		free(fname);
		return NULL;
	}
	free(fname);

	// read file
	char buffer[BUFLEN];
	ssize_t len;
	if ((len = read(fd, buffer, sizeof(buffer) - 1)) <= 0) {
		close(fd);
		return NULL;
	}
	buffer[len] = '\0';
	close(fd);

	// remove \n
	char *ptr = strchr(buffer, '\n');
	if (ptr)
		*ptr = '\0';

	// return a malloc copy of the command line
	char *rv = strdup(buffer);
	if (!rv)
		return NULL;
	if (strlen(rv) == 0) {
		free(rv);
		return NULL;
	}
	return rv;
}

char *pid_proc_cmdline(const pid_t pid) {
	// open /proc/pid/cmdline file
	char *fname;
	int fd;
	if (asprintf(&fname, "/proc/%d/cmdline", pid) == -1)
		return NULL;
	if ((fd = open(fname, O_RDONLY)) < 0) {
		free(fname);
		return NULL;
	}
	free(fname);

	// read file
	unsigned char buffer[BUFLEN];
	ssize_t len;
	if ((len = read(fd, buffer, sizeof(buffer) - 1)) <= 0) {
		close(fd);
		return NULL;
	}
	buffer[len] = '\0';
	close(fd);

	// clean data
	int i;
	for (i = 0; i < len; i++) {
		if (buffer[i] == '\0')
			buffer[i] = ' ';
	}

	// return a malloc copy of the command line
	char *rv = strdup((char *) buffer);
	if (!rv)
		return NULL;
	if (strlen(rv) == 0) {
		free(rv);
		return NULL;
	}
	return rv;
}

// return 1 if firejail --x11 on command line
int pid_proc_cmdline_x11_xpra_xephyr(const pid_t pid) {
	// if comm is not firejail return 0
	char *comm = pid_proc_comm(pid);
	if (comm == NULL)
		return 0;
	if (strcmp(comm, "firejail") != 0) {
		free(comm);
		return 0;
	}
	free(comm);

	// open /proc/pid/cmdline file
	char *fname;
	int fd;
	if (asprintf(&fname, "/proc/%d/cmdline", pid) == -1)
		return 0;
	if ((fd = open(fname, O_RDONLY)) < 0) {
		free(fname);
		return 0;
	}
	free(fname);

	// read file
	unsigned char buffer[BUFLEN];
	ssize_t len;
	if ((len = read(fd, buffer, sizeof(buffer) - 1)) <= 0) {
		close(fd);
		return 0;
	}
	buffer[len] = '\0';
	close(fd);

	// skip the first argument
	int i;
	for (i = 0; buffer[i] != '\0'; i++);

	// parse remaining command line options
	while (1) {
		// extract argument
		i++;
		if (i >= len)
			break;
		char *arg = (char *)buffer + i;

		// detect the last command line option
		if (strcmp(arg, "--") == 0)
			break;
		if (strncmp(arg, "--", 2) != 0)
			break;

		if (strcmp(arg, "--x11=xorg") == 0 || strcmp(arg, "--x11=none") == 0)
			return 0;

		// check x11 xpra or xephyr
		if (strncmp(arg, "--x11", 5) == 0)
			return 1;
		i += strlen(arg);
	}
	return 0;
}

// return 1 if /proc is mounted hidepid, or if /proc/mouns access is denied
int pid_hidepid(void) {
	FILE *fp = fopen("/proc/mounts", "r");
	if (!fp)
		return 1;

	char buf[BUFLEN];
	while (fgets(buf, BUFLEN, fp)) {
		if (strstr(buf, "proc /proc proc")) {
			fclose(fp);
			// check hidepid
			if (strstr(buf, "hidepid="))
				return 1;
			return 0;
		}
	}

	fclose(fp);
	return 0;
}

// print error if unprivileged users can trace the process
void warn_dumpable(void) {
	if (getuid() != 0 && prctl(PR_GET_DUMPABLE, 0, 0, 0, 0) == 1 && getenv("FIREJAIL_PLUGIN")) {
		fprintf(stderr, "Error: dumpable process\n");

		// best effort to provide detailed debug information
		// cannot use process name, it is just a file descriptor number
		char path[BUFLEN];
		ssize_t len = readlink("/proc/self/exe", path, BUFLEN - 1);
		if (len < 0)
			return;
		path[len] = '\0';
		// path can refer to a sandbox mount namespace, use basename only
		const char *base = gnu_basename(path);

		struct stat s;
		if (stat("/proc/self/exe", &s) == 0 && s.st_uid != 0)
			fprintf(stderr, "Change owner of %s executable to root\n", base);
		else if (access("/proc/self/exe", R_OK) == 0)
			fprintf(stderr, "Remove read permission on %s executable\n", base);
	}
}

// Equivalent to the GNU version of basename, which is incompatible with
// the POSIX basename. A few lines of code saves any portability pain.
// https://www.gnu.org/software/libc/manual/html_node/Finding-Tokens-in-a-String.html#index-basename
const char *gnu_basename(const char *path) {
	const char *last_slash = strrchr(path, '/');
	if (!last_slash)
		return path;
	return last_slash+1;
}

//**************************
// time trace based on getticks function
//**************************
typedef struct list_entry_t {
	struct list_entry_t *next;
	struct timespec ts;
} ListEntry;

static ListEntry *ts_list = NULL;

static inline float msdelta(struct timespec *start, struct timespec *end) {
	unsigned sec = end->tv_sec - start->tv_sec;
	long nsec = end->tv_nsec - start->tv_nsec;
	return (float) sec * 1000 + (float) nsec / 1000000;
}

void timetrace_start(void) {
	ListEntry *t = malloc(sizeof(ListEntry));
	if (!t)
		errExit("malloc");
	memset(t, 0, sizeof(ListEntry));
	clock_gettime(CLOCK_MONOTONIC, &t->ts);

	// add it to the list
	t->next = ts_list;
	ts_list = t;
}

float timetrace_end(void) {
	if (!ts_list)
		return 0;

	// remove start time  from the list
	ListEntry *t = ts_list;
	ts_list = t->next;

	struct timespec end;
	clock_gettime(CLOCK_MONOTONIC, &end);
	float rv = msdelta(&t->ts, &end);
	free(t);
	return rv;
}
