/*
 * Copyright (C) 2014-2019 Firejail Authors
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
#include "faudit.h"
#include <sys/socket.h>
#include <sys/un.h>

// return 0 if the connection is possible
int check_unix(const char *sockfile) {
	assert(sockfile);
	int rv = -1;

	// open socket
	int sock = socket(AF_UNIX, SOCK_STREAM, 0);
	if (sock == -1)
		return rv;

	// connect
	struct sockaddr_un remote;
	memset(&remote, 0, sizeof(struct sockaddr_un));
	remote.sun_family = AF_UNIX;
	strncpy(remote.sun_path, sockfile, sizeof(remote.sun_path));
	int len = strlen(remote.sun_path) + sizeof(remote.sun_family);
	if (*sockfile == '@')
		remote.sun_path[0] = '\0';
	if (connect(sock, (struct sockaddr *)&remote, len) == 0)
		rv = 0;

	close(sock);
	return rv;
}

void dbus_test(void) {
	// check the session bus
	char *str = getenv("DBUS_SESSION_BUS_ADDRESS");
	if (str) {
		int rv = 0;
		char *bus = strdup(str);
		if (!bus)
			errExit("strdup");
		char *sockfile;
		if ((sockfile = strstr(bus, "unix:abstract=")) != NULL) {
			sockfile += 13;
			*sockfile = '@';
			char *ptr = strchr(sockfile, ',');
			if (ptr)
				*ptr = '\0';
			rv = check_unix(sockfile);
			*sockfile = '@';
			if (rv == 0)
				printf("MAYBE: D-Bus socket %s is available\n", sockfile);
			else if (rv == -1)
				printf("GOOD: cannot connect to D-Bus socket %s\n", sockfile);
		}
		else if ((sockfile = strstr(bus, "unix:path=")) != NULL) {
			sockfile += 10;
			char *ptr = strchr(sockfile, ',');
			if (ptr)
				*ptr = '\0';
			rv = check_unix(sockfile);
			if (rv == 0)
				printf("MAYBE: D-Bus socket %s is available\n", sockfile);
			else if (rv == -1)
				printf("GOOD: cannot connect to D-Bus socket %s\n", sockfile);
		}
		else if ((sockfile = strstr(bus, "tcp:host=")) != NULL)
			printf("UGLY: session bus configured for TCP communication.\n");
		else
			printf("GOOD: cannot find a D-Bus socket\n");


		free(bus);
	}
	else
		printf("GOOD: DBUS_SESSION_BUS_ADDRESS environment variable not configured.");
}
