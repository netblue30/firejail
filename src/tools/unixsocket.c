// This file is part of Firejail project
// Copyright (C) 2014-2020 Firejail Authors
// License GPL v2
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
