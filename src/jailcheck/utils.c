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
#include "jailcheck.h"
#include "../include/pid.h"
#include <errno.h>
#include <pwd.h>
#include <dirent.h>

#define BUFLEN 4096

char *get_sudo_user(void) {
	char *doas_user = getenv("DOAS_USER");
	char *sudo_user = getenv("SUDO_USER");
	char *user = doas_user ? doas_user : sudo_user;

	if (!user) {
		user = getpwuid(getuid())->pw_name;
		if (!user) {
			fprintf(stderr, "Error: cannot detect login user\n");
			exit(1);
		}
	}

	return user;
}

char *get_homedir(const char *user, uid_t *uid, gid_t *gid) {
	// find home directory
	struct passwd *pw = getpwnam(user);
	if (!pw)
		goto errexit;

	char *home = pw->pw_dir;
	if (!home)
		goto errexit;

	*uid = pw->pw_uid;
	*gid = pw->pw_gid;

	return home;

errexit:
	fprintf(stderr, "Error: cannot find home directory for user %s\n", user);
	exit(1);
}

// find the second child process for the specified pid
// return -1 if not found
//
// Example:
//14776:netblue:/usr/bin/firejail /usr/bin/transmission-qt
//  14777:netblue:/usr/bin/firejail /usr/bin/transmission-qt
//    14792:netblue:/usr/bin/transmission-qt
// We need 14792, the first real sandboxed process
// duplicate from src/firemon/main.c
int find_child(int id) {
	int i;
	int first_child = -1;

	// find the first child
	for (i = 0; i < max_pids; i++) {
		if (pids[i].level == 2 && pids[i].parent == id) {
			// skip /usr/bin/xdg-dbus-proxy (started by firejail for dbus filtering)
			char *cmdline = pid_proc_cmdline(i);
			if (strncmp(cmdline, XDG_DBUS_PROXY_PATH, strlen(XDG_DBUS_PROXY_PATH)) == 0) {
				free(cmdline);
				continue;
			}
			free(cmdline);
			first_child = i;
			break;
		}
	}

	if (first_child == -1)
		return -1;

	// find the second-level child
	for (i = 0; i < max_pids; i++) {
		if (pids[i].level == 3 && pids[i].parent == first_child)
			return i;
	}

	// if a second child is not found, return the first child pid
	// this happens for processes sandboxed with --join
	return first_child;
}
