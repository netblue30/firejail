/*
 * Copyright (C) 2014-2016 Firejail Authors
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

void check_session_bus(const char *sockfile) {
	assert(sockfile);
	
	// open socket
	int sock = socket(AF_UNIX, SOCK_STREAM, 0);
	if (sock == -1) {
		printf("GOOD: I cannot connect to session bus. If the application misbehaves, please log a bug with the application developer.\n");
		return;
	}

	// connect
	struct sockaddr_un remote;
	memset(&remote, 0, sizeof(struct sockaddr_un));
	remote.sun_family = AF_UNIX;
	strcpy(remote.sun_path, sockfile);
	int len = strlen(remote.sun_path) + sizeof(remote.sun_family);
	remote.sun_path[0] = '\0';
	if (connect(sock, (struct sockaddr *)&remote, len) == -1) {
		printf("GOOD: I cannot connect to session bus. If the application misbehaves, please log a bug with the application developer.\n");
	}
	else {
		printf("MAYBE: I can connect to session bus. If this is undesirable, use \"--private-tmp\" or blacklist the socket file.\n");
	}	

	close(sock);
}

void dbus_test(void) {
	// check the session bus
	char *str = getenv("DBUS_SESSION_BUS_ADDRESS");
	if (str) {
		char *bus = strdup(str);
		if (!bus)
			errExit("strdup");
		char *sockfile = strstr(bus, "unix:abstract=");
		if (sockfile) {
			sockfile += 13;
			*sockfile = '@';
			char *ptr = strchr(sockfile, ',');
			if (ptr) {
				*ptr = '\0';	
				check_session_bus(sockfile);
			}
			sockfile -= 13;
			free(sockfile);
		}
	}
}



