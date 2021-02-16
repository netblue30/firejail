// This file is part of Firejail project
// Copyright (C) 2014-2021 Firejail Authors
// License GPL v2

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <linux/netlink.h>
#include <net/ethernet.h>
#include <sys/mount.h>

int main(int argc, char **argv) {
	if (argc != 2) {
		printf("Usage: test [sleep|socket|mkdir|mount]\n");
		return 1;
	}

	if (strcmp(argv[1], "sleep") == 0) {
		printf("before sleep\n");
		sleep(1);
		printf("after sleep\n");
	}
	else if (strcmp(argv[1], "socket") == 0) {
		int sock;

		printf("testing socket AF_INET\n");
		if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
			perror("socket");
		}
		else
			close(sock);

		printf("testing socket AF_INET6\n");
		if ((sock = socket(AF_INET6, SOCK_STREAM, 0)) < 0) {
			perror("socket");
		}
		else
			close(sock);

		printf("testing socket AF_NETLINK\n");
		if ((sock = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE)) < 0) {
			perror("socket");
		}
		else
			close(sock);

		printf("testing socket AF_UNIX\n");
		if ((sock = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
			perror("socket");
		}
		else
			close(sock);

		// root needed to be able to handle this
		printf("testing socket AF_PACKETX\n");
		if ((sock = socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_ARP))) < 0) {
			perror("socket");
		}
		else
			close(sock);
		printf("after socket\n");
	}
	else if (strcmp(argv[1], "mkdir") == 0) {
		printf("before mkdir\n");
		mkdir("tmp", 0777);
		printf("after mkdir\n");
	}
	else if (strcmp(argv[1], "mount") == 0) {
		printf("before mount\n");
		if (mount("tmpfs", "/tmp", "tmpfs", MS_NOSUID | MS_STRICTATIME,  "mode=755,gid=0") < 0) {
			perror("mount");
		}
		printf("after mount\n");
	}
	else {
		fprintf(stderr, "Error: invalid argument\n");
		return 1;
	}
	return 0;
}
