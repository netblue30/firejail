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

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>

int main(void) {
	struct sockaddr_un addr;
	int s;
	const char *socketpath = "/var/run/minissdpd.sock";
//	const char *socketpath = "/var/run/acipd.sock";

	s = socket(AF_UNIX, SOCK_STREAM, 0);
	if(s < 0) {
		fprintf(stderr, "Error: cannot open socket\n");
		return 1;
	}

	addr.sun_family = AF_UNIX;
	strncpy(addr.sun_path, socketpath, sizeof(addr.sun_path));
	if(connect(s, (struct sockaddr *)&addr, sizeof(struct sockaddr_un)) < 0) {
		fprintf(stderr, "Error: cannot connect to socket\n");
		return 1;
	}

	printf("connected to %s\n", socketpath);
	close(s);

	return 0;
}
