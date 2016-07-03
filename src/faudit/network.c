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
#include <arpa/inet.h>

void check_ssh(void) {
	printf("INFO: looking for ssh servers running on localhost\n");
	
	// open socket
	int sock = socket(AF_INET, SOCK_STREAM, 0);
	if (sock == -1) {
		printf("Error: cannot create an IPv4 socket\n");
		return;
	}

	// connect to localhost
	struct sockaddr_in server;
	server.sin_addr.s_addr = inet_addr("127.0.0.1");
	server.sin_family = AF_INET;
	server.sin_port = htons(22);	
	
	if (connect(sock , (struct sockaddr *)&server , sizeof(server)) < 0)
		printf("GOOD: SSH server not available on localhost\n");
	else {
		printf("MAYBE: an SSH server is accessible on localhost\n");
		printf("It could be a good idea to create a new network namespace using \"--net=none\" or \"--net=eth0\".\n");
	}
	
	close(sock);
}
	
void network_test(void) {
	check_ssh();
}
