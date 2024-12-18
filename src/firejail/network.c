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
#include "firejail.h"
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <net/if_arp.h>
#include <net/route.h>
#include <linux/if_bridge.h>

// return 1 if addr is a IPv4 or IPv6 address
int check_ip46_address(const char *addr) {
	// check ipv4 address
	uint32_t tmp;
	if (atoip(addr, &tmp) == 0)
		return 1;

	// check ipv6 address
	struct in6_addr result;

	char *tmpstr = strdup(addr);
	if (!tmpstr)
		errExit("strdup");
	char *ptr = strchr(tmpstr, '/');
	if (ptr) {
		*ptr = '\0';
		ptr++;
		int mask = atoi(ptr);
		// check the network mask
		if (mask < 0 || mask > 128) {
			free(tmpstr);
			return 0;
		}
	}
	if (inet_pton(AF_INET6, tmpstr, &result) == 1) {
		free(tmpstr);
		return 1;
	}

	free(tmpstr);

	// failed
	return 0;
}

int net_get_mtu(const char *ifname) {
	int mtu = 0;
	if (strlen(ifname) > IFNAMSIZ) {
		fprintf(stderr, "Error: invalid network device name %s\n", ifname);
		exit(1);
	}

	int s;
	struct ifreq ifr;

	if ((s = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
		errExit("socket");

	memset(&ifr, 0, sizeof(ifr));
	ifr.ifr_addr.sa_family = AF_INET;
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ - 1);
	if (ioctl(s, SIOCGIFMTU, (caddr_t)&ifr) == 0)
		mtu = ifr.ifr_mtu;
	if (arg_debug)
		printf("MTU of %s is %d.\n", ifname, ifr.ifr_mtu);
	close(s);


	return mtu;
}

// return -1 if the interface was not found; if the interface was found return 0 and fill in IP address and mask
int net_get_if_addr(const char *bridge, uint32_t *ip, uint32_t *mask, uint8_t mac[6], int *mtu) {
	assert(bridge);
	assert(ip);
	assert(mask);

	if (arg_debug)
		printf("get interface %s configuration\n", bridge);

	int rv = -1;
	struct ifaddrs *ifaddr, *ifa;

	if (getifaddrs(&ifaddr) == -1)
		errExit("getifaddrs");

	// walk through the linked list; if the interface is found, extract IP address and mask
	for (ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
		if (ifa->ifa_addr == NULL)
			continue;
		if (strcmp(ifa->ifa_name, bridge) != 0)
			continue;

		if (ifa->ifa_addr->sa_family == AF_INET) {
			struct sockaddr_in *si = (struct sockaddr_in *) ifa->ifa_netmask;
			*mask = ntohl(si->sin_addr.s_addr);
			si = (struct sockaddr_in *) ifa->ifa_addr;
			*ip = ntohl(si->sin_addr.s_addr);
			if (strcmp(ifa->ifa_name, "lo") != 0) {
				net_get_mac(ifa->ifa_name, mac);
				*mtu = net_get_mtu(bridge);
			}

			rv = 0;
			break;
		}
	}

	freeifaddrs(ifaddr);
	return rv;
}

// bring interface up
void net_if_up(const char *ifname) {
	if (strlen(ifname) > IFNAMSIZ) {
		fprintf(stderr, "Error: invalid network device name %s\n", ifname);
		exit(1);
	}
	sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 3,
		PATH_FNET, "ifup", ifname);
}


// configure interface ipv6 address
// ex: firejail --net=eth0 --ip6=2001:0db8:0:f101::1/64
void net_if_ip6(const char *ifname, const char *addr6) {
	if (strchr(addr6, ':') == NULL) {
		fprintf(stderr, "Error: invalid IPv6 address %s\n", addr6);
		exit(1);
	}

	sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 5,
		PATH_FNET, "config", "ipv6", ifname, addr6);

}

// add an IP route, return -1 if error, 0 if the route was added
int net_add_route(uint32_t ip, uint32_t mask, uint32_t gw) {
	int sock;
	struct rtentry route;
	struct sockaddr_in *addr;

	// create the socket
	if((sock = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
		errExit("socket");

	memset(&route, 0, sizeof(route));

	addr = (struct sockaddr_in*) &route.rt_gateway;
	addr->sin_family = AF_INET;
	addr->sin_addr.s_addr = htonl(gw);

	addr = (struct sockaddr_in*) &route.rt_dst;
	addr->sin_family = AF_INET;
	addr->sin_addr.s_addr = htonl(ip);

	addr = (struct sockaddr_in*) &route.rt_genmask;
	addr->sin_family = AF_INET;
	addr->sin_addr.s_addr = htonl(mask);

	route.rt_flags = RTF_UP | RTF_GATEWAY;
	route.rt_metric = 0;
	if (ioctl(sock, SIOCADDRT, &route) != 0) {
		close(sock);
		return -1;
	}

	close(sock);
	return 0;
}



#define BUFSIZE 1024
uint32_t network_get_defaultgw(void) {
	FILE *fp = fopen("/proc/self/net/route", "re");
	if (!fp)
		errExit("fopen");

	char buf[BUFSIZE];
	uint32_t retval = 0;
	while (fgets(buf, BUFSIZE, fp)) {
		if (strncmp(buf, "Iface", 5) == 0)
			continue;

		char *ptr = buf;
		while (*ptr != ' ' && *ptr != '\t' && *ptr != '\0')
			ptr++;
		while (*ptr == ' ' || *ptr == '\t')
			ptr++;

		unsigned dest;
		unsigned gw;
		int rv = sscanf(ptr, "%x %x", &dest, &gw);
		if (rv == 2 && dest == 0) {
			retval = ntohl(gw);
			break;
		}
	}

	fclose(fp);
	return retval;
}

int net_config_mac(const char *ifname, const unsigned char mac[6]) {
	char *macstr;
	if (asprintf(&macstr, "%02x:%02x:%02x:%02x:%02x:%02x",
		mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]) == -1)
		errExit("asprintf");

	sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 5,
		PATH_FNET, "config", "mac", ifname, macstr);

	free(macstr);
	return 0;
}

int net_get_mac(const char *ifname, unsigned char mac[6]) {

	struct ifreq ifr;
	int sock;

	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
		errExit("socket");

	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ - 1);
	ifr.ifr_hwaddr.sa_family = ARPHRD_ETHER;

	if (ioctl(sock, SIOCGIFHWADDR, &ifr) == -1)
		errExit("ioctl");
	memcpy(mac, ifr.ifr_hwaddr.sa_data, 6);

	close(sock);
	return 0;
}

void net_config_interface(const char *dev, uint32_t ip, uint32_t mask, int mtu) {
	assert(dev);

	char *ipstr;
	if (asprintf(&ipstr, "%llu", (long long unsigned) ip) == -1)
		errExit("asprintf");

	char *maskstr;
	if (asprintf(&maskstr, "%llu", (long long unsigned) mask) == -1)
		errExit("asprintf");

	char *mtustr;
	if (asprintf(&mtustr, "%d", mtu) == -1)
		errExit("asprintf");

	sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 7,
		PATH_FNET, "config", "interface", dev, ipstr, maskstr, mtustr);

	free(ipstr);
	free(maskstr);
	free(mtustr);
}
