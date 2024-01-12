/*
 * Copyright (C) 2020-2024 Firejail Authors
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
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <dirent.h>
#include <fcntl.h>
#include <sched.h>
#include <unistd.h>

static char *netns_control_file(const char *nsname) {
	char *rv = 0;
	if (asprintf(&rv, "/var/run/netns/%s", nsname) <= 0)
		errExit("asprintf");
	return rv;
}

static char *netns_etc_dir(const char *nsname) {
	char *rv = 0;
	if (asprintf(&rv, "/etc/netns/%s", nsname) <= 0)
		errExit("asprintf");
	return rv;
}

void check_netns(const char *nsname) {
	if (strchr(nsname, '/') || strstr(nsname, "..")) {
		fprintf(stderr, "Error: invalid netns name %s\n", nsname);
		exit(1);
	}
	invalid_filename(nsname, 0); // no globbing
	char *control_file = netns_control_file(nsname);

	EUID_ASSERT();

	struct stat st;
	if (lstat(control_file, &st)) {
		fprintf(stderr, "Error: invalid netns '%s' (%s: %s)\n",
			nsname, control_file, strerror(errno));
		exit(1);
	}
	if (!S_ISREG(st.st_mode) && !S_ISLNK(st.st_mode)) {
		fprintf(stderr, "Error: invalid netns '%s' (%s: not a regular file)\n",
			nsname, control_file);
		exit(1);
	}
	free(control_file);
}

void netns(const char *nsname) {
	char *control_file = netns_control_file(nsname);
	int nsfd = open(control_file, O_RDONLY|O_CLOEXEC);
	if (nsfd < 0) {
		fprintf(stderr, "Error: cannot open netns '%s' (%s: %s)\n",
			nsname, control_file, strerror(errno));
		exit(1);
	}
	if (syscall(__NR_setns, nsfd, CLONE_NEWNET) < 0) {
		fprintf(stderr, "Error: cannot join netns '%s': %s\n",
			nsname, strerror(errno));
		exit(1);
	}
	close(nsfd);
	free(control_file);
}

void netns_mounts(const char *nsname) {
	char *etcdir = netns_etc_dir(nsname);
	char *netns_name, *etc_name;
	struct dirent *entry;
	DIR *dir;

	dir = opendir(etcdir);
	if (!dir) {
		free(etcdir);
		return;
	}
	while ((entry = readdir(dir))) {
		if (!strcmp(entry->d_name, ".") || !strcmp(entry->d_name, ".."))
			continue;
		if (asprintf(&netns_name, "%s/%s", etcdir, entry->d_name) < 0 ||
		    asprintf(&etc_name, "/etc/%s", entry->d_name) < 0)
			errExit("asprintf");
		if (mount(netns_name, etc_name, "none", MS_BIND, 0) < 0) {
			fwarning("bind %s -> %s failed: %s\n",
				netns_name, etc_name, strerror(errno));
		}
		free(netns_name);
		free(etc_name);
	}
	closedir(dir);
	free(etcdir);
}
