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
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/un.h>
#include <sys/stat.h>
#include <dirent.h>
#include <errno.h>

//#define DEBUG

//static int check_sockaddr(int sockfd, const char *call, const struct sockaddr *addr, int rv) {
static int check_sockaddr(const struct sockaddr *addr) {
	if (addr->sa_family == AF_UNIX) {
		struct sockaddr_un *a = (struct sockaddr_un *) addr;
		if (a->sun_path[0] == '\0' && strstr(a->sun_path + 1, "X11-unix")) {
//			printf("@%s\n", a->sun_path + 1);
			errno = ENOENT;
			return -1;
		}
	}
	
	return 0;
}

//
// syscalls
//

// connect
typedef int (*orig_connect_t)(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
static orig_connect_t orig_connect = NULL;
int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen) {
	if (!orig_connect)
		orig_connect = (orig_connect_t)dlsym(RTLD_NEXT, "connect");
			
	if (check_sockaddr(addr) == -1)
		return -1;
		
 	return orig_connect(sockfd, addr, addrlen);
}
