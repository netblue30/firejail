/*
 * Copyright (C) 2014-2022 Firejail Authors
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
#include <stdlib.h>
#include <unistd.h>
#include <netdb.h>
#include <netinet/in.h>
#include <string.h>


int main(int argc, char **argv) {
	int fd, newfd, client_len;
	struct sockaddr_in serv_addr, client_addr;
	int n, pid;

	if (argc < 2) {
		printf("Usage: ./server port-number\n");
		return 1;
	}
	int portno = atoi(argv[1]);

	// init socket
	fd = socket(AF_INET, SOCK_STREAM, 0);
	if (fd < 0) {
		perror("ERROR opening socket");
		return 1;
	}

	// Initialize socket structure
	memset(&serv_addr, 0, sizeof(serv_addr));

	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = INADDR_ANY;
	serv_addr.sin_port = htons(portno);

	// bind
	if (bind(fd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0) {
		perror("bind");
		return 1;
	}

	// listen - 5 pending conncections
	if (listen(fd, 5) < 0) {
		perror("listen");
		return 1;
	}
	client_len = sizeof(client_addr);

	while (1) {
		newfd = accept(fd, (struct sockaddr *) &client_addr, &client_len);

		if (newfd < 0) {
			perror("accept");
			return 1;
		}

		/* Create child process */
		pid = fork();

		if (pid < 0) {
			perror("fork");
			return 1;
		}

		if (pid == 0) {
			// child
			close(fd);
#define MAXBUF 4096
			char buf[MAXBUF];
			memset(buf, 0, MAXBUF);

			int rcv = read(newfd, buf, MAXBUF - 1);
			if (rcv < 0) {
				perror("read");
				exit(1);
			}

			int sent = write(newfd, "response\n", 9);
			if (sent < 9) {
				perror("write");
				return 1;
			}

			exit(0);
		}
		else
			close(newfd);
	}

	return 0;
}
