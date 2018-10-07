 /*
 * Copyright (C) 2014-2018 Firejail Authors
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

#include "fnet.h"
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <net/if_arp.h>
#include <net/route.h>
#include <linux/if_bridge.h>

static void check_if_name(const char *ifname) {
	if (strlen(ifname) > IFNAMSIZ) {
		fprintf(stderr, "Error fnet: invalid network device name %s\n", ifname);
		exit(1);
	}
}

// add a veth device to a bridge
void net_bridge_add_interface(const char *bridge, const char *dev) {
	check_if_name(bridge);
	check_if_name(dev);

	// somehow adding the interface to the bridge resets MTU on bridge device!!!
	// workaround: restore MTU on the bridge device
	// todo: put a real fix in
	int mtu1 = net_get_mtu(bridge);

	struct ifreq ifr;
	int err;
	int ifindex = if_nametoindex(dev);

	if (ifindex <= 0)
		errExit("if_nametoindex");

	int sock;
	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
              	errExit("socket");

	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, bridge, IFNAMSIZ - 1);
#ifdef SIOCBRADDIF
	ifr.ifr_ifindex = ifindex;
	err = ioctl(sock, SIOCBRADDIF, &ifr);
	if (err < 0)
#endif
	{
		unsigned long args[4] = { BRCTL_ADD_IF, ifindex, 0, 0 };

		ifr.ifr_data = (char *) args;
		err = ioctl(sock, SIOCDEVPRIVATE, &ifr);
	}
	(void) err;
	close(sock);

	int mtu2 = net_get_mtu(bridge);
	if (mtu1 != mtu2)
		net_set_mtu(bridge, mtu1);
}


// bring interface up
void net_if_up(const char *ifname) {
	check_if_name(ifname);

	int sock = socket(AF_INET,SOCK_DGRAM,0);
	if (sock < 0)
		errExit("socket");

	// get the existing interface flags
	struct ifreq ifr;
	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ - 1);
	ifr.ifr_addr.sa_family = AF_INET;

	// read the existing flags
	if (ioctl(sock, SIOCGIFFLAGS, &ifr ) < 0)
		errExit("ioctl");

	ifr.ifr_flags |= IFF_UP;

	// set the new flags
	if (ioctl( sock, SIOCSIFFLAGS, &ifr ) < 0)
		errExit("ioctl");

	// checking
	// read the existing flags
	if (ioctl(sock, SIOCGIFFLAGS, &ifr ) < 0)
		errExit("ioctl");

	// wait not more than 500ms for the interface to come up
	int cnt = 0;
	while (cnt < 50) {
		usleep(10000);			  // sleep 10ms

		// read the existing flags
		if (ioctl(sock, SIOCGIFFLAGS, &ifr ) < 0)
			errExit("ioctl");
		if (ifr.ifr_flags & IFF_RUNNING)
			break;
		cnt++;
	}

	close(sock);
}

int net_get_mtu(const char *ifname) {
	check_if_name(ifname);
	int mtu = 0;
	int s;
	struct ifreq ifr;

	if ((s = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
		errExit("socket");

	memset(&ifr, 0, sizeof(ifr));
	ifr.ifr_addr.sa_family = AF_INET;
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ - 1);
	if (ioctl(s, SIOCGIFMTU, (caddr_t)&ifr) == 0)
		mtu = ifr.ifr_mtu;
	close(s);


	return mtu;
}

void net_set_mtu(const char *ifname, int mtu) {
	check_if_name(ifname);
	int s;
	struct ifreq ifr;

	if ((s = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
		errExit("socket");

	memset(&ifr, 0, sizeof(ifr));
	ifr.ifr_addr.sa_family = AF_INET;
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ - 1);
	ifr.ifr_mtu = mtu;
	if (ioctl(s, SIOCSIFMTU, (caddr_t)&ifr) != 0) {
		if (!arg_quiet)
			fprintf(stderr, "Warning fnet: cannot set mtu for interface %s\n", ifname);
	}
	close(s);
}

// scan interfaces in current namespace and print IP address/mask for each interface
void net_ifprint(int scan) {
	uint32_t ip;
	uint32_t mask;
	struct ifaddrs *ifaddr, *ifa;

	if (getifaddrs(&ifaddr) == -1)
		errExit("getifaddrs");

	fmessage("%-17.17s%-19.19s%-17.17s%-17.17s%-6.6s\n",
		"Interface", "MAC", "IP", "Mask", "Status");
	// walk through the linked list
	for (ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
		if (ifa->ifa_addr == NULL)
			continue;

		if (ifa->ifa_addr->sa_family == AF_INET) {
			struct sockaddr_in *si = (struct sockaddr_in *) ifa->ifa_netmask;
			mask = ntohl(si->sin_addr.s_addr);
			si = (struct sockaddr_in *) ifa->ifa_addr;
			ip = ntohl(si->sin_addr.s_addr);

			// interface status
			char *status;
			if (ifa->ifa_flags & IFF_RUNNING && ifa->ifa_flags & IFF_UP)
				status = "UP";
			else
				status = "DOWN";

			// ip address and mask
			char ipstr[30];
			sprintf(ipstr, "%d.%d.%d.%d", PRINT_IP(ip));
			char maskstr[30];
			sprintf(maskstr, "%d.%d.%d.%d", PRINT_IP(mask));

			// mac address
			unsigned char mac[6];
			net_get_mac(ifa->ifa_name, mac);
			char macstr[30];
			if (strcmp(ifa->ifa_name, "lo") == 0)
				macstr[0] = '\0';
			else
				sprintf(macstr, "%02x:%02x:%02x:%02x:%02x:%02x", PRINT_MAC(mac));

			// print
			fmessage("%-17.17s%-19.19s%-17.17s%-17.17s%-6.6s\n",
				ifa->ifa_name, macstr, ipstr, maskstr, status);

			// network scanning
			if (!scan)				// scanning disabled
				continue;
			if (strcmp(ifa->ifa_name, "lo") == 0)	// no loopbabck scanning
				continue;
			if (mask2bits(mask) < 16)		// not scanning large networks
				continue;
			if (!ip)					// if not configured
				continue;
			// only if the interface is up and running
			if (ifa->ifa_flags & IFF_RUNNING && ifa->ifa_flags & IFF_UP)
				arp_scan(ifa->ifa_name, ip, mask);
		}
	}
	freeifaddrs(ifaddr);
}

int net_get_mac(const char *ifname, unsigned char mac[6]) {
	check_if_name(ifname);

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

// configure interface ipv4 address
void net_if_ip(const char *ifname, uint32_t ip, uint32_t mask, int mtu) {
	check_if_name(ifname);
	int sock = socket(AF_INET,SOCK_DGRAM,0);
	if (sock < 0)
		errExit("socket");

	struct ifreq ifr;
	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ - 1);
	ifr.ifr_addr.sa_family = AF_INET;

	((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr.s_addr = htonl(ip);
	if (ioctl( sock, SIOCSIFADDR, &ifr ) < 0)
		errExit("ioctl");

	if (ip != 0) {
		((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr.s_addr =  htonl(mask);
		if (ioctl( sock, SIOCSIFNETMASK, &ifr ) < 0)
			errExit("ioctl");
	}

	// configure mtu
	if (mtu > 0) {
		ifr.ifr_mtu = mtu;
		if (ioctl( sock, SIOCSIFMTU, &ifr ) < 0)
			errExit("ioctl");
	}

	close(sock);
	usleep(10000);				  // sleep 10ms
	return;
}

int net_if_mac(const char *ifname, const unsigned char mac[6]) {
	check_if_name(ifname);
	struct ifreq ifr;
	int sock;

	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
              	errExit("socket");

	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ - 1);
	ifr.ifr_hwaddr.sa_family = ARPHRD_ETHER;
	memcpy(ifr.ifr_hwaddr.sa_data, mac, 6);

	if (ioctl(sock, SIOCSIFHWADDR, &ifr) == -1)
		errExit("ioctl");
	close(sock);
	return 0;
}

// configure interface ipv6 address
// ex: firejail --net=eth0 --ip6=2001:0db8:0:f101::1/64
struct ifreq6 {
	struct in6_addr ifr6_addr;
	uint32_t ifr6_prefixlen;
	unsigned int ifr6_ifindex;
};
void net_if_ip6(const char *ifname, const char *addr6) {
	check_if_name(ifname);
	if (strchr(addr6, ':') == NULL) {
		fprintf(stderr, "Error fnet: invalid IPv6 address %s\n", addr6);
		exit(1);
	}

	// extract prefix
	unsigned long prefix;
	char *ptr;
	if ((ptr = strchr(addr6, '/'))) {
		prefix = atol(ptr + 1);
		if (prefix > 128) {
			fprintf(stderr, "Error fnet: invalid prefix for IPv6 address %s\n", addr6);
			exit(1);
		}
		*ptr = '\0';	// mark the end of the address
	}
	else
		prefix = 128;

	// extract address
	struct sockaddr_in6 sin6;
	memset(&sin6, 0, sizeof(sin6));
	sin6.sin6_family = AF_INET6;
	int rv = inet_pton(AF_INET6, addr6, sin6.sin6_addr.s6_addr);
	if (rv <= 0) {
		fprintf(stderr, "Error fnet: invalid IPv6 address %s\n", addr6);
		exit(1);
	}

	// open socket
	int sock = socket(PF_INET6, SOCK_DGRAM, IPPROTO_IP);
	if (sock < 0) {
		fprintf(stderr, "Error fnet: IPv6 is not supported on this system\n");
		exit(1);
	}

	// find interface index
	struct ifreq ifr;
	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ - 1);
	ifr.ifr_addr.sa_family = AF_INET;
	if (ioctl(sock, SIOGIFINDEX, &ifr) < 0) {
		perror("ioctl SIOGIFINDEX");
		exit(1);
	}

	// configure address
	struct ifreq6 ifr6;
	memset(&ifr6, 0, sizeof(ifr6));
	ifr6.ifr6_prefixlen = prefix;
	ifr6.ifr6_ifindex = ifr.ifr_ifindex;
	memcpy((char *) &ifr6.ifr6_addr, (char *) &sin6.sin6_addr, sizeof(struct in6_addr));
	if (ioctl(sock, SIOCSIFADDR, &ifr6) < 0) {
		perror("ioctl SIOCSIFADDR");
		exit(1);
	}

	close(sock);
}
