/*
 * Copyright (C) 2014, 2015 Firejail Authors
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

// scan interfaces in current namespace and print IP address/mask for each interface
void net_ifprint(void) {
	uint32_t ip;
	uint32_t mask;
	struct ifaddrs *ifaddr, *ifa;

	if (getifaddrs(&ifaddr) == -1)
		errExit("getifaddrs");

	printf("%-17.17s%-19.19s%-17.17s%-17.17s%-6.6s\n",
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
			printf("%-17.17s%-19.19s%-17.17s%-17.17s%-6.6s\n",
				ifa->ifa_name, macstr, ipstr, maskstr, status);

			// network scanning
			if (!arg_scan)				// scanning disabled
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

	ifr.ifr_addr.sa_family = AF_INET;
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ);
	if (ioctl(s, SIOCGIFMTU, (caddr_t)&ifr) == 0)
		mtu = ifr.ifr_mtu;
	if (arg_debug)
		printf("MTU of %s is %d.\n", ifname, ifr.ifr_mtu);
	close(s);
	
	
	return mtu;
}

void net_set_mtu(const char *ifname, int mtu) {
	if (strlen(ifname) > IFNAMSIZ) {
		fprintf(stderr, "Error: invalid network device name %s\n", ifname);
		exit(1);
	}

	if (arg_debug)
		printf("set interface %s MTU %d.\n", ifname, mtu);

	int s;
	struct ifreq ifr;

	if ((s = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
		errExit("socket");

	ifr.ifr_addr.sa_family = AF_INET;
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ);
	ifr.ifr_mtu = mtu;
	if (ioctl(s, SIOCSIFMTU, (caddr_t)&ifr) == 0)
		mtu = ifr.ifr_mtu;
	close(s);
}

// return -1 if the interface was not found; if the interface was found retrn 0 and fill in IP address and mask
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
	
	int sock = socket(AF_INET,SOCK_DGRAM,0);
	if (sock < 0)
		errExit("socket");

	// get the existing interface flags
	struct ifreq ifr;
	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ);
	ifr.ifr_addr.sa_family = AF_INET;

	// read the existing flags
	if (ioctl(sock, SIOCGIFFLAGS, &ifr ) < 0) {
		close(sock);
		errExit("ioctl");
	}

	ifr.ifr_flags |= IFF_UP;

	// set the new flags
	if (ioctl( sock, SIOCSIFFLAGS, &ifr ) < 0) {
		close(sock);
		errExit("ioctl");
	}

	// checking
	// read the existing flags
	if (ioctl(sock, SIOCGIFFLAGS, &ifr ) < 0) {
		close(sock);
		errExit("ioctl");
	}

	// wait not more than 500ms for the interface to come up
	int cnt = 0;
	while (cnt < 50) {
		usleep(10000);			  // sleep 10ms

		// read the existing flags
		if (ioctl(sock, SIOCGIFFLAGS, &ifr ) < 0) {
			close(sock);
			errExit("ioctl");
		}
		if (ifr.ifr_flags & IFF_RUNNING)
			break;
		cnt++;
	}

	close(sock);
}

// configure interface
void net_if_ip(const char *ifname, uint32_t ip, uint32_t mask, int mtu) {
	if (strlen(ifname) > IFNAMSIZ) {
		fprintf(stderr, "Error: invalid network device name %s\n", ifname);
		exit(1);
	}
	if (arg_debug)
		printf("configure interface %s\n", ifname);

	int sock = socket(AF_INET,SOCK_DGRAM,0);
	if (sock < 0)
		errExit("socket");

	struct ifreq ifr;
	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ);
	ifr.ifr_addr.sa_family = AF_INET;

	((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr.s_addr = htonl(ip);
	if (ioctl( sock, SIOCSIFADDR, &ifr ) < 0) {
		close(sock);
		errExit("ioctl");
	}

	if (ip != 0) {
		((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr.s_addr =  htonl(mask);
		if (ioctl( sock, SIOCSIFNETMASK, &ifr ) < 0) {
			close(sock);
			errExit("ioctl");
		}
	}
	
	// configure mtu
	if (mtu > 0) {
		ifr.ifr_mtu = mtu;
		if (ioctl( sock, SIOCSIFMTU, &ifr ) < 0) {
			close(sock);
			errExit("ioctl");
		}
	}

	close(sock);
	usleep(10000);				  // sleep 10ms
}


// add an IP route, return -1 if error, 0 if the route was added
int net_add_route(uint32_t ip, uint32_t mask, uint32_t gw) {
	int sock;
	struct rtentry route;
	struct sockaddr_in *addr;
	int err = 0;

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
	if ((err = ioctl(sock, SIOCADDRT, &route)) != 0) {
		close(sock);
		return -1;
	}

	close(sock);
	return 0;
}


// add a veth device to a bridge
void net_bridge_add_interface(const char *bridge, const char *dev) {
	if (strlen(bridge) > IFNAMSIZ) {
		fprintf(stderr, "Error: invalid network device name %s\n", bridge);
		exit(1);
	}

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
	strncpy(ifr.ifr_name, bridge, IFNAMSIZ);
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
	if (mtu1 != mtu2) {
		if (arg_debug)
			printf("Restoring MTU for %s\n", bridge);
		net_set_mtu(bridge, mtu1);
	}
}

#define BUFSIZE 1024
uint32_t network_get_defaultgw(void) {
	FILE *fp = fopen("/proc/self/net/route", "r");
	if (!fp)
		errExit("fopen");
	
	char buf[BUFSIZE];
	uint32_t retval = 0;
	while (fgets(buf, BUFSIZE, fp)) {
		if (strncmp(buf, "Iface", 5) == 0)
			continue;
		
		char *ptr = buf;
		while (*ptr != ' ' && *ptr != '\t')
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
	struct ifreq ifr;
	int sock;

	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
              	errExit("socket");

	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ);
	ifr.ifr_hwaddr.sa_family = ARPHRD_ETHER;
	memcpy(ifr.ifr_hwaddr.sa_data, mac, 6);
	
	if (ioctl(sock, SIOCSIFHWADDR, &ifr) == -1)
		errExit("ioctl");
	close(sock);
	return 0;
}

int net_get_mac(const char *ifname, unsigned char mac[6]) {

	struct ifreq ifr;
	int sock;

	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
              	errExit("socket");

	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ);
	ifr.ifr_hwaddr.sa_family = ARPHRD_ETHER;
	
	if (ioctl(sock, SIOCGIFHWADDR, &ifr) == -1)
		errExit("ioctl");
	memcpy(mac, ifr.ifr_hwaddr.sa_data, 6);

	close(sock);
	return 0;
}
