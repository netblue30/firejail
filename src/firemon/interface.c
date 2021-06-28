/*
 * Copyright (C) 2014-2021 Firejail Authors
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
#include "firemon.h"
#include "../include/gcov_wrapper.h"
#include <sys/types.h>
#include <sys/wait.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <linux/connector.h>
#include <linux/netlink.h>
#include <linux/if_link.h>
#include <linux/sockios.h>
#include <sys/ioctl.h>

//#include <net/route.h>
//#include <linux/if_bridge.h>

// print IP addresses for all interfaces
static void net_ifprint(void) {
	uint32_t ip;
	uint32_t mask;
	struct ifaddrs *ifaddr, *ifa;

	int fd;
	if ((fd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
		fprintf(stderr, "Error: cannot open AF_INET socket\n");
		exit(1);
	}

	if (getifaddrs(&ifaddr) == -1)
		errExit("getifaddrs");

	// walk through the linked list
	printf("  Link status:\n");
	for (ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
		if (ifa->ifa_addr == NULL)
			continue;

		if (ifa->ifa_addr->sa_family == AF_PACKET) {
			if (ifa->ifa_flags & IFF_RUNNING && ifa->ifa_flags & IFF_UP) {
				if (ifa->ifa_data != NULL) {
					struct rtnl_link_stats *stats = ifa->ifa_data;

					// extract mac address
					struct ifreq ifr;
					memset(&ifr, 0, sizeof(ifr));
					strncpy(ifr.ifr_name,  ifa->ifa_name, IFNAMSIZ - 1);
					int rv = ioctl (fd, SIOCGIFHWADDR, &ifr);

					if (rv == 0)
						printf("     %s UP, %02x:%02x:%02x:%02x:%02x:%02x\n",
							ifa->ifa_name, PRINT_MAC((unsigned char *) &ifr.ifr_hwaddr.sa_data));
					else
						printf("     %s UP\n", ifa->ifa_name);

					printf("          tx/rx: %u/%u packets,  %u/%u bytes\n",
						stats->tx_packets, stats->rx_packets,
						stats->tx_bytes, stats->rx_bytes);
				}
			}
			else
				printf("     %s DOWN\n", ifa->ifa_name);
		}
	}


	// walk through the linked list
	printf("  IPv4 status:\n");
	for (ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
		if (ifa->ifa_addr == NULL)
			continue;

		if (ifa->ifa_addr->sa_family == AF_INET) {
			struct sockaddr_in *si = (struct sockaddr_in *) ifa->ifa_netmask;
			mask = ntohl(si->sin_addr.s_addr);
			si = (struct sockaddr_in *) ifa->ifa_addr;
			ip = ntohl(si->sin_addr.s_addr);

			char *status;
			if (ifa->ifa_flags & IFF_RUNNING && ifa->ifa_flags & IFF_UP)
				status = "UP";
			else
				status = "DOWN";

			printf("     %s %s, %d.%d.%d.%d/%u\n",
				ifa->ifa_name, status, PRINT_IP(ip), mask2bits(mask));
		}
	}


	// walk through the linked list
	printf("  IPv6 status:\n");
	for (ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
		if (ifa->ifa_addr == NULL)
			continue;

		if (ifa->ifa_addr->sa_family == AF_INET6) {
			char host[NI_MAXHOST];
			int s = getnameinfo(ifa->ifa_addr, sizeof(struct sockaddr_in6),
				host, NI_MAXHOST, NULL, 0, NI_NUMERICHOST);
			if (s == 0) {
				char *ptr;
				if ((ptr = strchr(host, '%')) != NULL)
					*ptr = '\0';
				char *status;
				if (ifa->ifa_flags & IFF_RUNNING && ifa->ifa_flags & IFF_UP)
					status = "UP";
				else
					status = "DOWN";

				printf("     %s %s, %s\n", ifa->ifa_name, status, host);
			}
		}
	}

	freeifaddrs(ifaddr);
	close(fd);
}

static void print_sandbox(pid_t pid) {
	pid_t child = fork();
	if (child == -1)
		return;

	if (child == 0) {
		int rv = join_namespace(pid, "net");
		if (rv)
			return;
		net_ifprint();

		__gcov_flush();

		_exit(0);
	}

	// wait for the child to finish
	waitpid(child, NULL, 0);
}

void interface(pid_t pid, int print_procs) {
	pid_read(pid); // a pid of 0 will include all processes

	// print processes
	int i;
	for (i = 0; i < max_pids; i++) {
		if (pids[i].level == 1) {
			if (print_procs || pid == 0)
				pid_print_list(i, arg_wrap);
			int child = find_child(i);
			if (child != -1) {
				print_sandbox(child);
			}
		}
	}
	printf("\n");
}
